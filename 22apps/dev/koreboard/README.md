# Kore Board :whale:

> [참고] https://github.com/kore3lab/dashboard

![Version](https://img.shields.io/github/release/kore3lab/dashboard) ![License](https://img.shields.io/github/license/kore3lab/dashboard) ![code size](https://img.shields.io/github/languages/code-size/kore3lab/dashboard)  ![issues](https://img.shields.io/github/issues/kore3lab/dashboard) ![issues](https://img.shields.io/github/issues-closed/kore3lab/dashboard) ![pull requests](https://img.shields.io/github/issues-pr-closed/kore3lab/dashboard) 

Kore보드는 쿠버네티스 다중 클러스터 관리를 위한 웹 기반 UI입니다. 사용자는 다중 클러스터에서 실행되고 있는 애플리케이션 뿐만 아니라 클러스터 자체를 관리할 수 있습니다.

### Installation using Helm-chart

#### Download charts
```sh
## step-1. Add chart repository
$ helm repo add kore https://raw.githubusercontent.com/kore3lab/dashboard/master/scripts/install/kubernetes
$ helm search repo kore

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
$ VERSION="0.5.5"
$ helm pull kore/kore-board --untar -d ./assets --version ${VERSION}
```

#### Sign-in Configuration
- 서비스어카운트에 대해 수동으로 시크릿 관리하기

> 1.24 버전까지는 ServiceAccount를 생성하면 secret 토큰이 자동으로 생성되었다.
> 1.24 이후 버전부터는 보안 강화를 위해 토큰을 자동으로 생성하지 않습니다.

```sh
## step-1. Sign-in 적용을 위해 chart를 변경 한다.
### 아래와 같이 secret을 추가 하여 serviceAccount에 대한 Token을 획득할 수 있습니다. 
$ vi ./assets/kore-board/templates/workload-backend.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Chart.Name }}-secret
  namespace: {{ .Release.Namespace }}
  annotations:
    kubernetes.io/service-account.name: {{ .Chart.Name }}
type: kubernetes.io/service-account-token
```

#### Installation

```sh
## step-1. install using helm
### Usage:
###   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade kore-board kore/kore-board \
helm upgrade kore-board ./assets/kore-board \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${NEXUS_CART_VALUES} \
    --version ${VERSION}
```