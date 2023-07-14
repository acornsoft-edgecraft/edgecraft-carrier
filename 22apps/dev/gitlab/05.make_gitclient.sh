#!/bin/sh

# make git client yaml
#kubectl --kubeconfig ../../88apps.kubeconfig run gitclient --image alpine/git -n gitlab -o yaml --dry-run=client > gitclient.yaml

# apply gitclient
kubectl apply -f ./examples/gitclient/gitclient.yaml -n gitlab --wait --kubeconfig ../../88apps.kubeconfig

# connect to gitclient
kubectl exec -it gitclient -n gitlab --kubeconfig ../../88apps.kubeconfig -- /bin/sh