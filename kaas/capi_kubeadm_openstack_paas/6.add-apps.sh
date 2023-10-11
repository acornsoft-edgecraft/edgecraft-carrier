#!/bin/bash

kubeconfig=./kubeconfig
PAAS_MONITORING_PATH="./clusters_paas_monitoring"
COMPONENT_LIST=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'Chart\:' | grep -i '^[^\#].*enabled' | sed "s/\: /\=/g"))

file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
log_file_name="00_summary.log"
for i in $file_list
do
    name=`basename $i .yaml`
    
    kubectl --kubeconfig=$kubeconfig label clusters.cluster.x-k8s.io $name $COMPONENT_LIST

    echo "#### Components Status Summary  ##################" > $PAAS_MONITORING_PATH/$name/$log_file_name
    echo "# Start Time: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
    echo "# Ended Time: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
    echo "# Total Duration: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
done