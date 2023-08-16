#!/bin/sh

# OpenJDK 설치 (linux)
# sudo apt-get -y install openjdk-8-jdk-headless

# 다운로드 spark 3.4.1 with hadoop 3
wget https://downloads.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz
tar xvf spark-3.4.1-bin-hadoop3.tgz
sudo mv spark-3.4.1-bin-hadoop3 /opt/spark