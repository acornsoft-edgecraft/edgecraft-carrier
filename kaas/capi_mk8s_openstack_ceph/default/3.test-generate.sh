#!/bin/bash
rm -f ./clusters/*.yaml
source ./cluster-template-openstack.rc

COUNT=0
while [ "$COUNT" -lt 30 ]
do
COUNT=$(($COUNT + 1))
clusterctl --kubeconfig=./kubeconfig generate cluster mk8s-os-cluster-$COUNT --target-namespace=default --from ./cluster-template-openstack.yaml > ./clusters/mk8s-os-cluster-$COUNT.yaml
done