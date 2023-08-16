#!/bin/sh

# apply spark namespace/account/role/rolebinding
kubectl apply -f spark_ns_account.yaml --kubeconfig ../../88apps.kubeconfig