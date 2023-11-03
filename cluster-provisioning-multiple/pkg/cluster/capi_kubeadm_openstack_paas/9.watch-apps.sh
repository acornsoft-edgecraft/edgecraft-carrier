#!/bin/bash

head=`kubectl --kubeconfig=./kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io | awk 'NR==1'`
print=`kubectl --kubeconfig=./kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io --sort-by=.metadata.name | grep pass-kubeadm-provisioning | grep -v csi-driver-nfs | grep -v kubernetes-dashboard`

if [[ -z $print ]]; then
    echo "$head"
    echo "Not Found."
else
    echo "$head"
    echo "$print"
fi
