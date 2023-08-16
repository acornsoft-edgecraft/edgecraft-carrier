#!/bin/sh

set -eEx

VERSION="48.2.2"

# add charts repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# download charts
helm pull --untar -d ./assets prometheus-community/kube-prometheus-stack --version ${VERSION}
