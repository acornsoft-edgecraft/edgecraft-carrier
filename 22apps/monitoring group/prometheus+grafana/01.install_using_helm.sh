#!/bin/sh

set -eEx

VERSION="48.2.2"
KUBECONFIG="../../88apps.kubeconfig"

# install using helm and create namespace
helm upgrade --install prometheus ./assets/kube-prometheus-stack -f ./examples/values.yaml --version ${VERSION} -n monitoring --create-namespace --kubeconfig=${KUBECONFIG}
