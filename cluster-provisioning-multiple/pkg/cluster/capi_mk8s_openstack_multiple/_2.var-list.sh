#!/bin/bash

clusterctl --kubeconfig=./kubeconfig generate cluster mk8s-os-cluster --from ./cluster-template-openstack.yaml --list-variables