# Keycloak with Helm

## Installing with Helm

### Add Helm repository and Download charts
```sh
## step-1. Add chart repository
$ 
$ helm repo add codecentric https://codecentric.github.io/helm-charts
$ helm repo update
$ helm search repo codecentric

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
$ helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}
```

### Installataion

```sh
## step-1. install using helm
### Usage:
###   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade harbor kore/harbor \
helm upgrade ${CHART_NAME} ./assets/${CHART_NAME} \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CART_VALUES} \
    --version ${VERSION} \
    --set service.type="NodePort" \
    --set postgresql.global.storageClass="nfs-csi" \
    --set postgresql.volumePermissions.enabled=true
```

### Configuration

- 하위 차트 postgres 설정

```sh
## step-1. postgres는 하위 차트이므로 아래와 같이 storageClass를 설정할 수 있다.
--set postgresql.global.storageClass="yourStorageClass"

## step-2. 때때로 클러스터 설정은 기본적으로 탑재된 볼륨에 실제로 쓸 수 있는 충분한 권한을 실행 중인 컨테이너에 부여하지 않습니다.
--set postgresql.volumePermissions.enabled=true
```

- service type NodePort 사용

```sh
## step-1. NodePort 사용 설정
--set service.type="NodePort"
```

- Creating a Keycloak Admin User

```sh
## step-1. It must be configured via environment variables
### KEYCLOAK_USER or KEYCLOAK_USER_FILE
### KEYCLOAK_PASSWORD or KEYCLOAK_PASSWORD_FILE
### Add extraEnv in values.yaml
# Additional environment variables for Keycloak
extraEnv: |
  - name: KEYCLOAK_USER
    value: "${KEYCLOAK_USER}"
  - name: KEYCLOAK_PASSWORD
    value: "${KEYCLOAK_PASSWORD}"
```