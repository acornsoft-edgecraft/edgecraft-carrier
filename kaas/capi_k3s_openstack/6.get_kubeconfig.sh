#!/bin/bash

source ./cluster-template-openstack.rc
clusterctl get kubeconfig ${CLUSTER_NAME} > ./kubeconfig  