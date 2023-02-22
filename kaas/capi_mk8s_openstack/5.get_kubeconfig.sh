#!/bin/bash

ource ./cluster-template-openstack.rc
clusterctl get kubeconfig ${CLUSTER_NAME} > ./kubeconfig  