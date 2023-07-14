#!/bin/sh

# create namespace for gitlab
kubectl create namespace gitlab --kubeconfig=../../88apps.kubeconfig

# install using helm
helm install gitlab ./assets/manual -f ./examples/helm/manual_values.yaml --namespace gitlab --wait --kubeconfig ../../88apps.kubeconfig

# check ingress
kubectl get ingress -n gitlab --kubeconfig ../../88apps.kubeconfig