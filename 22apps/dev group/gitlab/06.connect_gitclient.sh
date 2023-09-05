#!/bin/sh

# connect to gitclient
kubectl exec -it gitclient -n gitlab --kubeconfig ../../88apps.kubeconfig -- /bin/sh