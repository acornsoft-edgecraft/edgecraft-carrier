#!/bin/bash

source ./cluster-template-openstack.rc

total_cluster=$(ls ./clusters | wc -l)
log_path="./clusters_monitoring/cluster-$total_cluster.log"
err_log_path="./clusters_monitoring/cluster-$total_cluster-err.log"

total_instance=$((($CONTROL_PLANE_MACHINE_COUNT + $WORKER_MACHINE_COUNT) * $total_cluster))

list=$(ls ./clusters_kubeconfig | sort -n -t- -k4)
list_cnt=$(echo "$list" | wc -l)
time_list=()

main() {
local cluster_time_list=()
if [ $list_cnt -eq $total_cluster ]; then
    sed -i '' -r -e '10,$d' $log_path
    sed -i '' -r -e "s/Total_cluster\:.*/Total_cluster\: $total_cluster/g" $log_path
    sed -i '' -r -e "s/Total_instance\:.*/Total_instance\: $total_instance/g" $log_path
    sed -i '' -r -e "s/End_Time\:.*$/End_Time\:/g" $log_path
    sed -i '' -r -e "s/Total_Duration\:.*$/Total_Duration\:/g" $log_path
    sed -i '' -r -e "s/Status\:.*$/Status\:/g" $log_path
    echo "" >> $log_path
    for i in $list
    do
        name=`basename $i`
        cluster_time_list=()

        ## 노드 완료 시간
        get_lastTransitionTime=`kubectl --kubeconfig=./clusters_kubeconfig/$i get nodes -o jsonpath='{.items[*].status.conditions[?(@.type == "Ready")].lastTransitionTime}' | tr " " "\n"`
        for k in $get_lastTransitionTime
        do
            time_list+=( $k )
            cluster_time_list+=( $k )
        done

        local get_k8s_status=()
        for k in $(kubectl --kubeconfig=./kubeconfig describe machines.cluster.x-k8s.io  $i-control-plane | grep "Creation Timestamp" | awk '{print $3}' | tr " " "\n")
        do
            get_k8s_status+=( $k )
        done

        get_last_time=$(end_time_taken "${cluster_time_list[@]}")
        get_start_time=$(start_time_taken "${get_k8s_status[@]}")
        start_time=$(TZ='Asia/Seoul' date -d "$get_start_time" "+%s")
        end_time=$(TZ='Asia/Seoul' date -d $get_last_time "+%s")
        duration_of_time=$(( end_time - start_time ))
        echo "----- $name -----------------------------------------------------------------------------------------------------------------------------------------------------------" >> $log_path
        echo "Duration of time: $(TZ='Asia/Seoul' date -u -d @${duration_of_time} '+%H:%M:%S')" >> $log_path
        kubectl --kubeconfig=./clusters_kubeconfig/$i get nodes -o wide >> $log_path 
        echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> $log_path
        echo "" >> $log_path
    done

    control_plane=$(cat $log_path | grep control-plane- | wc -l)
    md=$(cat $log_path | grep md- | wc -l)
    sed -i '' -r -e "s/control_plane\:.*/control_plane\: $control_plane/g" $log_path
    sed -i '' -r -e "s/worker_node\:.*/worker_node\: $md/g" $log_path

    if [ $total_instance -eq $(($control_plane + $md)) ]; then
        result=$(grep "NotReady" $log_path)
        if [ -z "$result" ]; then
            total_start_time=$(grep -i "Start_Time" $log_path | awk '{print $2 " " $3}')
            last_transition_time=$(end_time_taken "${time_list[@]}")
            end_time=$(TZ='Asia/Seoul' date -d $last_transition_time "+%Y-%m-%d(%A) %H:%M:%S")

            sec_total_start_time=$(TZ='Asia/Seoul' date -d "$total_start_time" "+%s")
            sec_end_time=$(TZ='Asia/Seoul' date -d "$end_time" "+%s")
            sec_total_duration=$(( sec_end_time - sec_total_start_time ))
            total_duration=$(TZ='Asia/Seoul' date -u -d @${sec_total_duration} "+%H:%M:%S")
            sed -i '' -r -e "s/End_Time\:/End_Time\: $end_time/g" $log_path
            sed -i '' -r -e "s/Total_Duration\:/Total_Duration\: $total_duration/g" $log_path
            sed -i '' -r -e "s/Status\:/Status\: Ready/g" $log_path
        fi
    fi
fi
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