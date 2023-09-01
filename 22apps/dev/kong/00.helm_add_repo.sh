#!/bin/sh

set -eEx
VERSION="2.26.4"

# add charts repo
helm repo add kong https://charts.konghq.com
helm repo update

# download charts
helm pull --untar -d ./assets kong/kong --version ${VERSION}
