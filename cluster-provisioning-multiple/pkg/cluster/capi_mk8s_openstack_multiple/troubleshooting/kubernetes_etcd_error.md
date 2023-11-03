
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


```log
4d6fxgq8pp-j2qwg" cluster="mk8s-os-cluster-92" openStackCluster="mk8s-os-cluster-92"
2023/05/09 06:44:56 http: TLS handshake error from 10.4.3.193:55707: EOF
2023/05/09 06:44:56 http: TLS handshake error from 10.4.3.193:26337: EOF
2023/05/09 06:44:56 http: TLS handshake error from 10.4.3.193:7269: EOF
I0509 06:44:57.367337       1 openstackmachine_controller.go:446] "Machine not exist, Creating Machine" controller="openstackmachine" controllerGroup="infrastructure.cluster.x-k8s.io" controllerKind="OpenStackMachine" OpenStackMachine="default/mk8s-os-cluster-92-md-0-nzr6h" namespace="default" name="mk8s-os-cluster-92-md-0-nzr6h" reconcileID=7ee0313e-4a7a-4892-8c89-5e7ecd68b385 openStackMachine="mk8s-os-cluster-92-md-0-nzr6h" machine="mk8s-os-cluster-92-md-0-588fc64d6fxgq8pp-j2qwg" cluster="mk8s-os-cluster-92" openStackCluster="mk8s-os-cluster-92" Machine="mk8s-os-cluster-92-md-0-nzr6h"
I0509 06:44:58.172214       1 recorder.go:103] "events: Created port mk8s-os-cluster-92-md-0-nzr6h-0 with id 6e9ccfa4-40d5-4013-8e73-b5c2a6d65ef8" type="Normal" object={Kind:OpenStackMachine Namespace:default Name:mk8s-os-cluster-92-md-0-nzr6h UID:082f0549-61a3-4351-b86b-e5ebca5ed713 APIVersion:infrastructure.cluster.x-k8s.io/v1alpha6 ResourceVersion:38638 FieldPath:} reason="Successfulcreateport"
2023/05/09 06:45:30 http: TLS handshake error from 10.4.3.193:31258: EOF
2023/05/09 06:45:30 http: TLS handshake error from 10.4.3.193:26416: EOF
2023/05/09 06:46:05 http: TLS handshake error from 10.4.3.193:59221: EOF
2023/05/09 06:47:05 http: TLS handshake error from 10.4.3.193:52214: EOF
E0509 06:47:21.957231       1 leaderelection.go:330] error retrieving resource lock capo-system/controller-leader-election-capo: Get "https://10.96.0.1:443/apis/coordination.k8s.io/v1/namespaces/capo-system/leases/controller-leader-election-capo": context deadline exceeded
I0509 06:47:21.957386       1 leaderelection.go:283] failed to renew lease capo-system/controller-leader-election-capo: timed out waiting for the condition
E0509 06:47:21.957479       1 main.go:200] "setup: problem running manager" err="leader election lost"./
```

### controller-manager leader election lost Crashloopback 현상

이 문제는 리소스 위기 또는 네트워크 문제가 있을 때 발생합니다. 내 경우에는 Kube API 서버에 리소스 크런치가 발생하여 API 호출 대기 시간이 증가하여 리더 선택 API 호출이 시간 초과되었습니다.

- 참고: https://stackoverflow.com/questions/65481831/kube-controller-manager-and-kube-scheduler-leaderelection-lost-crashloopback
- 해결방법: 
  1. 노드의 CPU 및 메모리를 늘린 후 문제가 해결되었습니다
  2. 네트워크 지연 문제라면 kube-controller-manager.yaml 에서 leader-elect-lease-duration, leader-elect-renew-deadline 값을 조정 합니다.

```sh
## 제 경우에는 네트워크 문제였으며 해결 방법은 kube-controller-manager.yaml 매니페스트에서 leader-elect-lease-duration 및 leader-elect-renew-deadline을 늘리는 것이었습니다. 기본적으로:
##
## --leader-elect-lease-duration duration     Default: 15s
## --leader-elect-renew-deadline duration     Default: 10s
## 도움이 되는지 확인하기 위해 각각 120초와 60초로 늘렸습니다
$ vi /etc/kubernetes/manifests/kube-controller-manager.yaml
    - --leader-elect=true
    - --leader-elect-lease-duration=120s
    - --leader-elect-renew-deadline=80s
```

- 위와같이 capi의 controller-manager 옵션도 조정 합니다.
- 위와같이 capi의 controller-manager 옵션도 조정 합니다.
- 위와같이 capi의 controller-manager 옵션도 조정 합니다.

```sh
## manager 옵션 정보
Usage of /manager:
      --add-dir-header                         If true, adds the file directory to the header of the log messages
      --alsologtostderr                        log to standard error as well as files
      --feature-gates mapStringBool            A set of key=value pairs that describe feature gates for alpha/experimental features. Options are:
                                               AllAlpha=true|false (ALPHA - default=false)
                                               AllBeta=true|false (BETA - default=false)
                                               ClusterResourceSet=true|false (BETA - default=true)
                                               ClusterTopology=true|false (ALPHA - default=false)
                                               MachinePool=true|false (ALPHA - default=false) (default )
      --health-addr string                     The address the health endpoint binds to. (default ":9440")
      --kubeadmcontrolplane-concurrency int    Number of kubeadm control planes to process simultaneously (default 10)
      --kubeconfig string                      Paths to a kubeconfig. Only required if out-of-cluster.
      --leader-elect                           Enable leader election for controller manager. Enabling this will ensure there is only one active controller manager.
      --leader-elect-lease-duration duration   Interval at which non-leader candidates will wait to force acquire leadership (duration string) (default 1m0s)
      --leader-elect-renew-deadline duration   Duration that the leading controller manager will retry refreshing leadership before giving up (duration string) (default 40s)
      --leader-elect-retry-period duration     Duration the LeaderElector clients should wait between tries of actions (duration string) (default 5s)
      --log-backtrace-at traceLocation         when logging hits line file:N, emit a stack trace (default :0)
      --log-dir string                         If non-empty, write log files in this directory
      --log-file string                        If non-empty, use this log file
      --log-file-max-size uint                 Defines the maximum size a log file can grow to. Unit is megabytes. If the value is 0, the maximum file size is unlimited. (default 1800)
      --logtostderr                            log to standard error instead of files (default true)
      --metrics-bind-addr string               The address the metric endpoint binds to. (default "localhost:8080")
      --namespace string                       Namespace that the controller watches to reconcile cluster-api objects. If unspecified, the controller watches for cluster-api objects across all namespaces.
      --one-output                             If true, only write logs to their native severity level (vs also writing to each lower severity level)
      --profiler-address string                Bind address to expose the pprof profiler (e.g. localhost:6060)
      --skip-headers                           If true, avoid header prefixes in the log messages
      --skip-log-headers                       If true, avoid headers when opening log files
      --stderrthreshold severity               logs at or above this threshold go to stderr (default 2)
      --sync-period duration                   The minimum interval at which watched resources are reconciled (e.g. 15m) (default 10m0s)
  -v, --v Level                                number for the log level verbosity
      --vmodule moduleSpec                     comma-separated list of pattern=N settings for file-filtered logging
      --watch-filter string                    Label value that the controller watches to reconcile cluster-api objects. Label key is always cluster.x-k8s.io/watch-filter. If unspecified, the controller watches for all cluster-api objects.
      --webhook-cert-dir string                Webhook cert dir, only used when webhook-port is specified. (default "/tmp/k8s-webhook-server/serving-certs/")
      --webhook-port int                       Webhook Server port (default 9443)

## 각각의 capi, capo controller-manager를 업데이트 한다.
## capi-microk8s-bootstrap-controller-manager, capi-microk8s-control-plane-controller-manager 지원 안됨
$ kubectl -n capi-system edit deployment capi-controller-manager
$ kubectl -n capo-system edit deployment capo-controller-manager
...
    spec:
      containers:
      - args:
        - --leader-elect
        - --leader-elect-lease-duration=120s
        - --leader-elect-renew-deadline=80s
...

```