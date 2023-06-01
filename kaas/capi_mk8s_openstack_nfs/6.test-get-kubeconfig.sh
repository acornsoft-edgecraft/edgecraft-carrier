#!/bin/bash

kubeconfig=./kubeconfig

find ./clusters -type f -name '*.yaml' -exec bash -c "basename {} .yaml | xargs -I %% sh -c '{ clusterctl --kubeconfig=$kubeconfig get kubeconfig %% > clusters_kubeconfig/%%; }'" \; 