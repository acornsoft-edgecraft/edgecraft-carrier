
### capi 파드 에러 19.168.77.xxx
```sh
root@edgecraft-master-0:~# kubectl get pod -A
NAMESPACE                            NAME                                                              READY   STATUS    RESTARTS         AGE
capi-k3s-bootstrap-system            capi-k3s-bootstrap-controller-manager-7dc9cbf8cd-hhd6g            2/2     Running   1 (8d ago)       82d
capi-k3s-control-plane-system        capi-k3s-control-plane-controller-manager-5c8b5ff568-zzdpz        2/2     Running   0                82d
capi-kubeadm-bootstrap-system        capi-kubeadm-bootstrap-controller-manager-6bf5cc47bd-pv825        1/1     Running   2 (8d ago)       146d
capi-kubeadm-control-plane-system    capi-kubeadm-control-plane-controller-manager-d6d96f685-tgn8m     1/1     Running   0                146d
capi-microk8s-bootstrap-system       capi-microk8s-bootstrap-controller-manager-674cf5fd6-5mdkw        2/2     Running   0                19d
capi-microk8s-control-plane-system   capi-microk8s-control-plane-controller-manager-54ff865678-52dxs   2/2     Running   1 (8d ago)       19d
capi-system                          capi-controller-manager-54fccd9b68-2vzc6                          1/1     Running   0                19d
capo-system                          capo-controller-manager-7d7955797c-58n4m                          1/1     Running   0                19d
cert-manager                         cert-manager-6888d6b69b-2l2lv                                     1/1     Running   0                180d
cert-manager                         cert-manager-cainjector-76f7798c9-vtjnp                           1/1     Running   1 (90d ago)      180d
cert-manager                         cert-manager-webhook-7d4b5d8484-kt9vw                             1/1     Running   0                180d
default                              dnsutils                                                          1/1     Running   4867 (40s ago)   202d
edgecraft                            edgecraft-api-5459c9f6f8-8qsxl                                    1/1     Running   0                26d
edgecraft                            postgresql-0                                                      1/1     Running   4                203d
kube-system                          calico-kube-controllers-5c64b68895-gvxtc                          1/1     Running   14               248d
kube-system                          calico-node-c996t                                                 1/1     Running   7                257d
kube-system                          calico-node-cj5cz                                                 1/1     Running   7                256d
kube-system                          calico-node-rxknh                                                 1/1     Running   8                257d
kube-system                          coredns-64897985d-6zs4r                                           1/1     Running   3                204d
kube-system                          coredns-64897985d-lwdkn                                           1/1     Running   7                248d
kube-system                          etcd-edgecraft-master-0                                           1/1     Running   7                257d
kube-system                          kube-apiserver-edgecraft-master-0                                 1/1     Running   7                257d
kube-system                          kube-controller-manager-edgecraft-master-0                        1/1     Running   10 (90d ago)     257d
kube-system                          kube-proxy-5jvjx                                                  1/1     Running   7                257d
kube-system                          kube-proxy-q4p2v                                                  1/1     Running   7                256d
kube-system                          kube-proxy-w9bm8                                                  1/1     Running   8                257d
kube-system                          kube-scheduler-edgecraft-master-0                                 1/1     Running   10 (90d ago)     257d
kube-system                          nfs-client-provisioner-76b748b574-qjspm                           1/1     Running   3 (90d ago)      204d
kubernetes-dashboard                 dashboard-metrics-scraper-577dc49767-ffwcb                        1/1     Running   3                204d
kubernetes-dashboard                 kubernetes-dashboard-75d867cbbd-s2k24                             1/1     Running   0                153d
```


### capi 파드 테스트 로그
```
root@edgecraft-master-1:~# k get pod -A -o wide
NAMESPACE                            NAME                                                              READY   STATUS    RESTARTS       AGE    IP            NODE                 NOMINATED NODE   READINESS GATES
capi-microk8s-bootstrap-system       capi-microk8s-bootstrap-controller-manager-74cfdd59-fpqkq         2/2     Running   7 (28m ago)    44m    10.4.5.70     edgecraft-worker-2   <none>           <none>
capi-microk8s-control-plane-system   capi-microk8s-control-plane-controller-manager-647566bd78-vnkv8   2/2     Running   6 (29m ago)    44m    10.4.5.69     edgecraft-worker-2   <none>           <none>
capi-system                          capi-controller-manager-6665495f86-68nqg                          1/1     Running   10 (28m ago)   74m    10.4.5.68     edgecraft-worker-2   <none>           <none>
capo-system                          capo-controller-manager-6dc6bdccf5-cbgpp                          1/1     Running   8 (28m ago)    74m    10.4.1.69     edgecraft-worker-1   <none>           <none>
cert-manager                         cert-manager-6ffb79dfdb-d2ctw                                     1/1     Running   0              74m    10.4.1.66     edgecraft-worker-1   <none>           <none>
cert-manager                         cert-manager-cainjector-5fcd49c96-4j2b9                           1/1     Running   0              74m    10.4.5.66     edgecraft-worker-2   <none>           <none>
cert-manager                         cert-manager-webhook-796ff7697b-kvlwk                             1/1     Running   0              74m    10.4.5.67     edgecraft-worker-2   <none>           <none>
kube-system                          calico-kube-controllers-57b57c56f-99jjs                           1/1     Running   2 (38m ago)    137m   10.4.3.66     edgecraft-master-1   <none>           <none>
kube-system                          calico-node-2hx6g                                                 1/1     Running   0              137m   10.10.10.11   edgecraft-master-1   <none>           <none>
kube-system                          calico-node-hdjhq                                                 1/1     Running   0              136m   10.10.10.21   edgecraft-worker-1   <none>           <none>
kube-system                          calico-node-ks2jr                                                 1/1     Running   0              136m   10.10.10.22   edgecraft-worker-2   <none>           <none>
kube-system                          calico-node-kv2rl                                                 1/1     Running   0              137m   10.10.10.12   edgecraft-master-2   <none>           <none>
kube-system                          calico-node-l8879                                                 1/1     Running   0              137m   10.10.10.13   edgecraft-master-3   <none>           <none>
kube-system                          coredns-787d4945fb-nzflg                                          1/1     Running   0              137m   10.4.3.65     edgecraft-master-1   <none>           <none>
kube-system                          coredns-787d4945fb-wv5fp                                          1/1     Running   0              137m   10.4.3.67     edgecraft-master-1   <none>           <none>
kube-system                          haproxy-edgecraft-worker-1                                        1/1     Running   0              136m   10.10.10.21   edgecraft-worker-1   <none>           <none>
kube-system                          haproxy-edgecraft-worker-2                                        1/1     Running   0              136m   10.10.10.22   edgecraft-worker-2   <none>           <none>
kube-system                          kube-apiserver-edgecraft-master-1                                 1/1     Running   2 (34m ago)    137m   10.10.10.11   edgecraft-master-1   <none>           <none>
kube-system                          kube-apiserver-edgecraft-master-2                                 1/1     Running   2 (35m ago)    137m   10.10.10.12   edgecraft-master-2   <none>           <none>
kube-system                          kube-apiserver-edgecraft-master-3                                 1/1     Running   0              137m   10.10.10.13   edgecraft-master-3   <none>           <none>
kube-system                          kube-controller-manager-edgecraft-master-1                        1/1     Running   6 (28m ago)    137m   10.10.10.11   edgecraft-master-1   <none>           <none>
kube-system                          kube-controller-manager-edgecraft-master-2                        1/1     Running   7 (27m ago)    137m   10.10.10.12   edgecraft-master-2   <none>           <none>
kube-system                          kube-controller-manager-edgecraft-master-3                        1/1     Running   7 (26m ago)    137m   10.10.10.13   edgecraft-master-3   <none>           <none>
kube-system                          kube-proxy-46ckj                                                  1/1     Running   0              136m   10.10.10.22   edgecraft-worker-2   <none>           <none>
kube-system                          kube-proxy-5nxlr                                                  1/1     Running   1 (136m ago)   137m   10.10.10.12   edgecraft-master-2   <none>           <none>
kube-system                          kube-proxy-86h8h                                                  1/1     Running   1              137m   10.10.10.13   edgecraft-master-3   <none>           <none>
kube-system                          kube-proxy-tfnwv                                                  1/1     Running   0              137m   10.10.10.11   edgecraft-master-1   <none>           <none>
kube-system                          kube-proxy-tkjrk                                                  1/1     Running   0              136m   10.10.10.21   edgecraft-worker-1   <none>           <none>
kube-system                          kube-scheduler-edgecraft-master-1                                 1/1     Running   6 (26m ago)    137m   10.10.10.11   edgecraft-master-1   <none>           <none>
kube-system                          kube-scheduler-edgecraft-master-2                                 1/1     Running   6 (28m ago)    137m   10.10.10.12   edgecraft-master-2   <none>           <none>
kube-system                          kube-scheduler-edgecraft-master-3                                 1/1     Running   6 (27m ago)    137m   10.10.10.13   edgecraft-master-3   <none>           <none>
kube-system                          metrics-server-5994f7658b-fz9xl                                   1/1     Running   0              124m   10.4.1.65     edgecraft-worker-1   <none>           <none>
kube-system                          metrics-server-5994f7658b-k5nhf                                   1/1     Running   0              124m   10.4.5.65     edgecraft-worker-2   <none>           <none>
```