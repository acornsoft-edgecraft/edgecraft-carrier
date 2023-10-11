#!/bin/bash

kubeconfig=./kubeconfig
DISABLED_LIST=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'Chart\:' | grep -e 'disabled' -e '\#' | sed "s/:.*$/\-/g" | sed "s/\#//g"))

file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
for i in $file_list
do
    name=`basename $i .yaml`

    kubectl --kubeconfig=$kubeconfig label clusters.cluster.x-k8s.io $name $DISABLED_LIST
done