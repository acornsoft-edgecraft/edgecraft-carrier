#!/bin/bash

kubeconfig=./kubeconfig
PAAS_MONITORING_PATH="./clusters_paas_monitoring"
SUMMARY_LOG_FIlE="00_summary.log"
SUMMARY_LOG_FIlE_CONTENTS=""

main() {
## clusters 조회
file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
local apps_namespace=()

## Cluster 로그 수집
for i in $file_list
do
    local name=`basename $i .yaml`

    sed -i '' -r -e "s/cluster_name \:\= .*/cluster_name \:\= \"$name\" -\}\}/g" ./apps_info.tmpl

    apps_info=`kubectl --kubeconfig=$kubeconfig  get helmchartproxies.addons.cluster.x-k8s.io -o go-template-file=./apps_info.tmpl`
    apps_status=`kubectl --kubeconfig=$kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io -l cluster.x-k8s.io/cluster-name=$name -o go-template-file=./apps_status.tmpl`

    apps_namespace=()

    ## log 수집 파일 초기화
    if [[ -z $(find $PAAS_MONITORING_PATH/$name -type d 2> /dev/null) ]]; then
        mkdir $PAAS_MONITORING_PATH/$name
    else
        SUMMARY_LOG_FIlE_CONTENTS=`cat $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE`
        rm -rf $PAAS_MONITORING_PATH/$name/*
        echo "$SUMMARY_LOG_FIlE_CONTENTS" > $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    fi

    local status=(`echo "$apps_status" | grep "status:" | sed "s/status://g"`)
    apps_namespace=(`echo "$apps_status" | grep "namespace:" | sed "s/namespace://g"`)
    local owner_references=(`echo "$apps_status" | grep "ownerReferences:" | sed "s/ownerReferences://g"`)
    local creation_timestamp=(`echo "$apps_status" | grep "creationTimestamp:" | sed "s/creationTimestamp://g"`)
    local last_transition_time=(`echo "$apps_status" | grep "lastTransitionTime:" | sed "s/lastTransitionTime://g"`)
    local index=0

    for j in "${apps_namespace[@]}"
    do
        local log_file="$PAAS_MONITORING_PATH/$name/$j.log"
        if [[ -z $(find $log_file -type f 2> /dev/null) ]]; then
            echo "####  Components Status  ##################" > $log_file
            echo "# Component Status:" >> $log_file
            echo "# Component Group(namespace):" >> $log_file
            echo "# Component Name: ${owner_references[$index]}" >> $log_file
        else
            echo "# Component Name: ${owner_references[$index]}" >> $log_file
        fi
        index=$((index + 1))
    done

    ## namespace 중복 제거
    result=`echo "${apps_namespace[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`

    ## log 수집 실행
    k8s_get_all "${result[@]}"

    ## k8s status 상태 체크/log 수집 실행
    k8s_check_stauts

done
}

## log 수집
function k8s_get_all() {
local result=("$1")
for k in $result
do
    sed -i '' -r -e "s/Component Group\(namespace\)\:.*/Component Group\(namespace\)\: $k/g" $PAAS_MONITORING_PATH/$name/$k.log
    echo "" >> $PAAS_MONITORING_PATH/$name/$k.log
    
    ## 최근 로그 상위 출력
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
local false_namespace=()

while true
do
local apps_status=`kubectl --kubeconfig=$kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io -l cluster.x-k8s.io/cluster-name=$name -o go-template-file=./apps_status.tmpl`
local status=(`echo "$apps_status" | grep "status:" | sed "s/status://g"`)
local namespace=(`echo "$apps_status" | grep "namespace:" | sed "s/namespace://g"`)
local owner_references=(`echo "$apps_status" | grep "ownerReferences:" | sed "s/ownerReferences://g"`)
local creation_timestamp=(`echo "$apps_status" | grep "creationTimestamp:" | sed "s/creationTimestamp://g"`)
local last_transition_time=(`echo "$apps_status" | grep "lastTransitionTime:" | sed "s/lastTransitionTime://g"`)
local index=0

local false_index=(`echo "${status[@]}" | tr ' ' '\n' | grep -nv "True" | sed "s/:.*//g"`)
for k in "${false_index[@]}"
do
    false_namespace+=$(echo "${namespace[$((k - 1))]} ")
    # echo "${false_namespace[@]}" | grep -n ""
done

## namespace 중복 제거
local result=`echo ${false_namespace[@]} | tr ' ' '\n' | sort -u`

if [[ -n "${result[@]}" ]]; then
    ## log 수집 실행
    k8s_get_all "${result[@]}"
    print_summary
else
    break;
fi
exit 0
sleep 2
done

## 완료 확인 - log 수집
k8s_get_all "${result[@]}"
print_summary
}

function print_summary() {
    echo "" >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE

    ## 최근 로그 상위 출력
    cnt=`grep -c "Total Duration:" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE`
    file_head="$(sed -n "1, $(($cnt + 4))p" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE)"
    file_contents="$(sed -n "$(($cnt + 5)), \$p" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE)"
    get_start_time=$(start_time_taken "${creation_timestamp[@]}")
    get_last_time=$(end_time_taken "${last_transition_time[@]}")
    start_time=$(TZ='Asia/Seoul' date -d "$get_start_time" "+%s")
    end_time=$(TZ='Asia/Seoul' date -d $get_last_time "+%s")
    duration_of_time=$(( end_time - start_time ))

    echo "$file_head" > $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    echo "" >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    echo "###  [$(TZ='Asia/Seoul' date '+%Y-%m-%d(%a) %H:%M:%S')]  #####################################################################################################" >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    kubectl --kubeconfig=$kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io -l cluster.x-k8s.io/cluster-name=$name >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    echo "" >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    echo "$file_contents" >> $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    sed -i '' -r -e "s/Start Time\:.*/Start Time\: $(TZ='Asia/Seoul' date -d $get_start_time '+%Y-%m-%d(%a) %H:%M:%S')/g" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    sed -i '' -r -e "s/Ended Time\:.*/Ended Time\: $(TZ='Asia/Seoul' date -d $get_last_time '+%Y-%m-%d(%a) %H:%M:%S')/g" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
    sed -i '' -r -e "s/Total Duration\:.*/Total Duration\: $(TZ='Asia/Seoul' date -d @${duration_of_time} '+%H:%M:%S')/g" $PAAS_MONITORING_PATH/$name/$SUMMARY_LOG_FIlE
}

## 시작 시간 구하기
function start_time_taken() {
local list=("$@")
local end_time_last=${list[0]}
for j in ${list[@]}
do
    if [[ "$end_time_last" > "$j" ]]; then
        end_time_last=$j
    fi
done
echo $end_time_last
}

## 마지막 시간 구하기
function end_time_taken() {
local list=("$@")
local end_time_last=${list[0]}
for j in ${list[@]}
do
    if [[ "$end_time_last" < "$j" ]]; then
        end_time_last=$j
    fi
done
echo $end_time_last
}

# Main entry point.  Call the main() function
main