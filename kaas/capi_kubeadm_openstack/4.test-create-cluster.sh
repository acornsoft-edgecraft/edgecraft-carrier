#!/bin/bash

file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
start_time=$(date "+%Y년 %m월 %d일 %A (%H시 %M분 %S초)")
cnt_clusters=$(ls ./clusters | wc -l)

for i in $file_list
do
    kubectl --kubeconfig=$1 apply -f $i
done

cat <<EOF > "./clusters_monitoring/cluster-$cnt_clusters.log"
Total_cluster: 
Total_instance: 
Current_instance: 
    control_plane: 
    worker_node: 
Start_Time: $start_time
End_Time:
Status:
EOF