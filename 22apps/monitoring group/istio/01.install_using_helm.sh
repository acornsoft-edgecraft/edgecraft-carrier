#!/bin/sh

set -eEx
VERSION="1.18.2"


# install using helm
helm upgrade --install istio-base ./assets/base  -n istio-system --create-namespace --version ${VERSION}

helm upgrade --install istiod ./assets/istiod -f ./examples/values.yaml -n istio-system --version ${VERSION}
