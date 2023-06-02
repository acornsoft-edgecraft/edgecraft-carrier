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
        echo "----- $name ------------------------------------------------------------------------------------------------------------------------------------------------------------" >> $log_path
        kubectl --kubeconfig=./clusters_kubeconfig/$i get nodes -o wide >> $log_path 
        echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> $log_path
        echo "" >> $log_path
        get_lastTransitionTime=`kubectl --kubeconfig=./clusters_kubeconfig/$i get nodes -o jsonpath='{.items[*].status.conditions[?(@.type == "Ready")].lastTransitionTime}' | tr " " "\n"`
        
        for k in $get_lastTransitionTime
        do
            time_list+=( $k )
        done
    done

    control_plane=$(cat $log_path | grep control-plane- | wc -l)
    md=$(cat $log_path | grep md- | wc -l)
    sed -i '' -r -e "s/control_plane\:.*/control_plane\: $control_plane/g" $log_path
    sed -i '' -r -e "s/worker_node\:.*/worker_node\: $md/g" $log_path

    if [ $total_instance -eq $(($control_plane + $md)) ]; then
        result=$(grep "NotReady" $log_path)
        if [ -z "$result" ]; then

            ## 마지막 완료 시간 구하기
            for j in ${time_list[@]}
            do
                sec=$(date -d "$j" "+%s")
                if [ $end_time_last -lt $sec ]; then
                    # end_time=$j
                    end_time_last=$sec
                    end_time=$j
                fi
            done

            end_time=$(date -d $end_time "+%Y년 %m월 %d일 %A (%H시 %M분 %S초)")
            sed -i '' -r -e "s/End_Time\:/End_Time\: $end_time/g" $log_path
            sed -i '' -r -e "s/Status\:/Status\: Ready/g" $log_path
        fi
    fi
fi
