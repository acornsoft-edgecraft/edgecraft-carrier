#!/bin/bash
kubeconfig=./kubeconfig
CCM_ADDONS="./ccm_addons/k3s"

kubectl --kubeconfig=$kubeconfig create configmap openstack-ccm-addon --from-file=$CCM_ADDONS/openstack-ccm.yaml
kubectl --kubeconfig=$kubeconfig create configmap calico-addon --from-file=$CCM_ADDONS/calico.yaml
kubectl --kubeconfig=$kubeconfig apply -f ./ccm-resourceset.yaml