#!/bin/bash

kubeconfig=./kubeconfig
COMPONENT_LIST=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'Chart\:' | grep -i '^[^\#].*enabled' | sed "s/Chart\:.*$//g"))
PAAS_MONITORING_PATH="./clusters_paas_monitoring"
PROCESS=true

main() {
file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
local apps_namespace=()

for i in $file_list
do
    local name=`basename $i .yaml`

    sed -i '' -r -e "s/cluster_name \:\= .*/cluster_name \:\= \"$name\" -\}\}/g" ./apps_info.tmpl

    apps_info=$(kubectl --kubeconfig=$kubeconfig  get helmchartproxies.addons.cluster.x-k8s.io -o go-template-file=./apps_info.tmpl)
    apps_status=$(kubectl --kubeconfig=$kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io -l cluster.x-k8s.io/cluster-name=$name -o go-template-file=./apps_status.tmpl )

    apps_namespace=()

    ## log 수집 파일 초기화
    if [[ -z $(find $PAAS_MONITORING_PATH/$name -type d 2> /dev/null) ]]; then
        mkdir $PAAS_MONITORING_PATH/$name
    else
        rm -rf $PAAS_MONITORING_PATH/$name/*
    fi

    for j in $apps_status
    do
        # 문자열을 분할
        array=($(echo $j | tr "/" "\n"))
        apps_namespace+=$(echo "${array[1]} ")

        local log_file="$PAAS_MONITORING_PATH/$name/${array[1]}.log"
        if [[ -z $(find $log_file -type f 2> /dev/null) ]]; then
            echo "####  Components Status  ##################" > $log_file
            echo "# Component Status:" >> $log_file
            echo "# Component Group(namespace):" >> $log_file
            echo "# Component Name: ${array[0]}" >> $log_file
        else
            echo "# Component Name: ${array[0]}" >> $log_file
        fi
    done

    ## namespace 중복 제거
    result=`echo "${apps_namespace[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`

    ## log 수집 실행
    echo "## Log 수집 시작..."
    k8s_get_all "${result[@]}" &
    while jobs | grep -i "get all" | grep -i "Running" > /dev/null; do
    sleep 5
    done

    ## k8s status 상태 체크/log 수집 실행
    k8s_check_stauts "${result[@]}"

done
}

## log 수집
function k8s_get_all() {
local result=("$1")
for k in $result
do
    sed -i '' -r -e "s/Component Group\(namespace\)\:.*/Component Group\(namespace\)\: $k/g" $PAAS_MONITORING_PATH/$name/$k.log
    echo "" >> $PAAS_MONITORING_PATH/$name/$k.log
    
    cnt=`grep -c "Component Name:" $PAAS_MONITORING_PATH/$name/$k.log`
    file_head="$(sed -n "1, $(($cnt + 4))p" $PAAS_MONITORING_PATH/$name/$k.log)"
    file_contents="$(sed -n "$(($cnt + 5)), \$p" $PAAS_MONITORING_PATH/$name/$k.log)"
    
    echo "$file_head" > $PAAS_MONITORING_PATH/$name/$k.log
    echo "" >> $PAAS_MONITORING_PATH/$name/$k.log
    echo "###  [$(TZ='Asia/Seoul' date '+%Y-%m-%d(%a) %H:%M:%S')]  #####################################################################################################" >> $PAAS_MONITORING_PATH/$name/$k.log
    kubectl --kubeconfig="./clusters_kubeconfig/$name" -n $k get all >> $PAAS_MONITORING_PATH/$name/$k.log
    echo "" >> $PAAS_MONITORING_PATH/$name/$k.log
    echo "$file_contents" >> $PAAS_MONITORING_PATH/$name/$k.log
done
}

## Check k8s status
function k8s_check_stauts() {
local result=("$1")
local false_namespace=()
local status_true=()
local status_false=()
local status_all=()
for k in $result
do
    ready=$(kubectl --kubeconfig="./clusters_kubeconfig/$name" -n $k get pod -o go-template-file=./apps_pod_status.tmpl)
    
    for j in $ready
    do
        ## k8s status info 중복제거
        if [[ $j = "k8s_status_false:"* ]]; then
            # 문자열을 분할
            array_false=($(echo $j | sed "s/k8s_status_false\://g" | tr "/" "\n"))
            if [[ "${status_false[@]}" != *"k8s_status_false:${array_false[0]}/"* ]]; then
                status_false+=$(echo $j | sed "s/$/ /g")
            fi
        fi
    done
    for j in $ready
    do
        ## k8s status info 중복제거
        if [[ $j = "k8s_status_true:"* ]]; then
            # 문자열을 분할
            array_true=($(echo $j | sed "s/k8s_status_true\://g" | tr "/" "\n"))
            if [[ "${status_true[@]}" != *"k8s_status_true:${array_true[0]}/"* && "${array_false[0]}" != "${array_true[0]}" ]]; then
                status_true+=$(echo $j | sed "s/$/ /g")
            fi
        fi
    done
done

## Status 출력
for k in $status_false
do
    # echo "false === $k"
    log_path=($(echo $k | sed "s/k8s_status_false\://g" | tr "/" "\n"))
    sed -i '' -r -e "s/Component Status:.*$/Component Status: ${log_path[1]}/g" $PAAS_MONITORING_PATH/$name/${log_path[0]}.log
    k8s_get_all "${log_path[0]}"
done

for k in $status_true
do
    # echo "true === $k"
    log_path=($(echo $k | sed "s/k8s_status_true\://g" | tr "/" "\n"))
    sed -i '' -r -e "s/Component Status:.*$/Component Status: ${log_path[1]}/g" $PAAS_MONITORING_PATH/$name/${log_path[0]}.log
done

if [[ -n $status_false ]]; then
    result=`echo "${apps_namespace[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`
    k8s_check_stauts "${result[@]}"
fi
}
# Main entry point.  Call the main() function
main