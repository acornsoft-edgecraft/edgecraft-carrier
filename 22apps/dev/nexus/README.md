# sonatype nexus repository oss

> [sonatype-nexus-oss] https://www.sonatype.com/products/sonatype-nexus-oss
> [Helm3 Charts for Sonatype Products] https://sonatype.github.io/helm3-charts/
> [참고] https://www.bearpooh.com/46

- 확장 가능한 중앙 집중식 리포지토리 관리
- 소프트웨어 공급망 전체에서 바이너리 및 빌드 아티팩트 제어
- 빠른 소프트웨어 구축 및 배포
  - Build quickly and reliably: 널리 사용되는 모든 패키지 관리자에 기본적으로 연결되는 중앙 리포지토리에 구성 요소를 게시하고 캐시합니다.
  - Manage storage space efficiently: 리포지토리에서 오래되었거나 사용하지 않는 아티팩트를 자동으로 정리합니다.
- 소프트웨어 공급망 보호
  - Assess open source risk: 오픈 소스 소프트웨어 사용 시 중앙 집중화하여 관리하고, 공급망에서의 보안 위험을 파악하고 대응하는 것이 중요하다
  - Block malicious components: 오픈 소스 소프트웨어를 개발하는 과정에서 발생할 수 있는 보안 위험을 방지하고자 넥서스 방화벽을 사용한다. 이를 통해 개발자들은 오픈 소스 소프트웨어의 사용과 관리를 보다 안전하고 효율적으로 수행할 수 있으며, SDLC 과정에서 발생할 수 있는 보안 취약점과 위험들을 사전에 예방하고 처리할 수 있습니다.
    이는 소프트웨어 개발의 안정성과 신뢰성을 향상시키는 데에 도움을 줍니다.
  - Flexible security: 소프트웨어 개발 또는 운영 환경에서 보안을 유연하게 설정하고자 역할 기반의 접근 제어와 감사 가능성을 활용하는 것을 권장하고 있습니다.

## Installation

- Add the Sonatype Repo to Your Helm
```sh
## step-1. add repo
$ helm repo add sonatype https://sonatype.github.io/helm3-charts/
$ helm repo update

## step-2. download charts
### Usage:
###  helm pull [chart URL | repo/chartname] [...] [flags]
$ helm pull sonatype/nexus-repository-manager --untar -d ./assets --version ${VERSION}

## step-3. Get the Values for Configuring a Chart
### Usage:
###   helm show [command]
$ helm show values sonatype/nexus-repository-manager
```

- Install Single-Instance Nexus Repository Manager OSS
```sh
## step-1. configuration in values file
### strageclass 사용
$ vi ${NEXUS_CART_VALUES}
persistence:
  storageClass: "nfs-csi"

### service NodePort 사용
service:
  type: NodePort

## step-2. install using helm
### Usage:
###   helm upgrade [RELEASE] [CHART] [flags]
helm upgrade nexus sonatype/nexus-repository-manager   \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace nexus \
    --values ${NEXUS_CART_VALUES} \
    --version ${VERSION}

# service tyep: ClusterIP 일때
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace nexus -l "app.kubernetes.io/name=nexus-repository-manager,app.kubernetes.io/instance=nexus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace nexus port-forward $POD_NAME 8081:80
  Your application is available at http://127.0.0.1

# service tyep: NodePort 일때
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace nexus -o jsonpath="{.spec.ports[0].nodePort}" services nexus-nexus-repository-manager)
  export NODE_IP=$(kubectl get nodes --namespace nexus -o jsonpath="{.items[0].status.addresses[0].address}")
  Your application is available at http://$NODE_IP:$NODE_PORT
```

## 
- Get 최초 admin password
```sh
## step-1. Get 최초 admin password
$ export POD_NAME=$(kubectl --kubeconfig ${KUBECONFIG} get pods --namespace nexus -l "app.kubernetes.io/name=nexus-repository-manager,app.kubernetes.io/instance=nexus" -o jsonpath="{.items[0].metadata.name}")
$ kubectl --kubeconfig ${KUBECONFIG} -n nexus exec -it ${POD_NAME} -- cat /nexus-data/admin.password

## step-2. admin password 변경
```

