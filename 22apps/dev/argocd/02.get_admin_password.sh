#!/bin/sh

# install argocd to kubernetes using helm
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" --kubeconfig ../../88apps.kubeconfig | base64 -d