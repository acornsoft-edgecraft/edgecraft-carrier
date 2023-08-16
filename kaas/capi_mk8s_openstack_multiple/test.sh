#!/bin/bash

total_cluster=$(ls ./clusters | wc -l)
log_path="./clusters_monitoring/cluster-$total_cluster.log"


result=$(grep "Ready" $log_path | grep -Ev "Status:" | awk '{printf "%s\n", $1}' | sort -r -n -t- -k4)
if [[ -z "$result" ]]; then
  echo "True"
else
  for i in $result
  do
    sed -i '' -r -e "s/Status\:.*/Status\: NotReady\n   NotReady Node - $i/g" $log_path
  done
fi