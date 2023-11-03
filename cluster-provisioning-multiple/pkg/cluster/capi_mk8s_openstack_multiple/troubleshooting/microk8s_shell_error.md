# Microk8s의 runcmd 쉘스크립트 오류 발생

## incrond 서비스로 container 설정 할때 같이 쉘스크립트를 변경

```sh
## step-1. root 권한 생성
$ vi /etc/incron.allow
root

## step-2. incrontab role 설정
$ vi /var/spool/incron/root
/var/snap       IN_ALL_EVENTS          /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args $#

## step-3. 변경 쉘스크립트 생성
$ vi /opt/scripts/copy_to_containerd_toml.sh
#!/bin/bash

if [ "$2" == "args" ]; then
  echo "$1      IN_CLOSE_NOWRITE        /opt/scripts/copy_to_containerd_toml.sh /var/snap/microk8s/current/args \$#" > /var/spool/incron/root
fi
if [ "$2" == "containerd" ]; then
  script_path="/capi-scripts"
  file_name_1="10-configure-cert-for-lb.sh"
  file_name_2="10-configure-apiserver.sh"
  file_name_3="20-microk8s-join.sh"
  check_str="daemon-containerd"
  add_script="while ! snap restart microk8s.daemon-containerd; do\n    sleep 5\ndone"

  result=$(grep "$check_str" $script_path/$file_name_1)
  if [ -z  "$result" ]; then
    sed -i'' -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_1
  fi

  result=$(grep "$check_str" $script_path/$file_name_2)
  if [ -z  "$result" ]; then
    sed -i'' -r -e "/snap restart microk8s.daemon-kubelite/i\\$add_script" $script_path/$file_name_2
  fi

  result=$(grep "if ! microk8s" $script_path/$file_name_3)
  if [ -n  "$result" ]; then
    sed -i'' -r -e "s/if ! microk8s/if microk8s/g" $script_path/$file_name_3
  fi

  result=$(grep "^then" $script_path/$file_name_3)
  if [ -n  "$result" ]; then
    sed -i'' -r -e "s/^then/fi/g" $script_path/$file_name_3
  fi

  #echo '/capi-scripts       IN_CREATE          /opt/scripts/copy_to_capi_scripts.sh $@ $#' > /var/spool/incron/root
  echo "" > /var/spool/incron/root
  cp -r /etc/containerd/certs.d/docker.io/hosts.toml "$1/certs.d/docker.io/hosts.toml"
  systemctl stop incron.service
fi

$ chmod +x copy_to_containerd_toml.sh
```