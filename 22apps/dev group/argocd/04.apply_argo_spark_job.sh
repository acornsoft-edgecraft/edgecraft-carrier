#!/bin/sh

# apply role and role-binding for spark job from argocd
kubectl apply -n argocd -f ./examples/workflow/spark_job.yaml --kubeconfig ../../88apps.kubeconfig