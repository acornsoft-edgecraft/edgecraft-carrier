#!/bin/sh

# kubernetes

kubectl create namespace jhub --kubeconfig ../../88apps.kubeconfig
kubectl create namespace spark --kubeconfig ../../88apps.kubeconfig

kubectl create serviceaccount -n jhub spark --kubeconfig ../../88apps.kubeconfig
kubectl create rolebinding spark-role --clusterrole=edit --serviceaccount=jhub:spark --namespace=spark --kubeconfig ../../88apps.kubeconfig
# We can't override SA in the launcher on per-container basis, so since I've already got a dask SA.
kubectl create rolebinding spark-role-to-dask-acc --clusterrole=edit --serviceaccount=jhub:dask --namespace=spark --kubeconfig ../../88apps.kubeconfig

# spark driver-service
kubectl apply -f holden-driver_service.yaml -n jhub --kubeconfig ../../88apps.kubeconfig