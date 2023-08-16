#!/bin/sh

set -eEx

VERSION="1.12.2"
URL="https://helm.goharbor.io"
RELEASE_NAME="harbor"
CHART_NAME="harbor"

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add ${RELEASE_NAME} ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}