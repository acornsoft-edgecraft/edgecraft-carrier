#!/bin/sh

# create storage class
kubectl apply --kubeconfig ../../88apps.kubeconfig \
-f - <<EOF
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-csi
  annotations:
    staorageclass.kubernetes.io/is-default-class: true
provisioner: nfs.csi.k8s.io
parameters:
  server: 192.168.88.11
  share: /data/hdd/nfs-storage
  # csi.storage.k8s.io/provisioner-secret is only needed for providing mountOptions in DeleteVolume
  # csi.storage.k8s.io/provisioner-secret-name: "mount-options"
  # csi.storage.k8s.io/provisioner-secret-namespace: "default"
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
  - nfsvers=4.1
EOF