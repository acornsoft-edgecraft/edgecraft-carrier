#!/bin/sh

# apply role and role-binding for spark job from argocd
kubectl apply -n argocd -f argo_spark_role_binding_account.yaml --kubeconfig ../../88apps.kubeconfig