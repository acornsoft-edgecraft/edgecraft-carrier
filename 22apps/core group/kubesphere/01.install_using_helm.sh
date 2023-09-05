#!/bin/bash

set -eE

## helm chart
VERSION="0.3.1"
URL="https://charts.kubesphere.io/main"
RELEASE_NAME="kubesphere"
CHART_NAME="ks-installer"
CHART_VALUES="./assets/${CHART_NAME}/values.yaml"
CHART_DIR="./assets/${CHART_NAME}"

## k8s
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="kubesphere-system"

## dependencies
DEPENDENCIES=""

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add ${RELEASE_NAME} ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
if [[ -z $(ls $CHART_VALUES) ]]; then
    helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}
fi

# install using helm
## Usage:
##   helm upgrade [RELEASE] [CHART] [flags]
helm upgrade ${CHART_NAME} ${CHART_DIR} \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CHART_VALUES} \
    --version ${VERSION} \
    --set registry="192.168.88.206" \
    --set cc.persistence.storageClass="nfs-csi" \
    --set cc.authentication.adminPassword="Pass0000@" \
    --set cc.common.monitoring.endpoint="http://prometheus-operated.monitoring.svc:9090"