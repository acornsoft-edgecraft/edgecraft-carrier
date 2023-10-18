#!/bin/bash

log_path="./clusters_monitoring/cluster-100.log"
cat $log_path | awk 'NR>10'
cat $log_path | awk 'NR<10' 