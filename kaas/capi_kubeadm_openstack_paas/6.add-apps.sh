#!/bin/bash

kubeconfig=./kubeconfig
PAAS_MONITORING_PATH="./clusters_paas_monitoring"
COMPONENT_LIST=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'Chart\:' | grep -v "kongChart" | grep -i '^[^\#].*enabled' | sed "s/\: /\=/g"))
kong_add=$(echo $(cat ./clusters_paas_components/paas_components_list.yaml | grep 'kongChart\:' | grep -i '^[^\#].*enabled' | sed "s/\: /\=/g"))

file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
log_file_name="00_summary.log"

main() {
    for i in $file_list
    do
        name=`basename $i .yaml`
        
        kubectl --kubeconfig=$kubeconfig label clusters.cluster.x-k8s.io $name $COMPONENT_LIST

        echo "#### Components Status Summary  ##################" > $PAAS_MONITORING_PATH/$name/$log_file_name
        echo "# Start Time: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
        echo "# Ended Time: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
        echo "# Total Duration: " >> $PAAS_MONITORING_PATH/$name/$log_file_name
        if [[ -n "$kong_add" ]]; then
            apps_add &
        fi
    done
}

## 설치 순서
function apps_add() {
    status=true
    while $status
    do
        result=`kubectl --kubeconfig=$kubeconfig get helmreleaseproxies.addons.cluster.x-k8s.io | grep pass-kubeadm-provisioning | grep ingress-nginx | grep deployed`
        if [[ -n "$result" ]]; then
            kubectl --kubeconfig=$kubeconfig label clusters.cluster.x-k8s.io $name kongChart=enabled > /dev/null
            status=false
        fi
        sleep 2
    done
}

main