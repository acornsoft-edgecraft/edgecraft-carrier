#!/bin/sh

# install jupyterhub to kubernetes using helm
helm upgrade --cleanup-on-fail \
    --install jupyterhub jupyterhub/jupyterhub \
    --namespace jhub \
    --create-namespace \
    --version 2.0.0 \
    --values ./examples/helm/holden-config.yaml \
    --kubeconfig ../../88apps.kubeconfig