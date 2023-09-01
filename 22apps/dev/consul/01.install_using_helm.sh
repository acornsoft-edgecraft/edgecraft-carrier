#!/bin/sh

set -eEx
VERSION="1.2.0"


# install using helm
helm upgrade --install consul ./assets/consul -f ./examples/values.yaml -n consul --create-namespace --version ${VERSION}
