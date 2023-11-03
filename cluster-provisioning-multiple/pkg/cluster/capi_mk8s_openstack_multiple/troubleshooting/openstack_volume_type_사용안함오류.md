## 오픈스택을 volume type을 사용 안하는 현상 

오픈스택의 default volume type을 사용 하지 안고 호스트 디렉토리에 볼륨을 생성 한다.

- 해결 방법: Boot From Volume 사요
- [참고] https://github.com/kubernetes-sigs/cluster-api-provider-openstack/blob/main/docs/book/src/clusteropenstack/configuration.md#boot-from-volume
```sh
## step-1. OpenStackMachineTemplate 오브젝트에 rootVolume 항목을 추가 한다.
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha7
kind: OpenStackMachineTemplate
metadata:
  name: <cluster-name>-controlplane
  namespace: <cluster-name>
spec:
...
  rootVolume:
    diskSize: <image size>
    volumeType: <a cinder volume type (*optional)>
    availabilityZone: <the cinder availability zone for the root volume (*optional)>
...
```