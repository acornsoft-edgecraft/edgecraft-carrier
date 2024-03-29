#!/bin/sh

# create namespace for spark jobs
kubectl create namespace spark-work --kubeconfig=../../88apps.kubeconfig

# install operator with namespace
helm upgrade --cleanup-on-fail -i --create-namespace -n spark-operator spark-operator spark-operator/spark-operator -f ./examples/helm/values.yaml --wait --kubeconfig=../../88apps.kubeconfig

# checking pods are running
kubectl get pods -n spark-operator --kubeconfig=../../88apps.kubeconfig