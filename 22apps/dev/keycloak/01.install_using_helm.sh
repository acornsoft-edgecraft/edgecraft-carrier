#!/bin/sh

set -eE

VERSION="18.4.3"
URL="https://codecentric.github.io/helm-charts"
RELEASE_NAME="codecentric"
CHART_NAME="keycloak"
CART_VALUES="./assets/${CHART_NAME}/values.yaml"

KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="keycloak"

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
    --set service.type="NodePort" \
    --set postgresql.global.storageClass="nfs-csi" \
    --set postgresql.volumePermissions.enabled=true


# Get NodePort
echo "Service NodePort: $(kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} get services keycloak-http -o jsonpath='{.spec.ports[0].nodePort}')"