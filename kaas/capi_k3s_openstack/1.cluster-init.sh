#!/bin/bash

export KUBECONFIG=./kubeconfig
clusterctl init --bootstrap k3s --control-plane k3s --config ./clusterctl.yaml
# clusterctl init --bootstrap k3s --control-plane k3s --infrastructure openstack --config ./clusterctl.yaml