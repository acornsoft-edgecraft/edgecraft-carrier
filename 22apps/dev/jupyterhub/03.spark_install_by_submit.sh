#!/bin/sh

export KUBECONFIG=../../88apps.kubeconfig

sample_id=sparkpi-test3

# spark submit
/opt/spark/bin/spark-submit \
  --master k8s://https://192.168.88.123:6443 \
  --deploy-mode cluster \
  --driver-memory 1g \
  --conf spark.kubernetes.memoryOverheadFactor=0.5 \
  --name ${sample_id} \
  --class org.apache.spark.examples.SparkPi \
  --conf spark.kubernetes.container.image=spark:latest \
  --conf spark.kubernetes.driver.pod.name=${sample_id} \
  --conf spark.kubernetes.namespace=spark \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
  --verbose \
  local:///opt/spark/examples/jars/spark-examples_2.12-3.4.1.jar 1000