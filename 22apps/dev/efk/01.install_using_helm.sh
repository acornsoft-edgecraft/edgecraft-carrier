#!/bin/sh

set -eEx

VERSION="7.10.2"
KUBECONFIG="../../88apps.kubeconfig"

# create kubernetes namespace for efk
kubectl create namespace efk --kubeconfig=${KUBECONFIG}

# install using helm
helm install elasticsearch ./assets/elasticsearch -f ./examples/elasticsearch_values.yaml --version ${VERSION} -n efk --kubeconfig=${KUBECONFIG}
helm install kibana ./assets/kibana -f ./examples/kibana_values.yaml --version ${VERSION} -n efk --kubeconfig=${KUBECONFIG}
helm install fluent-bit ./assets/fluent-bit -f ./examples/fluentbit_values.yaml -n efk --kubeconfig=${KUBECONFIG}
