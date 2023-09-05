#!/bin/sh

# run application
kubectl apply -f ./examples/python/spark-py-pi.yaml --kubeconfig ../../88apps.kubeconfig

# check jobs
#kubectl get sparkapplication -n spark-work --kubeconfig ../../88apps.kubeconfig

# check driver log
#kubectl -n spark-work logs pyspark-pi-driver --kubeconfig ../../88apps.kubeconfig