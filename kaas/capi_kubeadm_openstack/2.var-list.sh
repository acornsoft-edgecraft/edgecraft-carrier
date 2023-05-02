#!/bin/bash

clusterctl --kubeconfig=./kubeconfig generate cluster k8s-os-cluster --from ./cluster-template-openstack.yaml --list-variables