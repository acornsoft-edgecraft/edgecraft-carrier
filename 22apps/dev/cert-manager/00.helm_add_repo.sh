#!/bin/sh

set -eEx

VERSION="v1.12.0"
URL="https://charts.jetstack.io"
RELEASE_NAME="jetstack"
CHART_NAME="cert-manager"

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add ${RELEASE_NAME} ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}