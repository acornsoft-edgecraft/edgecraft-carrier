#!/bin/bash

kubectl create configmap openstack-ccm-addon --from-file=./openstack-ccm.yaml
kubectl create configmap calico-addon --from-file=./calico.yaml
kubectl apply -f ./openstack-ccm-resourceset.yaml