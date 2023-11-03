## x509 인증성 오류

- microk8s refresh-certs /var/tmp 실행시 오류로 인한 자체 인증서 사용 불가 상태 발생

```sh
## 에러 확인 방법
$ k -n capi-microk8s-control-plane-system logs capi-microk8s-control-plane-controller-manager-68d8976977-k4nhr | grep cluster-81 | grep -i error
1.6880982817342963e+09	ERROR	failed to update MicroK8sControlPlane Status	{"controller": "microk8scontrolplane", "controllerGroup": "controlplane.cluster.x-k8s.io", "controllerKind": "MicroK8sControlPlane", "MicroK8sControlPlane": {"name":"mk8s-os-cluster-81-control-plane","namespace":"default"}, "namespace": "default", "name": "mk8s-os-cluster-81-control-plane", "reconcileID": "2dc56168-43fe-49fd-9442-ee6cbb5de514", "cluster": "mk8s-os-cluster-81", "error": "Get \"https://192.168.88.174:6443/api/v1/nodes\": x509: certificate signed by unknown authority"}

## microk8s 설치 단계중에 "microk8s refresh-certs /var/tmp" 단계에서 cluster api에서 생성한 secret을 통해 인증서를 지정생성할때 오류가 발생한다.
Taking a backup of the current certificates under /var/snap/microk8s/4916/certs-backup/
Jun 30 01:23:14 mk8s-os-cluster-81-control-plane-g9b22 cloud-init[969]: cp: cannot stat '/var/snap/microk8s/4916/certs/sedpmvKzr': No such file or directory
Jun 30 01:23:14 mk8s-os-cluster-81-control-plane-g9b22 cloud-init[969]: Failed to backup the current CA. Command '['cp', '-r', '/var/snap/microk8s/4916/certs', '/var/snap/microk8s/4916/certs-backup/']' returned non-zero exit status 1.

## 정상 메세지
$ microk8s refresh-certs /var/tmp
Validating provided certificates
Taking a backup of the current certificates under /var/snap/microk8s/4916/certs-backup/
Installing provided certificates
Signature ok
subject=C = GB, ST = Canonical, L = Canonical, O = Canonical, OU = Canonical, CN = 127.0.0.1
Getting CA Private Key
Creating new kubeconfig file
Stopped.
Started.

    The CA certificates have been replaced. Kubernetes will restart the pods of your workloads.
```

- 해결 방법 에러를 체크 하기 위해서 쉘 스크립트를 추가 한다.

```sh
## /capi-scripts/10-configure-calico-ipip.sh 가 실행되기 전에 체크 스크립트를 추가 한다.
$ vi microk8s-certs.sh
#!/bin/bash

if result=$(diff /var/snap/microk8s/current/certs/ca.crt /var/tmp/ca.crt); then
  sleep 1
else
  echo "microk8s refresh-certs failed will retry."
  while ! microk8s refresh-certs /var/tmp; do
    sleep 5
  done
fi
```