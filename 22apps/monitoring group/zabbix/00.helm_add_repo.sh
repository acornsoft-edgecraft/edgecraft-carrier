#!/bin/sh

set -eEx

VERSION="4.0.2"

# add charts repo
helm repo add zabbix-community https://zabbix-community.github.io/helm-zabbix
helm repo update

# download charts
helm pull --untar -d ./assets zabbix-community/zabbix --version ${VERSION}
