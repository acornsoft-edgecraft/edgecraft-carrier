
# kiali

> https://kiali.io/

## Installation

> https://kiali.io/docs/installation/quick-start/

### Add Helm Repositories

```bash
# add charts repo
# download charts
~ % ./00.helm_add_repo.sh
```


### Configure values.yaml

```yaml
auth:
  ...
  strategy: "anonymous"
...
deployment:
  service_type: "NodePort"
...
external_services:
  ...
  prometheus:
    url: "http://prometheus-kube-prometheus-prometheus.monitoring:9090"
  grafana:
    enabled: true
    in_cluster_url: 'http://prometheus-grafana.monitoring:80'
  tracing:
    enabled: true
    in_cluster_url: 'http://jaeger-query.jaeger:16685'
```

### Install using helm

```bash
~ % ./01.install_using_helm.sh
+ VERSION=1.72.0
+ helm upgrade --install kiali-server ./assets/kiali-server -f ./examples/values.yaml -n istio-system --version 1.72.0
Release "kiali-server" does not exist. Installing it now.
NAME: kiali-server
LAST DEPLOYED: Tue Aug 22 16:19:16 2023
NAMESPACE: istio-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Welcome to Kiali! For more details on Kiali, see: https://kiali.io

The Kiali Server [v1.72.0] has been installed in namespace [istio-system]. It will be ready soon.

(Helm: Chart=[kiali-server], Release=[kiali-server], Version=[1.72.0])
```

```bash
k get all -n istio-system  -o wide

NAME                          READY   STATUS    RESTARTS   AGE     IP          NODE              NOMINATED NODE   READINESS GATES
pod/istiod-758754dcd5-l9fvn   1/1     Running   0          9m29s   10.4.8.96   carrier-master1   <none>           <none>
pod/kiali-c96996bcf-knfmz     1/1     Running   0          84s     10.4.2.91   carrier-master2   <none>           <none>

NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                                 AGE     SELECTOR
service/istiod   ClusterIP   10.96.9.172   <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP   9m30s   app=istiod,istio=pilot
service/kiali    NodePort    10.96.15.77   <none>        20001:32187/TCP,9090:32373/TCP          84s     app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                         SELECTOR
deployment.apps/istiod   1/1     1            1           9m30s   discovery    docker.io/istio/pilot:1.18.2   istio=pilot
deployment.apps/kiali    1/1     1            1           84s     kiali        quay.io/kiali/kiali:v1.72.0    app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali

NAME                                DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES                         SELECTOR
replicaset.apps/istiod-758754dcd5   1         1         1       9m30s   discovery    docker.io/istio/pilot:1.18.2   istio=pilot,pod-template-hash=758754dcd5
replicaset.apps/kiali-c96996bcf     1         1         1       84s     kiali        quay.io/kiali/kiali:v1.72.0    app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali,pod-template-hash=c96996bcf

NAME                                         REFERENCE           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/istiod   Deployment/istiod   <unknown>/80%   1         5         1          9m30s
```
