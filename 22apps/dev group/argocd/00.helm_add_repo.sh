#!/bin/sh

# add spark-operator repo
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm pull --untar -d ./assets argo/argo-cd
