#!/bin/bash

set -eE

## helm chart
VERSION="4.1.4"
URL="https://vmware-tanzu.github.io/helm-charts"
RELEASE_NAME="vmware-tanzu"
CHART_NAME="velero"
CHART_VALUES="./assets/${CHART_NAME}/values-edgecraft.yaml"
CHART_DIR="./assets/${CHART_NAME}"

## k8s
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="velero"

## dependencies
DEPENDENCIES=$(cat <<EOF
- condition: minio.enabled
  name: minio
  repository: https://charts.min.io
  version: 5.0.13
EOF
)

# add charts repo
if [[ -z $(helm repo list | grep -i "${URL}") ]]; then
    helm repo add ${RELEASE_NAME} ${URL}
fi
helm repo update

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
if [[ -z $(ls $CHART_VALUES) ]]; then
    helm pull ${RELEASE_NAME}/${CHART_NAME} --untar -d ./assets --version ${VERSION}
fi

# dependency 추가
if [[ -z $(grep -e "${DEPENDENCIES}" ${CHART_DIR}/Chart.yaml) ]];then
    result=""
    if [[ $(grep -i "dependencies" ${CHART_DIR}/Chart.yaml) ]]; then
        result="true"
    fi

    while IFS= read -r line
    do
        printf '%s\n' "$line" >> ${CHART_DIR}/temp.yaml
        if [[ -z ${result} ]]; then
            if [[ $line =~ appVersion:* ]]; then
                printf '%s\n' "dependencies:" >> ${CHART_DIR}/temp.yaml
                printf '%s\n' "${DEPENDENCIES}" >> ${CHART_DIR}/temp.yaml
            fi
        else
            if [[ $line =~ "dependencies:" ]]; then
                printf '%s\n' "${DEPENDENCIES}" >> ${CHART_DIR}/temp.yaml
            fi
        fi
    done < ${CHART_DIR}/Chart.yaml

    cp ${CHART_DIR}/Chart.yaml ${CHART_DIR}/Chart.yaml_"$(date +%Y%m%d)"
    cp ${CHART_DIR}/temp.yaml ${CHART_DIR}/Chart.yaml
    rm -f ${CHART_DIR}/temp.yaml
fi

# helm dependency 관리
## Usage:
##   helm dependency [command]
##
## Aliases:
##   dependency, dep, dependencies
##
## Available Commands:
##   build       rebuild the charts/ directory based on the Chart.lock file
##   list        list the dependencies for the given chart
##   update      update charts/ based on the contents of Chart.yaml
helm dependency update ${CHART_DIR} --skip-refresh

for filename in $(ls ${CHART_DIR}/charts/*.tgz)
do
    echo $filename
    # -k: 파일 충돌 시 기존 파일을 보호하고 덮어쓰지 않습니다.
    tar -zxf "$filename" -C ${CHART_DIR}/charts -k
    rm -f "$filename"
done


# install using helm
## Usage:
##   helm upgrade [RELEASE] [CHART] [flags]
cloud=$(cat <<EOF
[default]
aws_access_key_id = edgecraft
aws_secret_access_key = edgecraft
EOF
)

helm upgrade ${CHART_NAME} ${CHART_DIR} \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CHART_VALUES} \
    --version ${VERSION} \
    --set minio.enabled=true \
    --set minio.persistence.storageClass="nfs-csi" \
    --set minio.persistence.size="100Gi" \
    --set minio.rootUser="edgecraft" \
    --set minio.rootPassword="edgecraft" \
    --set minio.replicas=2 \
    --set minio.resources.requests.memory="4Gi" \
    --set minio.service.type="NodePort" \
    --set minio.service.port="32000" \
    --set minio.consoleService.type="NodePort" \
    --set minio.consoleService.port="32001" \
    --set minio.minioAPIPort="32000" \
    --set minio.minioConsolePort="32001" \
    --set minio.buckets[0].name=velero,minio.buckets[0].policy=none,minio.buckets[0].purge=false \
    --set initContainers[0].name="velero-plugin-for-aws",initContainers[0].image="velero/velero-plugin-for-aws:v1.7.0" \
    --set initContainers[0].imagePullPolicy="IfNotPresent" \
    --set initContainers[0].volumeMounts[0].mountPath="/target",initContainers[0].volumeMounts[0].name="plugins" \
    --set-string credentials.secretContents.cloud="$cloud" \
    --set snapshotsEnabled=false