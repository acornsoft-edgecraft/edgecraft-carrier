# Cert-manager with Helm

## Installing with Helm

### Add Helm repository and Download charts
```sh
## step-1. Add chart repository
$ 
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
$ helm search repo jetstack

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
$ VERSION="1.12.0"
$ helm pull jetstack/cert-manager --untar -d ./assets --version ${VERSION}
```

### Installataion

```sh
## step-1. install using helm
### Usage:
###   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade harbor kore/harbor \
helm upgrade cert-manager ./assets/cert-manager \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CHART_VALUES} \
    --version ${VERSION}
```

### Configuration

```sh
## step-1. install CRDs as part of the Helm release
--set installCRDs=true

```

## Securing NGINX-ingress

> [참고] https://cert-manager.io/docs/tutorials/acme/nginx-ingress/

### Deploy the NGINX Ingress Controller

> [참고] https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx

Kubernetes Ingress Controller는 클러스터 내에서 실행 중인 소프트웨어에 대한 HTTP 및 HTTPS 트래픽의 액세스 포인트로 설계되었습니다. ingress-nginx-controller는 이를 달성하기 위해 클라우드 제공업체의 로드 밸런서를 지원하는 HTTP 프록시 서비스를 제공합니다.

#### Configuration

- Prometheus Metrics: 메트릭 정보 수집
- Ingress Admission Webhooks: 유효성 검사 및 구성에는 TLS를 사용하기 위해 요청이 전송되는 엔드포인트가 필요합니다.
  - controller.admissionWebhooks.certManager.enabled값을 true로 설정하여 cert-manager를 통해 자동 자체 서명 TLS 인증서 프로비저닝을 활성화할 수 있습니다.
- GitLab Shell 구성 요소는 TCP 트래픽이 포트 22를 통과해야 합니다(기본적으로 변경 가능). Ingress는 TCP 서비스를 직접 지원하지 않으므로 몇 가지 추가 구성이 필요합니다
  - [참고] https://docs.gitlab.com/charts/advanced/external-nginx/index.html

```sh
## step-1. Add the latest helm repository for the ingress-nginx
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update
$ helm search repo ingress-nginx

## step-2. Use helm to install an NGINX Ingress controller:
### dependencies: cert-manager - admissionWebhooks secret 생성
### NodePort 사용
### metrics 수집
### GitLab Shell 구성 요소는 TCP 트래픽이 포트 22를 통과해야 합니다
helm upgrade ${CHART_NAME} ./assets/${CHART_NAME} \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CHART_VALUES} \
    --version ${VERSION} \
    --set controller.admissionWebhooks.certManager.enabled=true \
    --set controller.metrics.enabled=true \
    --set controller.service.type=NodePort\
    --set controller.service.nodePorts.http=30001 \
    --set controller.service.nodePorts.https=30002 \
    --set tcp.22="gitlab/mygitlab-gitlab-shell:22"
```