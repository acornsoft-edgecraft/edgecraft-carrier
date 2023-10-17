#!/bin/bash

BACKUP_KUBECONFIG="./backup-cloud.kubeconfig"
RESTORE_KUBECONFIG="./restore-cloud.kubeconfig"

# set -x

# backup-cloud 
echo "================================================================================="
echo "== backup-cloud =="
echo "kubectl get all,pv,pvc -n nginx --kubeconfig="${BACKUP_KUBECONFIG}
echo "================================================================================="

kubectl get all,pv,pvc -n nginx --kubeconfig=${BACKUP_KUBECONFIG} -o wide
 
# restore-cloud 
echo -e "\n"
echo "================================================================================="
echo "== restore-cloud =="
echo "kubectl get all,pv,pvc -n nginx --kubeconfig="${RESTORE_KUBECONFIG}
echo "================================================================================="

kubectl get all,pv,pvc -n nginx --kubeconfig=${RESTORE_KUBECONFIG} -o wide
