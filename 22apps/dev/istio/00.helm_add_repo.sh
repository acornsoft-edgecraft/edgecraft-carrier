#!/bin/sh

set -eEx
VERSION="1.18.2"

# add charts repo
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# download charts
helm pull --untar -d ./assets istio/base --version ${VERSION}
helm pull --untar -d ./assets istio/istiod --version ${VERSION}
