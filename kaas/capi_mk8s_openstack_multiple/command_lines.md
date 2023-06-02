## private registry test command

```sh
$ microk8s ctr --debug image pull --hosts-dir /etc/containerd/certs.d  docker.io/library/nginx:latest
```

## incrontab 설정

- 설치
```sh
$ apt-get install -y incron
```

- root 권한 설정

```sh
## step-1. root 권한 생성
$ vi /etc/incron.allow
root
```

- OS 이미지에서 hostname을 체크 한다.

```sh
## step-1. 처음 icrontabl 설정
$ vi /var/spool/incron/root
/var/snap       IN_ALL_EVENTS        /opt/scripts/change_hostname.sh

## change_hostname.sh 내용
$ vi /opt/scripts/change_hostname.sh
#!/bin/bash

## local-hostname 비교후 hostname 변경
get_metadata=`curl http://169.254.169.254/latest/meta-data/local-hostname`

if [ $get_metadata != "" ]; then
  if [ $get_metadata != $(hostname) ]; then
    echo "/var/snap       IN_CREATE,IN_ISDIR          /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args \$#" > /var/spool/incron/root
    hostnamectl set-hostname $get_metadata
    reboot
  else
    echo "/var/snap       IN_CREATE,IN_ISDIR          /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args \$#" > /var/spool/incron/root
  fi
fi
```

### private registry mirror 구성을 위한 설정

```sh
## step-1. 변경 쉘스크립트 생성
$ vi /opt/scripts/copy_to_containerd_toml.sh
#!/bin/bash

## snap microk8s 설치시 container 설정 변경 for private registry mirror구성
if [ "$2" == "args" ]; then
  echo "$1      IN_CREATE        /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args \$#" > /var/spool/incron/root
  systemctl restart incron.service
fi
if [ "$2" == "containerd.toml" ]; then
  script_path="/capi-scripts"
  file_name_0="00-install-microk8s.sh"
  file_name_1="10-configure-cert-for-lb.sh"
  file_name_2="10-configure-apiserver.sh"
  file_name_3="20-microk8s-join.sh"
  file_name_4="10-configure-kubelet.sh"
  file_name_5="30-configure-traefik.sh"
  check_str="daemon-containerd"
  add_script="while ! snap restart microk8s.daemon-containerd; do\n    sleep 5\ndone"
  check_service="while systemctl list-units --type=service --state=failed \| grep microk8s; do\n  for i in \$(systemctl list-units --type=service --state=failed \| grep microk8s \| awk '{print \$2}')\n  do\n    systemctl start \$i\n  done\n  sleep 5\ndone"
  docker_io=""

  ## 00-install-microk8s.sh - 서비스 failed 체크 추가
  # result=$(grep "$check_service" $script_path/$file_name_0)
  # if [ -z  "$result" ]; then
  #   sed -i -r -e "/done/a\\$check_service" $script_path/$file_name_0
  # fi

  # 10-configure-cert-for-lb.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "$check_str" $script_path/$file_name_1)
  if [ -z  "$result" ]; then
    sed -i -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_1
  fi

  ## 10-configure-apiserver.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "$check_str" $script_path/$file_name_2)
  if [ -z  "$result" ]; then
    sed -i -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_2
  fi

  ## 10-configure-apiserver.sh - 서비스 failed 체크 추가
  # result=$(grep "$check_service" $script_path/$file_name_2)
  # if [ -z  "$result" ]; then
  #   sed -i -r -e "/updated/a\\$check_service" $script_path/$file_name_2
  # fi

  ## 20-microk8s-join.sh - 구문 오류 수정 추가
  result=$(grep "if ! microk8s" $script_path/$file_name_3)
  if [ -n  "$result" ]; then
    sed -i -r -e "s/if ! microk8s/if microk8s/g" $script_path/$file_name_3
  fi

  ## 20-microk8s-join.sh - 구문 오류 수정 추가
  result=$(grep "^then" $script_path/$file_name_3)
  if [ -n  "$result" ]; then
    sed -i -r -e "s/^then/fi/g" $script_path/$file_name_3
  fi

  ## 20-microk8s-join.sh - 서비스 failed 체크 추가
  result=$(grep "$check_service" $script_path/$file_name_3)
  if [ -z  "$result" ]; then
    sed -i -r -e "\$s/\$/\n\n\\$check_service/" $script_path/$file_name_3
  fi

  ## 10-configure-kubelet.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "exit 0" $script_path/$file_name_4)
  if [ -n  "$result" ]; then
    sed -i -r -e "/exit 0/i\\$add_script" $script_path/$file_name_4
    
    ## 10-configure-kubelet.sh - 서비스 failed 체크 추가
    # result=$(grep "$check_service" $script_path/$file_name_4)
    # if [ -z  "$result" ]; then
    #   sed -i -r -e "/exit 0/i\\$check_service" $script_path/$file_name_4
    #   sed -i -r -e "/arguments/a\\$check_service" $script_path/$file_name_4
    # fi
  fi

  ## 30-configure-traefik.sh - 서비스 failed 체크 추가
  result=$(grep "$check_service" $script_path/$file_name_5)
  if [ -z  "$result" ]; then
    sed -i -r -e "\$s/\$/\n\n\\$check_service/" $script_path/$file_name_5
  fi

echo "" > /var/spool/incron/root
cat <<EOF > $1/certs.d/docker.io/hosts.toml
server = "https://docker.io"

[host."https://192.168.88.206/v2/docker.io/"]
  capabilities = ["pull", "resolve"]
  ca = "/etc/docker/certs.d/192.168.88.206/ca.crt"
  override_path = true
EOF

  #cp -r /etc/containerd/certs.d/docker.io/hosts.toml "$1/certs.d/docker.io/hosts.toml"
  systemctl stop incron.service
fi

## step-4. 실행 권한 부여
$ chmod +x copy_to_containerd_toml.sh
```

## containerd 설정

```sh
$ vi /var/snap/microk8s/current/args/containerd-template.toml
## 기존 설정 주석 처리
  # 'plugins."io.containerd.grpc.v1.cri".registry' contains config related to the registry
  [plugins."io.containerd.grpc.v1.cri".registry]
   config_path = "/etc/containerd/certs.d"
   #config_path = "${SNAP_DATA}/args/certs.d" 설정을 변경한다
```
## containerd test

```sh
$ microk8s ctr image pull docker.io/library/nginx:latest --hosts-dir /cet/containerd/certs.d
```
## resolve.conf 설정

```sh
## step-1. DNS 추가
$ vi /etc/systemd/resolved.conf
## DNS 추가
[Resolve]
DNS=1.1.1.1 8.8.8.8 8.8.4.4


## step-2. 서비스 재시작
$ service systemd-resolved restart

## step-3. 확인
$ systemd-resolve --status
```

## edgecraft k8d control plane 로드밸런서 설정

### k8s control plane extra_sans 추가

```sh
## [참고] https://velog.io/@h13m0n/11
## step-1. 인증서 백업
$ mkdir -p /etc/kubernetes/pki/back
$ mv /etc/kubernetes/pki/apiserver.* /etc/kubernetes/pki/back/

## step-2. extra-sans 추가
$ ADD_IP="192.168.88.201,192.168.88.209"
$ kubeadm init phase certs apiserver --apiserver-cert-extra-sans ${ADD_IP}

## step-3. 인증서 확인
$ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
```

### 오픈스택 로드밸런서 생성

```sh
## [참고] https://velog.io/@lijahong/0%EB%B6%80%ED%84%B0-%EC%8B%9C%EC%9E%91%ED%95%98%EB%8A%94-OpenStack-%EA%B3%B5%EB%B6%80-Load-Balancer-Static-Routing
## L4 LB 는 IP 기반의 트래픽 분산 -> AWS 에서 NLB
## L7 LB 는 주소 기반의 트래픽 분산 -> AWS 에서 ALB

## step-1. 로드밸런서 디테일
# 이름: edgecraft-lb
# 서브넷: edge-subnet (필수)

## step-2. 리스너 디테일.
# 이름: edgecraft-lb-listener
# 프로토콜 : TCP (필수)
# 포트: 6443

## step-3. 풀 디테일
# 이름: edgecraft-lb-pool
# 메소드: ROUND_ROBIN

## step-4. 풀 멤버스
## 실제 서비스 노드와 서비스 포트를 지정 한다.
# IP Address: control plane 노드를 선택 한다. 
# Port: 6443

## step-5. 모니터 디테일
# Monitor Type: TCP

## step-6. floating IP를 연결할 수 있다.
```

## etcd 성능 테스트

- [참고 - install benchmark] https://github.com/etcd-io/etcd/tree/main/tools/benchmark
- [참고 - etcd 성능 테스트] https://etcd.io/docs/v3.4/op-guide/performance/

```sh
## step-1. 테스트 환경 설정
$ export ETCD_ENDPOINTS="https://10.10.20.11:2379,https://10.10.20.12:2379,https://10.10.20.13:2379"
$ export | grep -i etcd
declare -x ETCDCTL_API="3"
declare -x ETCDCTL_CACERT="/etc/kubernetes/pki/etcd/ca.crt"
declare -x ETCDCTL_CERT="/etc/kubernetes/pki/etcd/peer.crt"
declare -x ETCDCTL_KEY="/etc/kubernetes/pki/etcd/peer.key"
declare -x ETCD_ENDPOINTS="https://10.10.20.11:2379,https://10.10.20.12:2379,https://10.10.20.13:2379"
declare -x OLDPWD="/root/etcd"
declare -x PWD="/etc/etcd"
root@ubuntu-20-04-master-1:/etc/etcd#

## step-2. 성능 테스트
$ benchmark --endpoints=${ETCD_ENDPOINTS} \
  --conns=100 --clients=1000 --key-size=16 --val-size=100 --total=10000 \
  --cacert=${ETCDCTL_CACERT} --cert=${ETCDCTL_CERT} --key=${ETCDCTL_KEY} put
```

## 오픈스택 메타데이터 검색

- [참고] https://docs.openstack.org/nova/rocky/user/metadata-service.html

```sh
## step-1. 오픈스택 인스탄스 메타데이터 검색
$ curl http://169.254.169.254/latest/meta-data/local-hostname 
```