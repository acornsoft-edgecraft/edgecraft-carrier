#!/bin/bash

source ./cluster-template-openstack.rc

total_cluster=$(ls ./clusters | wc -l)
log_path="./clusters_monitoring/cluster-$total_cluster.log"
err_log_path="./clusters_monitoring/cluster-$total_cluster-err.log"

total_instance=$((($CONTROL_PLANE_MACHINE_COUNT + $WORKER_MACHINE_COUNT) * $total_cluster))

list=$(ls ./clusters_kubeconfig | sort -n -t- -k4)
list_cnt=$(echo "$list" | wc -l)
end_time_last=0
time_list=()
cluster_time_list=()

main() {
if [ $list_cnt -eq $total_cluster ]; then
    sed -i '' -r -e '9,$d' $log_path
    sed -i '' -r -e "s/Total_cluster\:.*/Total_cluster\: $total_cluster/g" $log_path
    sed -i '' -r -e "s/Total_instance\:.*/Total_instance\: $total_instance/g" $log_path
    sed -i '' -r -e "s/End_Time\:.*$/End_Time\:/g" $log_path
    sed -i '' -r -e "s/Status\:.*$/Status\:/g" $log_path
    echo "" >> $log_path
    for i in $list
    do
        name=`basename $i`

        ## 노드 완료 시간
        get_lastTransitionTime=`kubectl --kubeconfig=./clusters_kubeconfig/$i get nodes -o jsonpath='{.items[*].status.conditions[?(@.type == "Ready")].lastTransitionTime}' | tr " " "\n"`
        for k in $get_lastTransitionTime
        do
            time_list+=( $k )
            cluster_time_list+=( $k )
        done

        get_last_time=$(time_taken "${cluster_time_list[@]}")
        get_start_time=`kubectl --kubeconfig=./kubeconfig describe machines.cluster.x-k8s.io  mk8s-os-cluster-1-control-plane | grep "Creation Timestamp" | awk '{print $3}'`
        start_time=$(date -d $get_start_time "+%s")
        end_time=$(date -d $get_last_time "+%s")
        duration_of_time=$(( end_time - start_time ))
        echo "----- $name -----------------------------------------------------------------------------------------------------------------------------------------------------------" >> $log_path
        echo "Duration of time: $(date -u -d @${duration_of_time} +%H:%M:%S)" >> $log_path
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
            last_transition_time=$(time_taken "${time_list[@]}")
            end_time=$(date -d $last_transition_time "+%Y년 %m월 %d일 %A (%H시 %M분 %S초)")
            sed -i '' -r -e "s/End_Time\:/End_Time\: $end_time/g" $log_path
            sed -i '' -r -e "s/Status\:/Status\: Ready/g" $log_path
        fi
    fi
fi
}

## 마지막 완료 시간 구하기
function time_taken() {
local list=("$@")
for j in ${list[@]}
do
    sec=$(date -d "$j" "+%s")
    if [ $end_time_last -lt $sec ]; then
        # end_time=$j
        end_time_last=$sec
        end_time=$j
    fi
done
echo $end_time
}

# Main entry point.  Call the main() function
main