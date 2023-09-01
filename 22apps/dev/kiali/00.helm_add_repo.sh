#!/bin/sh

set -eEx
VERSION="1.72.0"

# add charts repo
helm repo add kiali https://kiali.org/helm-charts
helm repo update

# download charts
helm pull --untar -d ./assets kiali/kiali-server --version ${VERSION}
