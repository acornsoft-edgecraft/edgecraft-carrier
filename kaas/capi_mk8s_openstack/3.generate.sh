#!/bin/bash

source ./cluster-template-openstack.rc
clusterctl generate cluster mk8s-os-cluster --target-namespace=default --from ./cluster-template-openstack.yaml > mk8s-os-cluster.yaml