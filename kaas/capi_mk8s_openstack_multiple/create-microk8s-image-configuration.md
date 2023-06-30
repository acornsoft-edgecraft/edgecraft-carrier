
## OS 최초 부팅 시 오류 메시지 해결


```sh
## step-1. GPT 오류 해결
# 에러 메시지 : GPT: Use GNU Parted to correct GPT errors.
$ apt-get update
$ apt-get install -y parted

## load module 오류 해결
# failed to load module mdraid: libbd_mdraid.so.2: cannot open shared object file: No such file or directory
$ sudo apt-get install -y libblockdev-mdraid2
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

## 패키기 업그레이드

```sh
## step-
$ apt-get -y upgrade
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
$ echo "/var/snap       IN_ALL_EVENTS,IN_ONESHOT        /opt/scripts/copy_to_containerd_toml.sh" > /var/spool/incron/root

# ## change_hostname.sh 내용
# $ mkdir -p /opt/scripts
# $ vi /opt/scripts/change_hostname.sh
# #!/bin/bash

# ## local-hostname 비교후 hostname 변경
# get_metadata=`curl http://169.254.169.254/latest/meta-data/local-hostname`

# if [ $get_metadata != "" ]; then
#   if [ $get_metadata != $(hostname) ]; then
#     # echo "/var/snap       IN_CREATE,IN_ISDIR          /opt/scripts/copy_to_containerd_toml.sh \$@ \$#" > /var/spool/incron/root
#     echo "/capi-scripts/        IN_CREATE       /opt/scripts/copy_to_containerd_toml.sh \$@ \$#" > /var/spool/incron/root
#     hostnamectl set-hostname $get_metadata
#     reboot
#   else
#     # echo "/var/snap IN_CREATE,IN_ISDIR  /opt/scripts/copy_to_containerd_toml.sh \$@ \$#" > /var/spool/incron/root
#     echo "/capi-scripts/        IN_CREATE       /opt/scripts/copy_to_containerd_toml.sh \$@ \$#" > /var/spool/incron/root
#     systemctl restart incron.service
#   fi
# fi
```

-  기본 쉘을 생성한다.

```sh
## step-1. failed 서비스 재시작 쉘스크립트
# 
$ vi /capi-scripts/check_service.sh
#!/bin/bash

count=0
while systemctl list-units --type=service --state=failed | grep microk8s; do
  count=$(( count +1 ))
  for i in $(systemctl list-units --type=service --state=failed | grep microk8s | awk '{print $2}')
  do
    systemctl start $i
  done
  sleep 5
  if [ $count -ge 10  ]; then
    reboot
  fi
done

## step-2. docker.io mirror 구성 쉘스크립트
#
$ vi /capi-scripts/add-docker-io.sh
#!/bin/bash

cat <<EOF > /var/snap/microk8s/current/args/certs.d/docker.io/hosts.toml
server = "https://docker.io"

[host."https://192.168.88.206/v2/docker.io/"]
  capabilities = ["pull", "resolve"]
  ca = "/etc/docker/certs.d/192.168.88.206/ca.crt"
  override_path = true
EOF

## step-3. chekc microk8s status 쉘스크립트
#
$ vi /capi-scripts/microk8s-status.sh
#!/bin/bash

## chekc microk8s status
while true;
do
  result=$(microk8s status --format yaml | grep "running:" | awk '{print $2}')
  if [[ $result == "False" ]]; then
    error=$(systemctl status snap.microk8s.daemon-containerd.service | grep -io "level=error")
    if [[ -n $error ]]; then
      while ! snap restart microk8s.daemon-containerd; do
        sleep 5
      done
    fi
  else
    break;
  fi
  sleep 2
done

## step-4. microk8s refresh-certs 체크 쉘스크립트 추가
$ vi /capi-scripts/microk8s-certs.sh
#!/bin/bash

while ! diff /var/snap/microk8s/current/certs/ca.crt /var/tmp/ca.crt; do
  echo "microk8s refresh-certs failed will retry."
  while ! microk8s refresh-certs /var/tmp; do
    sleep 5
  done
  sleep 2
done

## step-5. 쉘스크립트 실행권한 추가ㄴ
$ chmod +x /capi-scripts/check_service.sh
$ chmod +x /capi-scripts/add-docker-io.sh
$ chmod +x /capi-scripts/microk8s-status.sh
$ chmod +x /capi-scripts/microk8s-certs.sh
```

### private registry mirror 구성을 위한 설정

```sh
## step-1. 변경 쉘스크립트 생성
$ vi /opt/scripts/copy_to_containerd_toml.sh
#!/bin/bash

## snap auto-refresh 연기
snap refresh --hold=1h

## snap microk8s 설치시 container 설정 변경 for private registry mirror구성
script_path="/capi-scripts"
file_name_0="00-install-microk8s.sh"
file_name_1="10-configure-cert-for-lb.sh"
file_name_2="10-configure-apiserver.sh"
file_name_3="20-microk8s-join.sh"
file_name_4="10-configure-kubelet.sh"
file_name_5="30-configure-traefik.sh"
file_name_6="10-configure-containerd-proxy.sh"
file_name_7="10-configure-calico-ipip.sh"
check_str="containerd"
add_script="while ! snap restart microk8s.daemon-containerd; do\n    sleep 5\ndone"
check_service="source \/capi-scripts\/check_service.sh"
docker_io="source \/capi-scripts\/add-docker-io.sh"
microk8s_status="source \/capi-scripts\/microk8s-status.sh"
microk8s_certs="source \/capi-scripts\/microk8s-certs.sh"

if resutl=$(ls "$script_path/$file_name_6" > /dev/null 2>&1); then
  ## 10-configure-containerd-proxy.sh - containerd 설정에 docker mirror 주소 추가
  result=$(grep "$docker_io" $script_path/$file_name_6)
  if [[ -z $result ]]; then
    sed -i -r -e "/installed/a\\$docker_io" $script_path/$file_name_6
  fi
fi

if resutl=$(ls "$script_path/$file_name_7" > /dev/null 2>&1); then
  ## 10-configure-calico-ipip.sh - 인증서 체크후 인증서가 틀리면 microk8s refresh-certs 재시작
  result=$(grep "$microk8s_certs" $script_path/$file_name_7)
  if [[ -z $result ]]; then
    sed -i -r -e "/cluster/a\\$microk8s_certs" $script_path/$file_name_7
  fi
fi

if resutl=$(ls "$script_path/$file_name_1" > /dev/null 2>&1); then
  # 10-configure-cert-for-lb.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "$check_str" $script_path/$file_name_1)
  if [[ -z  "$result" ]]; then
    sed -i -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_1
  fi
fi

if resutl=$(ls "$script_path/$file_name_2" > /dev/null 2>&1); then
  ## 10-configure-apiserver.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "$check_str" $script_path/$file_name_2)
  if [[ -z  "$result" ]]; then
    sed -i -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_2
  fi
fi

if resutl=$(ls "$script_path/$file_name_3" > /dev/null 2>&1); then
  ## 20-microk8s-join.sh - 구문 오류 수정 추가
  result=$(grep "if ! microk8s" $script_path/$file_name_3)
  if [[ -n  "$result" ]]; then
    sed -i -r -e "s/if ! microk8s/if microk8s/g" $script_path/$file_name_3
  fi

  ## 20-microk8s-join.sh - 구문 오류 수정 추가
  result=$(grep "^then" $script_path/$file_name_3)
  if [[ -n  "$result" ]]; then
    sed -i -r -e "s/^then/fi/g" $script_path/$file_name_3
  fi

  ## 20-microk8s-join.sh - 서비스 failed 체크 추가
  result=$(grep "check_service" $script_path/$file_name_3)
  if [[ -z  "$result" ]]; then
    sed -i -r -e "\$s/\$/\n\n\\$check_service/" $script_path/$file_name_3
  fi
fi

if resutl=$(ls "$script_path/$file_name_4" > /dev/null 2>&1); then
  ## 10-configure-kubelet.sh - microk8s.daemon-containerd restart 추가
  result=$(grep "$microk8s_status" $script_path/$file_name_4)
  if [[ -n  "$result" ]]; then
    sed -i -r -e "/exit 0/i\\$microk8s_status" $script_path/$file_name_4
  fi
fi

## 마지막 실행 쉘스크립트
if resutl=$(ls "$script_path/$file_name_5" > /dev/null 2>&1); then
  ## 30-configure-traefik.sh - 서비스 failed 체크 추가
  result=$(grep "check_service" $script_path/$file_name_5)
  if [[ -z  "$result" ]]; then
    sed -i -r -e "\$s/\$/\n\n\\$check_service/" $script_path/$file_name_5
  fi

echo "" > /var/spool/incron/root
systemctl stop incron.service
fi

## step-4. 실행 권한 부여
$ chmod +x /opt/scripts/change_hostname.sh
$ chmod +x /opt/scripts/copy_to_containerd_toml.sh

## step-5. private registry 인증서 복사
$ mkdir -p /etc/docker/certs.d/192.168.88.206
$ curl -k -L https://192.168.88.206/ca.crt > /etc/docker/certs.d/192.168.88.206/ca.crt
$ cat /etc/docker/certs.d/192.168.88.206/ca.crt
```

## OS 이미지 확인

```sh
## step-1. reboot후 syslog에서 error 사항을 확인 한다.

## step-2. icrontab 설정을 초기화 한다.
$ incrontab -l
/var/snap       IN_CREATE,IN_ISDIR          /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args $#

$ echo "/var/snap       IN_ALL_EVENTS,IN_ONESHOT        /opt/scripts/copy_to_containerd_toml.sh" > /var/spool/incron/root

## step-4. incrond 서비스 재시작 / 필요없는 로그를 정리 후 종료 한다.
$ systemctl restart incron.service
$ echo "" > /var/log/syslog
$ shutdown now
```

## 오픈스택 이미지로 만들기

- 참고: 쉘스크립트 내용
```sh
#!/bin/sh

TARGET="$1"

error_exit() {
        echo "error: ${1:-"unknown error"}" 1>&2
        exit 1
}

main() {
        if [ "$#" -ne 1 ]; then
                echo "vol-resize.sh volume"
                error_exit "Illegal number of parameters."
        fi

        echo "vol-resize.sh $TARGET"

        mv ${TARGET} ${TARGET}_bak

        qemu-img convert -c -p ${TARGET}_bak  -O qcow2 ${TARGET}

        echo "completed."
}

main "${@}"
```
 
- 실행 단계별 설명

```sh
## step-1. 오픈스택 노드에서 볼륨을 백업후 볼률 사이즈를 실제 사이즈로 줄인다.
$ cd /data/hdd/cinder/cinder_state
$ cp <file name> /data/hdd/tmp
$ cd /data/hdd/tmp

$ qemu-img convert -c -p <file name> -O qcow2 edgecraft-microk8s.qcow2 

## step-2. 볼륨/이미지 정보 확인
$ qemu-img info edgecraft-microk8s.qcow2

## step-3. 오픈스택 이미지 생성
$ openstack image create --disk-format qcow2 --container-format bare --public --file ./edgecraft-microk8s.qcow2 edgecraft-microk8s
```

