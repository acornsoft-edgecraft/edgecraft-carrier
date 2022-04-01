## kubernetes.core plugin 설치

> [참고]
> https://github.com/ansible-collections/kubernetes.core
```sh
$ ansible-galaxy collection install kubernetes.core

## Use ansible-doc -l to see the list of available modules.
$ ansible-doc -l
[...]
kubernetes.core.helm             Manages Kubernetes packages with the Helm package manager
kubernetes.core.helm_info        Get information from Helm package deployed inside the cluster
kubernetes.core.helm_plugin      Manage Helm plugins
kubernetes.core.helm_plugin_info Gather information about Helm plugins
kubernetes.core.helm_repository  Manage Helm repositories
kubernetes.core.helm_template    Render chart templates
kubernetes.core.k8s              Manage Kubernetes (K8s) objects
kubernetes.core.k8s_cluster_info Describe Kubernetes (K8s) cluster, APIs available and their respective versions
kubernetes.core.k8s_cp           Copy files and directories to and from pod
kubernetes.core.k8s_drain        Drain, Cordon, or Uncordon node in k8s cluster
kubernetes.core.k8s_exec         Execute command in Pod
kubernetes.core.k8s_info         Describe Kubernetes (K8s) objects
kubernetes.core.k8s_json_patch   Apply JSON patch operations to existing objects
kubernetes.core.k8s_log          Fetch logs from Kubernetes resources
kubernetes.core.k8s_rollback     Rollback Kubernetes (K8S) Deployments and DaemonSets
kubernetes.core.k8s_scale        Set a new size for a Deployment, ReplicaSet, Replication Controller, or Job
kubernetes.core.k8s_service      Manage Services on Kubernetes
[...]
```


## Automating Helm using Ansible
kubernetes.core 컬렉션에 포함된 Helm 관련 모듈 목록은 다음과 같습니다.

- helm - Helm 바이너리로 K8S 패키지를 관리합니다.
- helm_info - 클러스터 내부에 배포된 Helm 패키지에 대한 정보 수집
- helm_plugin - Helm 플러그인 관리
- helm_plugin_info - Helm 플러그인에 대한 정보 수집
- helm_repository - Helm 저장소 관리

#### 디렉토리 레이아웃
```sh
production                # inventory file for production servers
staging                   # inventory file for staging environment

group_vars/
   group1.yml             # here we assign variables to particular groups
   group2.yml
host_vars/
   hostname1.yml          # here we assign variables to particular systems
   hostname2.yml

library/                  # if any custom modules, put them here (optional)
module_utils/             # if any custom module_utils to support modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""

```

#### 시나리오 1 - 새 Helm 저장소 추가
helm_repository 모듈을 사용하여 Helm 저장소를 추가해 보겠습니다.
```sh
$ vi test.yaml
---
- hosts: localhost
  vars:
     helm_chart_url: "https://charts.bitnami.com/bitnami"
  tasks:
      - name: Add helm repo
        kubernetes.core.helm_repository:
    	    name: bitnami
    	    repo_url: "{{ helm_chart_url }}"

$ helm repo list
NAME  	 URL
stable     https://kubernetes-charts.storage.googleapis.com/
bitnami    https://charts.bitnami.com/bitnami
```

#### 시나리오 2 - Helm 차트 설치
이제 Helm 저장소가 구성되었습니다. 이제 Bitnami 저장소에서 nginx 차트를 설치해 보겠습니다 .
```sh
---
- hosts: localhost
  tasks:
     - name: Install Nginx Chart
       kubernetes.core.helm:
    	   name: nginx-server
    	   namespace: testing
    	   chart_ref: bitnami/nginx
```

## 필수 패키지 목록
- python3 라이브러리
  - pip3 insatll kubernetes
  - pip3 insatll PyYAML

- istioctl
  - curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.10.0 TARGET_ARCH=x86_64 sh -



## 참고
> [참고]
> [kubesphere ks-installer](https://github.com/kubesphere/ks-installer)
> [kubesphere 나만의 프로메테우스 사용하기](https://kubesphere.io/docs/faq/observability/byop/)
> [Installing Consul](https://www.consul.io/docs/k8s/installation/install#helm-chart-installation)
