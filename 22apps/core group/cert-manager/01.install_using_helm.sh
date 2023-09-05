#!/bin/sh

set -eE

VERSION="v1.12.0"
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="cert-manager"
CHART_NAME="cert-manager"
CHART_VALUES="./assets/${CHART_NAME}/values.yaml"

# install using helm
## Usage:
##   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade kore-board kore/kore-board \
helm upgrade ${CHART_NAME} ./assets/${CHART_NAME} \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CHART_VALUES} \
    --version ${VERSION} \
    --set installCRDs=true