
# Istio

## Installation

> https://istio.io/latest/docs/setup/install/helm/

### Add Helm Repositories

```bash
# add charts repo
# download charts
~ % ./00.helm_add_repo.sh
```

### Install the Istio base chart 

```bash
~ % ./01.install_using_helm.sh
+ VERSION=1.18.2
+ helm upgrade --install istio-base ./assets/base -n istio-system --create-namespace --version 1.18.2
Release "istio-base" does not exist. Installing it now.
NAME: istio-base
LAST DEPLOYED: Tue Aug 22 16:10:38 2023
NAMESPACE: istio-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Istio base successfully installed!

To learn more about the release, try:
  $ helm status istio-base
  $ helm get all istio-base
```

### config istiod values.yaml


### Install the Istio discovery chart

```bash
~ % ./02.install_using_helm.sh
+ VERSION=1.18.2
+ helm upgrade --install istiod ./assets/istiod -f ./examples/values.yaml -n istio-system --version 1.18.2
Release "istiod" does not exist. Installing it now.
NAME: istiod
LAST DEPLOYED: Tue Aug 22 16:11:11 2023
NAMESPACE: istio-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
"istiod" successfully installed!

To learn more about the release, try:
  $ helm status istiod
  $ helm get all istiod

Next steps:
  * Deploy a Gateway: https://istio.io/latest/docs/setup/additional-setup/gateway/
  * Try out our tasks to get started on common configurations:
    * https://istio.io/latest/docs/tasks/traffic-management
    * https://istio.io/latest/docs/tasks/security/
    * https://istio.io/latest/docs/tasks/policy-enforcement/
    * https://istio.io/latest/docs/tasks/policy-enforcement/
  * Review the list of actively supported releases, CVE publications and our hardening guide:
    * https://istio.io/latest/docs/releases/supported-releases/
    * https://istio.io/latest/news/security/
    * https://istio.io/latest/docs/ops/best-practices/security/

For further documentation see https://istio.io website
```

### Varify the Istio chart installation

```bash
helm ls -n istio-system

NAME      	NAMESPACE   	REVISION	UPDATED                             	STATUS  	CHART        	APP VERSION
istio-base	istio-system	1       	2023-08-22 16:10:38.930421 +0900 KST	deployed	base-1.18.2  	1.18.2
istiod    	istio-system	1       	2023-08-22 16:11:11.04475 +0900 KST 	deployed	istiod-1.18.2	1.18.2
```

### Check istiod service is successfully installed and its pods are running

```bash
k get all -n istio-system -o wide

NAME                          READY   STATUS    RESTARTS   AGE     IP          NODE              NOMINATED NODE   READINESS GATES
pod/istiod-758754dcd5-l9fvn   1/1     Running   0          4m25s   10.4.8.96   carrier-master1   <none>           <none>

NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                                 AGE     SELECTOR
service/istiod   ClusterIP   10.96.9.172   <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP   4m26s   app=istiod,istio=pilot

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                         SELECTOR
deployment.apps/istiod   1/1     1            1           4m26s   discovery    docker.io/istio/pilot:1.18.2   istio=pilot

NAME                                DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES                         SELECTOR
replicaset.apps/istiod-758754dcd5   1         1         1       4m26s   discovery    docker.io/istio/pilot:1.18.2   istio=pilot,pod-template-hash=758754dcd5

NAME                                         REFERENCE           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/istiod   Deployment/istiod   <unknown>/80%   1         5         1          4m26s
```
