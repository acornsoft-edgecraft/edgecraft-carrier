#!/bin/bash

kubeconfig=./kubeconfig
DISABLED_LIST=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'Chart\:' | grep -e 'disabled' -e '\#' | sed "s/:.*$/\-/g" | sed "s/\#//g"))
kubesphere_delete=false

file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
for i in $file_list
do
    name=`basename $i .yaml`

    kubectl --kubeconfig=$kubeconfig label clusters.cluster.x-k8s.io $name $DISABLED_LIST
    result=`echo $DISABLED_LIST | grep kubesphereChart`
    if [[ -n "$result" ]]; then
        kubesphere_delete=true
    fi
done

## kubesphere delete
if $kubesphere_delete; then
    while helm --kubeconfig=./clusters_kubeconfig/pass-kubeadm-provisioning-1 -n kubesphere-system delete ks-core; do
        sleep 10
        ./7-1.del-kubesphere.sh
        break;
    done
fi