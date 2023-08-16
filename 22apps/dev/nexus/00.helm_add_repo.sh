#!/bin/sh

set -eEx

VERSION="58.1.0"
URL="https://sonatype.github.io/helm3-charts"
RELEASE_NAME="sonatype"
CHART_NAME="nexus-repository-manager"

# add charts repo
helm repo add ${RELEASE_NAME} ${URL}
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}