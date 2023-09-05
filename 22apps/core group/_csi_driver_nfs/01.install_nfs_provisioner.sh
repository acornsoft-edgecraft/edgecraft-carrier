#!/bin/sh

# install nfs provioner
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version v4.3.0 \
--set kubeletDir="/data/kubelet" \
--set controller.runOnControlPlane=true \
--wait \
--kubeconfig ../../88apps.kubeconfig

# check pod status
kubectl --namespace=kube-system get pods --selector="app.kubernetes.io/instance=csi-driver-nfs" --watch --kubeconfig ../../88apps.kubeconfig