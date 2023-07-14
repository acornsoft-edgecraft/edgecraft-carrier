#!/bin/sh

# install nfs provioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=192.168.88.11 \
--set nfs.path=/data/hdd/nfs-storage \
--set storageClass.defaultClass=true \
--kubeconfig ../../88apps.kubeconfig