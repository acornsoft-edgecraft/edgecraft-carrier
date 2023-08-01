#!/bin/sh

set -eE

VERSION="v4.7.1"
URL="https://kubernetes.github.io/ingress-nginx"
RELEASE_NAME="ingress-nginx"
CHART_NAME="ingress-nginx"
CART_VALUES="./assets/${CHART_NAME}/values.yaml"

KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="ingress-nginx"

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add ${RELEASE_NAME} ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
if [[ -z $(ls $CART_VALUES) ]]; then
    helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}
fi

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
    --values ${CART_VALUES} \
    --version ${VERSION} \
    --set controller.admissionWebhooks.certManager.enabled=true \
    --set controller.metrics.enabled=true \
    --set controller.service.type=NodePort