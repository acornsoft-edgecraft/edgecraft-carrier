#!/bin/sh

set -eEx
VERSION="1.72.0"

# install using helm
helm upgrade --install kiali-server ./assets/kiali-server -f ./examples/values.yaml -n istio-system --version ${VERSION}
