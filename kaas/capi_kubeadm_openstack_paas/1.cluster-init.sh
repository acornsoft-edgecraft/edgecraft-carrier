#!/bin/bash

export KUBECONFIG=./kubeconfig
clusterctl init --bootstrap kubeadm --control-plane kubeadm

