#!/bin/sh

# find password for gitlab
#kubectl get secret gitlab-gitlab-initial-root-password -n gitlab  -o jsonpath="{.data.password}"  --kubeconfig ../../88apps.kubeconfig | base64 -d ; echo

kubectl exec $(kubectl get pods -o jsonpath="{.items[0].metadata.name}" -n gitlab --kubeconfig ../../88apps.kubeconfig) -n gitlab --kubeconfig ../../88apps.kubeconfig -- cat /etc/gitlab/initial_root_password

kubectl exec -it $(kubectl get pods -o jsonpath="{.items[0].metadata.name}" -n gitlab --kubeconfig ../../88apps.kubeconfig) -n gitlab --kubeconfig ../../88apps.kubeconfig -- /bin/bash