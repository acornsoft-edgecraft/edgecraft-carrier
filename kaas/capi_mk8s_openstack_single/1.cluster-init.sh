#!/bin/bash

export KUBECONFIG=./kubeconfig
clusterctl init --bootstrap microk8s --control-plane microk8s --infrastructure openstack --config ./clusterctl.yaml