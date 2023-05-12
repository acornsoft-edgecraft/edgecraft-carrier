#!/bin/bash
rm -f ./clusters/*.yaml
source ./cluster-template-openstack.rc

FILE_NAME="ceph-mk8s-os-cluster"
COUNT=0
while [ "$COUNT" -lt 100 ]
do
COUNT=$(($COUNT + 1))
clusterctl --kubeconfig=./kubeconfig generate cluster $FILE_NAME-$COUNT --target-namespace=default --from ./cluster-template-openstack.yaml > ./clusters/$FILE_NAME-$COUNT.yaml
done