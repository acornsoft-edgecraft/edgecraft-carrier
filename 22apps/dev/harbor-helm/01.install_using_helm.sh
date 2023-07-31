#!/bin/sh

set -eE

VERSION="1.12.2"
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="harbor"
CHART_NAME="harbor"
HARBOR_CART_VALUES="./assets/${CHART_NAME}/values.yaml"

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
    --values ${HARBOR_CART_VALUES} \
    --version ${VERSION}

# # Get NodePort
echo "Service NodePort: $(kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} get services harbor -o jsonpath='{.spec.ports[1].nodePort}')"