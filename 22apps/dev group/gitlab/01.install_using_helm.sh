#!/bin/sh

# create namespace for gitlab
kubectl create namespace gitlab --kubeconfig=../../88apps.kubeconfig

# install using helm
helm install gitlab gitlab/gitlab -f ./examples/helm/values.yaml --wait --kubeconfig ../../88apps.kubeconfig

# check ingress
kubectl get ingress -n gitlab --kubeconfig ../../88apps.kubeconfig

#helm upgrade --cleanup-on-fail -i --create-namespace -n spark-operator spark-operator spark-operator/spark-operator -f ./examples/helm/values.yaml --wait --kubeconfig=../../88apps.kubeconfig