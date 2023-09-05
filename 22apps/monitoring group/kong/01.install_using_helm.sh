#!/bin/sh

set -eEx
VERSION="2.26.4"

# install using helm
helm upgrade --install kong ./assets/kong -f ./examples/values.yaml -n kong --create-namespace --version ${VERSION} --set ingressController.installCRDs=false
