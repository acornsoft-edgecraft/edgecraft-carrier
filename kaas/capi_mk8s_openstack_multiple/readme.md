# Cluster API with Openstack and MicroK8s

## Environments

- Management Cluster는 내부 `edgecraft` 클러스터 사용
- Cluster API 환경
  | Type | Provider |
  | --- | --- |
  | BooBootstrap | microk8s |
  | Control Plane | microk8s |
  | Infrastructure | openstack |

## Setup

- [Install clusterctl](https://cluster-api.sigs.k8s.io/user/quick-start.html#install-clusterctl)

  ```shell
  # Download for AMD64 on Mac
  $ curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.3.2/clusterctl-darwin-amd64 -o clusterctl

  # make executable
  $ chmod +x ./clusterctl

  # move binary to PATH
  $ sudo mv ./clusterctl /usr/local/bin/clusterctl

  # check version
  $ clusterctl version
  ```

## Single Cluster 실행

1. Provider 설정
   ```shell
   $ ./1.cluster-init.sh
   ```
2. Template에 사용될 변수들 확인
   ```shell
   $ ./2.var-list.sh
   ```
   화면에 출력된 변수들을 `cluster-template-openstack.rc` 파일에 등록 또는 갱신하고 값을 설정한다. (ex. 새로운 Openstack 연결정보 base64 정보 등)
3. RC 파일 구성 및 cluster manifest 생성
   ```shell
   $ ./3.generate.sh
   ```
   템플릿에 작성한 rc 파일의 환경변수 값을 적용해서 실제 구성할 클러스터 매니페스트 파일 생성
4. cluster manifest 적용
   ```shell
   $ ./4.create-cluster.sh
   ```
   생성된 클러스터 매니페이스 파일을 kubectl로 적용해서 Workload 클러스터 생성
5. workload's kubeconfig 추출
   ```shell
   $ ./5.get_kubeconfig.sh
   ```
   생성된 클러스터에 대한 접근을 위한 kubeconfig 파일 구성
   ```shell
   $ kubectl get nodes --kubeconfig ./kubeconfig
   ```

## Cluster 반복 실행 (100개)

반복을 위해서는 위에 설명한 `./3.generate.sh 와 ./4.create-cluster.sh`를 반복하는 스크립트를 생성해야 한다.

1. `./3.generate.sh` 명령에서 클러스터의 이름을 반복되는 값으로 설정해서 100개의 클러스터 매니페스트 생성
2. 생성된 클러스터 매니페스트 파일 100개를 kubectl로 적용
