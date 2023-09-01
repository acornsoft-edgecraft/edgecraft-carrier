#!/bin/sh

set -eEx
VERSION="0.71.11"

# add charts repo
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

# download charts
helm pull --untar -d ./assets jaegertracing/jaeger --version ${VERSION}
