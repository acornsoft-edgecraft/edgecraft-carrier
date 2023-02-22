#!/bin/bash

source ./cluster-template-openstack.rc
clusterctl generate cluster k3s-os-cluster --target-namespace=default --from ./cluster-template-openstack.yaml > k3s-os-cluster.yaml