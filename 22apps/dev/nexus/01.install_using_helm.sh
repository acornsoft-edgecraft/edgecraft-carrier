#!/bin/sh

set -eEx

VERSION="58.1.0"
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="nexus"
NEXUS_CART_VALUES="./assets/nexus-repository-manager/values.yaml"

# install using helm
## Usage:
##   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade nexus sonatype/nexus-repository-manager \
helm upgrade nexus ./assets/nexus-repository-manager \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${NEXUS_CART_VALUES} \
    --version ${VERSION}

# 최초 admin password 검색
POD_NAME=$(kubectl --kubeconfig ${KUBECONFIG} get pods --namespace ${NAMESPACE} -l "app.kubernetes.io/name=nexus-repository-manager,app.kubernetes.io/instance=nexus" -o jsonpath="{.items[0].metadata.name}")
kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} exec -it ${POD_NAME} -- cat /nexus-data/admin.password