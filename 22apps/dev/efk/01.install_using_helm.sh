#!/bin/sh

set -eEx

VERSION="7.10.2"
FLUENTBIT_VERSION="0.36.0"
KUBECONFIG="../../88apps.kubeconfig"

# create kubernetes namespace for efk
kubectl create namespace efk --kubeconfig=${KUBECONFIG}

# install using helm
helm upgrade --install elasticsearch ./assets/elasticsearch -f ./examples/elasticsearch_values.yaml --version ${VERSION} -n efk --kubeconfig=${KUBECONFIG}
helm upgrade --install kibana ./assets/kibana -f ./examples/kibana_values.yaml --version ${VERSION} -n efk --kubeconfig=${KUBECONFIG}
helm upgrade --install fluent-bit ./assets/fluent-bit -f ./examples/fluentbit_values.yaml --version ${FLUENTBIT_VERSION} -n efk --kubeconfig=${KUBECONFIG}
