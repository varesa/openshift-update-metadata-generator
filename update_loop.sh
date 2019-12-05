#!/bin/sh

set -euo pipefail

while true; do

    until [[ "$(oc get clusterversion version -o json | jq -r '.status.conditions[] | select(.type=="Progressing").status')" == "False" ]]; do
        #echo "Still working"
        sleep 5
    done
    
    sleep 30

    # After waiting a moment check if the cluster is still stable
    if [[ "$(oc get clusterversion version -o json | jq -r '.status.conditions[] | select(.type=="Progressing").status')" == "True" ]]; then
        continue
    fi

    echo "CVO is not in progress"

    if ./update.sh; then
        echo "Started new upgrade, waiting for it to finnish"
    else
        echo "Either we ran out of upgrades or there was some error"
        exit 0
    fi
done
