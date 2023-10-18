#!/bin/bash
# LIST=""
# #find ./clusters -type f -name '*.yaml' -exec bash -c "basename {} .yaml | xargs kubectl --kubeconfig=$1 delete clusters " \; 
# find ./clusters -type f -name '*.yaml' -exec LIST=$(basename {} .yaml) \;
kubeconfig=./kubeconfig

# echo $LIST
file_list=$(ls ./clusters/*.yaml | sort -n -t- -k4)
LIST=""
for i in $file_list
do
    name=`basename $i .yaml`
    LIST+="$name "
    rm -f $i
    rm -f ./clusters_kubeconfig/$name
done

kubectl --kubeconfig=$kubeconfig delete clusters $LIST