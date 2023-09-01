#!/bin/sh

set -eEx
VERSION="1.2.0"

# add charts repo
# helm repo add hashicorp https://helm.releases.hashicorp.com
# helm repo update

# download charts
helm pull --untar -d ./assets hashicorp/consul --version ${VERSION}
