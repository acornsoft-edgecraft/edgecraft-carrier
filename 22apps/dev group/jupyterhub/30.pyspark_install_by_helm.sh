#!/bin/sh

# install jupyterhub to kubernetes using helm
helm upgrade --cleanup-on-fail \
    --install pyspark ./assets/pyspark-helm \
    --namespace jhub \
    --create-namespace \
    --values ./examples/helm/pyspark-config.yaml \
    --kubeconfig ../../88apps.kubeconfig