#!/bin/sh

# create admin user
kubectl apply -f admin-user.yaml --kubeconfig ../../../../88apps.kubeconfig

# create token
kubectl -n kubernetes-dashboard create token admin-user --duration=720h --kubeconfig ../../../../88apps.kubeconfig

# get token
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get serviceaccount admin-user -o jsonpath="{.secrets[0].name}" --kubeconfig ../../../../88apps.kubeconfig) -o jsonpath="{.data.token}" --kubeconfig ../../../../88apps.kubeconfig | base64 --decode