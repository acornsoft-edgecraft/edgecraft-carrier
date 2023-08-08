#!/bin/sh

set -eEx

VERSION="4.0.2"
KUBECONFIG="../../88apps.kubeconfig"

# install using helm
helm upgrade --install zabbix ./assets/zabbix -f ./examples/values.yaml -n monitoring --version ${VERSION} --dependency-update --kubeconfig=${KUBECONFIG} 
