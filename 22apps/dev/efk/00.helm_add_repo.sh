#!/bin/sh

set -eEx

VERSION="7.10.2"

# add charts repo
helm repo add elastic https://helm.elastic.co
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

# download charts
helm pull --untar -d ./assets elastic/elasticsearch --version ${VERSION}
helm pull --untar -d ./assets elastic/kibana --version ${VERSION}
helm pull --untar -d ./assets fluent/fluent-bit
