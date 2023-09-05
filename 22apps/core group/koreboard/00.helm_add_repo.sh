#!/bin/sh

set -eEx

VERSION="0.5.5"
URL="https://raw.githubusercontent.com/kore3lab/dashboard/master/scripts/install/kubernetes"
RELEASE_NAME="kore"
CHART_NAME="kore-board"

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add harbor ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}