#!/bin/sh

# add jupyterhub repo
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

# download charts
helm pull --untar -d ./assets jupyterhub/jupyterhub