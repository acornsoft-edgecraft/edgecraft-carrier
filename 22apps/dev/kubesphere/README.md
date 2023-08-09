# KubeSphere 컨테이너 플랫폼

> [참고] https://artifacthub.io/packages/helm/kubesphere/ks-installer/0.3.0
> [참고] https://www.kubesphere.io/docs/v3.3/faq/observability/byop/
> [참고] https://www.kubesphere.io/docs/v3.3/installing-on-kubernetes/introduction/overview/

KubeSphere는 Kubernetes를 커널로 사용하는 클라우드 네이티브 애플리케이션 관리용 분산 운영 체제입니다. 플러그 앤 플레이 아키텍처를 제공하여 타사 애플리케이션을 에코시스템에 원활하게 통합할 수 있습니다.

## Installation

- Introduction

KubeSphere은 분산 운영 체제로, 커널로 Kubernetes를 사용하여 클라우드 네이티브 애플리케이션을 관리하며, 타사 애플리케이션을 심층 통합하여 생태계를 강화하기 위한 플러그 앤 플레이 아키텍처를 제공합니다.

KubeSphere의 헬름 차트가 기존의 Kubernetes 클러스터에 KubeSphere를 설치하는 것을 지원한다.

- Prerequisites
  - Kubernetes v1.17.x、v1.18.x、v1.19.x、v1.20.x
  - PV dynamic provisioning support on the underlying infrastructure (StorageClass)
  - Helm3

- 웹콘솔 접근
Make sure port 30880 is opened in security groups and access the web console through the NodePort (IP:30880) with the default account and password (admin/P@88w0rd).

### 1. Deploy KubeSphere with Helm 

> [참고] ks-install 이미지에 monitoring(prometheus) 설치가 기본값으로 고정되어 있어 ks-install 이미지 재구성이 필요하다

- chart 정보를 "01.install_using_helm.sh" 에 입력한다.
```sh
## step-1. chart 정보 입력
$ vi 01.install_using_helm.sh
VERSION="0.3.1"
URL="https://charts.kubesphere.io/main"
RELEASE_NAME="kubesphere"
CHART_NAME="ks-installer"

### "kubesphere-system" 네임스페이스를 고정으로 사용한다.
NAMESPACE="kubesphere-system"
```

### 2. Configuration KubeSphere with Helm

- Ks-installer Configuration
  - KubeSphere의 인스톨러로 KubeSphere 설정값에 따른 어플리케이션 구성을 한다.
- KubeSphere Configuration
  - "kubesphere-system" 네임스페이스를 고정으로 사용한다. (설치전 생성됭어 있어야 한다.)

```sh
## Ks-installer Configuration
# registry: ks-install 이미지 레지스트리 주소

## KubeSphere Configuration
# cc.persistence.storageClass: StorageClass 설정
# cc.authentication.adminPassword: Custom password of the admin user
# cc.common.monitoring.endpoint: external Prometheus 사용시 endpoint 설정
# cc.monitoring.enabled: monitoring 설치 - 재구성한 이미지에서 사용
# cc.monitoring.storageClass: monitoring storageclass 설정

## step-1. 설정 적용
--set registry="192.168.88.206" \
--set cc.persistence.storageClass="nfs-csi" \
--set cc.authentication.adminPassword="Pass0000@" \
--set cc.common.monitoring.endpoint="http://prometheus-operated.monitoring.svc:9090"
```

### 3. ks-install 이미지 재구성

> [참고] https://github.com/kubesphere/ks-installer

ks-install는 ansible playbooks를 사용하여 클러스터에 어플리케이션을 배포하는 역할을 한다.

- ansible 실행 파일에서 monitoring 목록 제거
```sh
$ mkdir kubesphere
$ cd kubesphere
$ git clone https://github.com/kubesphere/ks-installer.git
$ cd ks-installer
$ vi ./controller/installRunner.py
## monitoring 항목을 제거 한다.
...
    readyToEnabledList = [
        # 'monitoring',
        'multicluster',
        'openpitrix',
        'network']
...
```

- 이미지 빌드
```sh
## step-1. 이미지를 빌드한다.
$ docker build -f Dockerfile.complete --tag 192.168.88.206/kubesphere/ks-installer:v3.2.1 .

## step-2. 이미지를 사설레지스트리에 업로드 한다.
$ docker push 192.168.88.206/kubesphere/ks-installer:v3.2.1
```