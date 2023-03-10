#!/bin/bash

echo $1
kubectl --kubeconfig=$1 apply -f ./mk8s-os-cluster.yaml