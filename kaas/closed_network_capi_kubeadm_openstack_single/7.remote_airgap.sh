#!/bin/bash

target_id_rsa=~/DEV_WORKS/cert_ssh/acloud/id_rsa
target_node=`cat ./clusters_kubeconfig/pass-kubeadm-provisioning-1 | grep "server: https://" | awk -F '//' '{ print $2}' | awk -F ':' '{ print $1 }'`
target_path=/home/ubuntu/closed_network_capi_kubeadm_openstack_single


# 테스트할 호스트 또는 IP 주소를 설정합니다.
target_host="google.com"
if [[ -n "$1" ]]; then
    target_host="$1"
fi

# 특정 포트 (예: 80, 443)를 테스트할 수도 있습니다.
port=80
if [[ -n "$2" ]]; then
    port=$2
fi

scp -i $target_id_rsa ./6.airgap.sh ubuntu@$target_node:$target_path > /dev/null

ssh -i $target_id_rsa ubuntu@$target_node $target_path/6.airgap.sh $target_host $port