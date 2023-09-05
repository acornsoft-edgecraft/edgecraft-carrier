FROM jupyterhub/k8s-singleuser-sample:2.0.0

USER root

RUN apt-get update && \
    apt-get install -y \
    default-jdk

RUN pip install pyspark

USER ${NB_USER}