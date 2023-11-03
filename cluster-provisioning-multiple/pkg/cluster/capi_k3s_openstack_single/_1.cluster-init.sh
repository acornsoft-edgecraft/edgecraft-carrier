#!/bin/bash

export KUBECONFIG=./kubeconfig
export EXP_CLUSTER_RESOURCE_SET=true

clusterctl init --bootstrap k3s --control-plane k3s --config ./clusterctl.yaml
# clusterctl init --bootstrap k3s --control-plane k3s --infrastructure openstack --config ./clusterctl.yaml