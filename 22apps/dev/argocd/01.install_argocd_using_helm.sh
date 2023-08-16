#!/bin/sh

# install argocd to kubernetes using helm
helm upgrade --cleanup-on-fail \
    --install argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --values ./examples/helm/config.yaml \
    --kubeconfig ../../88apps.kubeconfig