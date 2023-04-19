#!/bin/bash

find ./clusters -type f -name '*.yaml' -exec bash -c "basename {} .yaml | xargs -I %% sh -c '{ clusterctl --kubeconfig=$1 get kubeconfig %% > clusters_kubeconfig/%%; }'" \; 