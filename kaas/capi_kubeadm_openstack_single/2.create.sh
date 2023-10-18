#!/bin/bash

# kubectl --kubeconfig=$1 apply -f ./clusters
file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
start_time=$(TZ='Asia/Seoul' date "+%Y-%m-%d(%A) %H:%M:%S")
cnt_clusters=$(ls ./clusters | wc -l)
kubeconfig=./kubeconfig

for i in $file_list
do
    kubectl --kubeconfig=$kubeconfig apply -f $i
done

cat <<EOF > "./clusters_monitoring/cluster-$cnt_clusters.log"
Start_Time: $start_time
End_Time:
Total_Duration:
Status:

Duration_of_time
    Min_time:
    Max_time:
    Average_time:
EOF