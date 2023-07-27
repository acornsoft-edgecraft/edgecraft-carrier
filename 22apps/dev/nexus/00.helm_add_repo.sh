#!/bin/sh

set -eEx

VERSION="58.1.0"

# add charts repo
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull sonatype/nexus-repository-manager --untar -d ./assets --version ${VERSION}