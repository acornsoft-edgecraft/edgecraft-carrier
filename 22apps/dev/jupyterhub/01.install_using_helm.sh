#!/bin/sh

# install jupyterhub to kubernetes using helm
helm upgrade --cleanup-on-fail \
    --install jupyterhub jupyterhub/jupyterhub \
    --namespace jhub \
    --create-namespace \
    --version 2.0.0 \
    --values ./examples/helm/override_values.yaml \
    --kubeconfig ../../88apps.kubeconfig