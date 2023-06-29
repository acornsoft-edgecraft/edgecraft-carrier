#!/bin/sh

# add spark-operator repo
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
helm pull --untar -d ./assets spark-operator/spark-operator
