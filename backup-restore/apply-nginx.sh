#!/bin/bash

BACKUP_KUBECONFIG="./backup-cloud.kubeconfig"

set +x

kubectl apply -f ./nginx-withpv.yaml --kubeconfig=${BACKUP_KUBECONFIG}
