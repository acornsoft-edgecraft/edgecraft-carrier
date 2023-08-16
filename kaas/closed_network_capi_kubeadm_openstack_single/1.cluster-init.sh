#!/bin/bash

export KUBECONFIG=./kubeconfig
clusterctl init --bootstrap kubeadm --control-plane kubeadm --infrastructure openstack --config "./clusterctl.yaml"