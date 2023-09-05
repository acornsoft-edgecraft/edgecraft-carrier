#!/bin/sh

set -eEx
VERSION="0.71.11"


# install using helm
helm upgrade --install jaeger ./assets/jaeger -f ./examples/values.yaml -n jaeger --create-namespace --version ${VERSION}
