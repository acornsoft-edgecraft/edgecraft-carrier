#!/bin/bash

rm -f ./clusters/*.yaml
source ./cluster-template-openstack.rc

COUNT=0
while [ "$COUNT" -lt 1 ]
do
COUNT=$(($COUNT + 1))
clusterctl --kubeconfig=./kubeconfig generate cluster admk8s-os-cluster-$COUNT --target-namespace=default --from ./cluster-template-openstack.yaml > ./clusters/admk8s-os-cluster-$COUNT.yaml
done