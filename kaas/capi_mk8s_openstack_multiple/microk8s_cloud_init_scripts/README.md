# Microk8s Scripts

## script가 실행되는 k8s secret 내용

```yaml
## template: jinja
#cloud-config
write_files:
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0
    #
    # Assumptions:
    #   - systemctl is available

    for svc in kubelet containerd; do
      systemctl stop "${svc}" || true
      systemctl disable "${svc}" || true
    done
  path: /capi-scripts/00-disable-host-services.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $microk8s_snap_args
    #
    # Assumptions:
    #   - snap is installed

    while ! snap install microk8s ${1}; do
      echo "Failed to install MicroK8s snap, will retry"
      sleep 5
    done
  path: /capi-scripts/00-install-microk8s.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $endpoint_type $endpoint
    #
    # Assumptions:
    #   - microk8s is installed

    CSR_CONF="${CSR_CONF:-/var/snap/microk8s/current/certs/csr.conf.template}"

    # Configure SAN for the control plane endpoint
    # The apiservice-kicker will recreate the certificates and restart the service as needed
    sed "/^DNS.1 = kubernetes/a${1}.100 = ${2}" -i "${CSR_CONF}"
    sleep 10

    while ! snap set microk8s hack.update.csr=call$$; do
      echo "Failed to call the configure hook, will retry"
      sleep 5
    done
    sleep 10

    while ! snap restart microk8s.daemon-kubelite; do
      sleep 5
    done
    microk8s status --wait-ready
  path: /capi-scripts/10-configure-cert-for-lb.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0
    #
    # Assumptions:
    #   - microk8s is installed
    #   - iptables is installed
    #   - apt is available for installing packages

    APISERVER_ARGS="${APISERVER_ARGS:-/var/snap/microk8s/current/args/kube-apiserver}"
    CREDENTIALS_DIR="${CREDENTIALS_DIR:-/var/snap/microk8s/current/credentials}"

    # Configure command-line arguments for kube-apiserver
    echo "
    --service-node-port-range=30001-32767
    " >> "${APISERVER_ARGS}"

    # Configure apiserver port
    sed 's/16443/6443/' -i "${APISERVER_ARGS}"

    # Configure apiserver port for service config files
    sed 's/16443/6443/' -i "${CREDENTIALS_DIR}/client.config"
    sed 's/16443/6443/' -i "${CREDENTIALS_DIR}/scheduler.config"
    sed 's/16443/6443/' -i "${CREDENTIALS_DIR}/kubelet.config"
    sed 's/16443/6443/' -i "${CREDENTIALS_DIR}/proxy.config"
    sed 's/16443/6443/' -i "${CREDENTIALS_DIR}/controller.config"

    while ! snap set microk8s hack.update.csr=call$$; do
      echo "Failed to call the configure hook, will retry"
      sleep 5
    done
    sleep 10

    while ! snap restart microk8s.daemon-kubelite; do
      sleep 5
    done

    # delete kubernetes service to make sure port is updated
    microk8s status --wait-ready
    microk8s kubectl delete svc kubernetes

    # redirect port 16443 to 6443
    iptables -t nat -A OUTPUT -o lo -p tcp --dport 16443 -j REDIRECT --to-port 6443
    iptables -t nat -A PREROUTING   -p tcp --dport 16443 -j REDIRECT --to-port 6443

    # ensure rules persist across reboots
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install iptables-persistent -y
  path: /capi-scripts/10-configure-apiserver.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 true/false
    #
    # Assumptions:
    #   - microk8s is installed
    #   - calico is installed
    #   - the current node is not part of a cluster (yet)

    if [[ "${1}" = "false" ]]; then
      echo "Will not configure Calico for IPinIP"
      exit 0
    fi

    CNI_YAML="/var/snap/microk8s/current/args/cni-network/cni.yaml"

    # Stop calico-node and delete ippools to ensure no vxlan pools are left around
    microk8s kubectl delete daemonset/calico-node -n kube-system || true
    microk8s kubectl delete ippools --all || true

    # Update cni.yaml manifest for IPIP
    sed 's/CALICO_IPV4POOL_VXLAN/CALICO_IPV4POOL_IPIP/' -i "${CNI_YAML}"
    sed 's/calico_backend: "vxlan"/calico_backend: "bird"/' -i "${CNI_YAML}"
    sed 's/-felix-ready/-bird-ready/' -i "${CNI_YAML}"
    sed 's/-felix-live/-bird-live/' -i "${CNI_YAML}"

    # Apply the new manifest
    # (TODO): this should perhaps be a touch cni-needs-reload
    microk8s kubectl apply -f "${CNI_YAML}"
  path: /capi-scripts/10-configure-calico-ipip.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $new_cluster_agent_port
    #
    # Assumptions:
    #   - microk8s is installed

    sed "s/25000/${1}/" -i "/var/snap/microk8s/current/args/cluster-agent"

    snap restart microk8s.daemon-cluster-agent
  path: /capi-scripts/10-configure-cluster-agent-port.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $http_proxy $https_proxy $no_proxy
    #
    # Assumptions:
    #   - microk8s is installed

    CONTAINERD_ENV="/var/snap/microk8s/current/args/containerd-env"

    echo "# Configuration from ClusterAPI" >> "${CONTAINERD_ENV}"
    need_restart=false

    if [[ "${1}" != "" ]]; then
      echo "http_proxy=${1}" >> "${CONTAINERD_ENV}"
      echo "HTTP_PROXY=${1}" >> "${CONTAINERD_ENV}"
      need_restart=true
    fi

    if [[ "${2}" != "" ]]; then
      echo "https_proxy=${2}" >> "${CONTAINERD_ENV}"
      echo "HTTPS_PROXY=${2}" >> "${CONTAINERD_ENV}"
      need_restart=true
    fi

    if [[ "${3}" != "" ]]; then
      echo "no_proxy=${3}" >> "${CONTAINERD_ENV}"
      echo "NO_PROXY=${3}" >> "${CONTAINERD_ENV}"
      need_restart=true
    fi

    if [[ "$need_restart" = "true" ]]; then
      snap restart microk8s.daemon-containerd
    fi
  path: /capi-scripts/10-configure-containerd-proxy.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $new_dqlite_port
    #
    # Assumptions:
    #   - microk8s is installed
    #   - dqlite has been initialized on the node and is running

    DQLITE="/var/snap/microk8s/current/var/kubernetes/backend"

    grep "Address" "${DQLITE}/info.yaml" | sed "s/19001/${1}/" | tee "${DQLITE}/update.yaml"

    snap restart microk8s.daemon-k8s-dqlite
  path: /capi-scripts/10-configure-dqlite-port.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $endpoint $port $stop_ep_refresh
    #
    # Assumptions:
    #   - microk8s is installed
    #   - microk8s node has joined a cluster as a worker
    #
    # Notes:
    #   - stopping API servers endpoint refreshes should be done only on for 1.25+

    PROVIDER_YAML="/var/snap/microk8s/current/args/traefik/provider.yaml"
    APISERVER_PROXY_ARGS_FILE="/var/snap/microk8s/current/args/apiserver-proxy"

    while ! [ -f "${PROVIDER_YAML}" ]; do
        echo "Waiting for ${PROVIDER_YAML}"
        sleep 5
    done

    if [ ${3} == "yes" ]; then
      sed '/refresh-interval/d' -i "${APISERVER_PROXY_ARGS_FILE}"
      echo "--refresh-interval 0s" >> "${APISERVER_PROXY_ARGS_FILE}"
      snap restart microk8s.daemon-apiserver-proxy
    fi

    # cleanup any addresses from the provider.yaml file
    sed '/address:/d' -i "${PROVIDER_YAML}"

    # add the control plane to the list of addresses
    # currently is using a hack since the list of endpoints is at the end of the file
    echo "        - address: '${1}:${2}'" >> "${PROVIDER_YAML}"
    # no restart is required, the file change is picked up automatically
  path: /capi-scripts/30-configure-traefik.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0
    #
    # Assumptions:
    #   - microk8s is installed
    #   - /var/tmp/extra-kubelet-args exists

    EXTRA_ARGS_FILE="/var/tmp/extra-kubelet-args"
    KUBELET_ARGS="/var/snap/microk8s/current/args/kubelet"

    if [ ! -f "${EXTRA_ARGS_FILE}" ]; then
      echo "No extra kubelet configuration needed"
      exit 0
    fi

    (
      echo ""
      echo "# ClusterAPI configuration"
      cat "${EXTRA_ARGS_FILE}"
      echo ""
    ) >> "${KUBELET_ARGS}"

    # restart kubelite so that kubelet picks up the new arguments
    snap restart microk8s.daemon-kubelite
  path: /capi-scripts/10-configure-kubelet.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $addon1 $addon2 [...]
    #
    # Assumptions:
    #   - microk8s is installed
    #   - microk8s apiserver is up and running

    # enable community addons, this is for free and avoids confusion if addons are failing to install
    microk8s enable community || true

    while [[ "$@" != "" ]]; do
      microk8s enable "$1"
      microk8s status --wait-ready
      shift
    done
  path: /capi-scripts/20-microk8s-enable.sh
  permissions: "0700"
  owner: root:root
- content: |
    #!/bin/bash -xe

    # Usage:
    #   $0 $worker_yes_no $join_string $alternative_join_string
    #
    # Assumptions:
    #   - microk8s is installed
    #   - microk8s node is ready to join the cluster

    join="${2}"
    join_alt="${3}"

    if [ ${1} == "yes" ]; then
      join+=" --worker"
      join_alt+=" --worker"
    fi

    while ! microk8s join ${join}; do
      echo "Failed to join MicroK8s cluster, retring alternative join string"
      if ! microk8s join ${join_alt} ; then
        break
      fi
      echo "Failed to join MicroK8s cluster, will retry"
      sleep 5
    done

    # What is this hack? Why do we call snap set here?
    # "snap set microk8s ..." will call the configure hook.
    # The configure hook is where we sanitise arguments to k8s services.
    # When we join a node to a cluster the arguments of kubelet/api-server
    # are copied from the "control plane" node to the joining node.
    # It is possible some deprecated/removed arguments are copied over.
    # For example if we join a 1.24 node to 1.23 cluster arguments like
    # --network-plugin will cause kubelite to crashloop.
    # Threfore we call the conigure hook to clean things.
    # PS. This should be a workaround to a MicroK8s bug.
    while ! snap set microk8s configure=call$$; do
      echo "Failed to call the configure hook, will retry"
      sleep 5
    done
    sleep 10

    while ! snap restart microk8s.daemon-containerd; do
      sleep 5
    done
    while ! snap restart microk8s.daemon-kubelite; do
      sleep 5
    done
    sleep 10

    if [ ${1} == "no" ]; then
      while ! microk8s status --wait-ready; do
        echo "Waiting for the cluster to come up"
        sleep 5
      done
    then
  path: /capi-scripts/20-microk8s-join.sh
  permissions: "0700"
  owner: root:root
- content: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEA4htxWLYMVz7Bidd4b9qeWIp/Tw9aP/d7/ljgi4/ad/zPXEyi
    VfvdbGeC4iQNpGQUlwj8Ldy45takZNmjygia62VmHRBwQa/nK39p/P7wiz5yZatz
    nZki3Oa8Nw3Yc9wmuVJ3mmc+0n2XX6Ru+hmJzCY3b7nQqY5PjNZK/2WO6WX6H9UK
    OONQsh/Wvj7PWOLLv841+SkqOKmR3m942IzyLp5+qmJgHShn9MMh06JXEEAq7kFN
    +oQbZGvPTqGuKGl39pF+N5vnUk0CtQOpfKL4kBQhjuIGpe2zS2nrwWwE1E+uePDm
    12/UGB+S2f58z+Zc9Wg3uPWHf+qj61guWtu3sQIDAQABAoIBADKr0b/+tE9NChR5
    DE2M4dWX3CX8m84gCVKb2l6Mc3pWVqYpqmu4kQu9OtCxIbmIkDC028bvYySgT6Em
    QRWCzi0YwUScLXwbDqRp3nfLLl8WNI7iWHumGPEGaIGyAaMdYDRB7fnVT3fem3Dc
    qd40oPP2UJAiRUfqU5uNXqtTuC5Ht2lV+PzzoMt8qaVxKnICYqhX3DUvY+ffoDGv
    t/v/h+u0ztJAqf/89TLfafQswZmqRnKgCnRxwsM4d4G7jP+aZhfj68wjqt+ZDOH6
    iO+Uc6NJN08WGgafWE0uRZSscP1bXAPghKJSyhsB3J4lTLtPWvyLxTaOR8jg1LKs
    oMxYaB0CgYEA7aumEino82691YV0tW23jVCyh1suiK0VAE1End7HoARWMVk7C/RK
    ohXhvq13RsHO1sdCU4N97VrFJAW0Vc+txLW0OwxLpa0sWDzzMbnyhEh3qNrGeLK4
    bdfqpUPj1mfF9YHIclftRrKW0KhgDDqaWLNB00cvM4gsE8RSchXeuJ8CgYEA84t/
    pghPEB1FpKoo8SDkbhfpj2YEX382g1sZkfb5ErtcNztODf2xJdzZCopLGsrLDvAi
    U2dZuFSmZRtPkeqeWk0VLzpQHeQEitUVPsdRqfzAEkcA9CqlzZuuf5febsfMIDOU
    cd5trkGlR/1CbUuv2kmqrPvm4cvGNHotVDpena8CgYAcHrT1bTP8qVuYicO3O5X+
    CFA3J5in3yKe+IVn0FX6Hsk76XzM+0hhSQl+j/OO0ZtxWf4E94fMr3Knwm0Fwh6j
    KYR7gAbrQUP/5KY5efCxqglOVyQoX6zmgidnClNIqNqJI6Pds32FYdfqNCG5EK32
    VK8zGjcBd9kPNakzilbhrQKBgDVraMFbWzQ2p3r50+coBtLbLeDFSLpFpghj6BTr
    LjDcpdp7iKBq//tFGNpGATlMOAP7yhuvNK/I6YKN3gMsijVWaQol6ULVK+Xj3Tga
    8h+uD9cyedQUsq+JsVnNTv3Pl0eM6MedOUOapI1I0NQ2YMkplWVCD5+BWeVS0zSB
    ZRWDAoGAXFdNIBR6bN4Qy5p6Tv4daDzh/fbyywAVWJDtm2QHM53wK2tajm5bwkbX
    r5GMLHjzo7RnMqKRxaprapK/9CD7oc8uqOu3+46CX8g62U45JTH/SkQiASM1N+84
    wSe4irlFczyvnoDo/zROMKj8tW+YcDeGPcIPTvDLuPkdkBHbBvk=
    -----END RSA PRIVATE KEY-----
  path: /var/tmp/ca.key
  permissions: "0600"
  owner: root:root
- content: |
    -----BEGIN CERTIFICATE-----
    MIIDszCCApugAwIBAgICB+MwDQYJKoZIhvcNAQELBQAwazELMAkGA1UEBhMCR0Ix
    CTAHBgNVBAgTADESMBAGA1UEBxMJQ2Fub25pY2FsMRIwEAYDVQQJEwlDYW5vbmlj
    YWwxEjAQBgNVBAoTCUNhbm9uaWNhbDEVMBMGA1UEAxMMMTAuMTUyLjE4My4xMB4X
    DTIzMDUxMjAzMDkwN1oXDTMzMDUxMjAzMDkwN1owazELMAkGA1UEBhMCR0IxCTAH
    BgNVBAgTADESMBAGA1UEBxMJQ2Fub25pY2FsMRIwEAYDVQQJEwlDYW5vbmljYWwx
    EjAQBgNVBAoTCUNhbm9uaWNhbDEVMBMGA1UEAxMMMTAuMTUyLjE4My4xMIIBIjAN
    BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4htxWLYMVz7Bidd4b9qeWIp/Tw9a
    P/d7/ljgi4/ad/zPXEyiVfvdbGeC4iQNpGQUlwj8Ldy45takZNmjygia62VmHRBw
    Qa/nK39p/P7wiz5yZatznZki3Oa8Nw3Yc9wmuVJ3mmc+0n2XX6Ru+hmJzCY3b7nQ
    qY5PjNZK/2WO6WX6H9UKOONQsh/Wvj7PWOLLv841+SkqOKmR3m942IzyLp5+qmJg
    HShn9MMh06JXEEAq7kFN+oQbZGvPTqGuKGl39pF+N5vnUk0CtQOpfKL4kBQhjuIG
    pe2zS2nrwWwE1E+uePDm12/UGB+S2f58z+Zc9Wg3uPWHf+qj61guWtu3sQIDAQAB
    o2EwXzAOBgNVHQ8BAf8EBAMCAoQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUF
    BwMBMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFO5/rWqfZrVwIptOMx9SXyur
    /FhtMA0GCSqGSIb3DQEBCwUAA4IBAQBGA0kMckzTQTAncpMKT4rhoNLwR4r88vEK
    cTqg/I3VAEEbR2RA+kZY6N5/582KrckmgLAy2MKcFUqfxG57nz2ydIOqNKawQ050
    BnnW+mb1EsJp+kFUfo17tCYq9DtwhKyYmukdnaVUjiD0E26ahtEZJQxIB3PjC921
    ikAAobhy8TPUQK0fd570e2iBHUFC9US4Ez2+OP5eyC6nMytNBcTKSYgFvNB85q1H
    K+TeyVebZAL0MCP1d9OymSApu0y0GI0hF8V1e9wl1MfOu/9iNbNRFI8w1N6kJw71
    Rm7p/Oj/BNnT6MhHRPaMMqsFMfOparhslhsGMu7ZWDOOsOLNPIKz
    -----END CERTIFICATE-----
  path: /var/tmp/ca.crt
  permissions: "0600"
  owner: root:root
runcmd:
- set -x
- /capi-scripts/00-disable-host-services.sh
- /capi-scripts/00-install-microk8s.sh "--channel 1.23 --classic"
- /capi-scripts/10-configure-containerd-proxy.sh "" "" ""
- /capi-scripts/10-configure-kubelet.sh
- microk8s status --wait-ready
- microk8s refresh-certs /var/tmp
- /capi-scripts/10-configure-calico-ipip.sh false
- /capi-scripts/10-configure-cluster-agent-port.sh "30000"
- /capi-scripts/10-configure-dqlite-port.sh "2379"
- /capi-scripts/10-configure-cert-for-lb.sh "IP" "192.168.88.95"
- /capi-scripts/10-configure-apiserver.sh
- /capi-scripts/20-microk8s-enable.sh "dns" "ingress"
- microk8s add-node --token-ttl 315569260 --token "mHOAhTAbnqhqykLKYxlzjPWEFHTWBehH"
bootcmd: []

```