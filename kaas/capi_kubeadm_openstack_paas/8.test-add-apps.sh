#!/bin/bash

K8S_CONFIG=$(ls ./clusters_kubeconfig | sort -n -t- -k4)

# COMPONENT_LIST=$(ls ./clusters_pass)

echo $(grep ./clusters_paas_components/paas_components_list.yaml)