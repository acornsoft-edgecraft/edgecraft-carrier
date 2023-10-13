#!/bin/bash

KUBECONFIG="./restore-cloud.kubeconfig"

set -x

kubectl get all,pv,pvc -n nginx-example --kubeconfig=${KUBECONFIG}  -o wide
