#!/bin/sh

# add gitlab repo
helm repo add gitlab https://charts.gitlab.io/

# download charts
helm pull --untar -d ./assets gitlab/gitlab