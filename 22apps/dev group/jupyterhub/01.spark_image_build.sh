#!/bin/sh

# OpenJDK 설치 (linux)
# sudo apt-get -y install openjdk-8-jdk-headless

# 다운로드 spark 3.4.1 with hadoop 3
wget https://downloads.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz
tar xvf spark-3.4.1-bin-hadoop3.tgz
sudo mv spark-3.4.1-bin-hadoop3 /opt/spark

# spark image build
cat /opt/spark/kubernetes/dockerfiles/spark/Dockerfile
cd /opt/spark
docker build -t spark:latest -f kubernetes/dockerfiles/spark/Dockerfile .

# pyspark image build
# spark 기본 이미지는 Python을 지원하지 않음.
# s3a, postgres 를 지원해야하는 경우는 maven jar를 추기해야 한다. [수정된 Dockerfile](https://github.com/akoshel/spark-k8s-jupyterhub/blob/main/pyspark.Dockerfile) 참고
cd /opt/spark
# Dofkerfile의 `ARG base_img`에 spark:latest를 지정해야 한다.
docker build -t pyspark:latest -f kubernetes/dockerfiles/spark/bindings/python/Dockerfile .

# spark 실행 준비
kubectl apply -f spark_ns_account.yaml