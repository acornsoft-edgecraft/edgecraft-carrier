#!/bin/bash

head=`kubectl --kubeconfig=./kubeconfig get machines.cluster.x-k8s.io | awk 'NR==1'`
print=`kubectl --kubeconfig=./kubeconfig get machines.cluster.x-k8s.io --sort-by=.metadata.name | grep single-kubeadm-provisioning`

if [[ -z $print ]]; then
    echo "$head"
    echo "Not Found."
else
    echo "$head"
    echo "$print"
fi