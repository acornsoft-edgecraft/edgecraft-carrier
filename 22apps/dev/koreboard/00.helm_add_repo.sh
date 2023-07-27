#!/bin/sh

set -eEx

VERSION="0.5.5"

# add charts repo
helm repo add kore https://raw.githubusercontent.com/kore3lab/dashboard/master/scripts/install/kubernetes/
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
helm pull kore/kore-board --untar -d ./assets --version ${VERSION}