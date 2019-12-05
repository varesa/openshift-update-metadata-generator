#!/bin/sh

set -euo pipefail

clusterversion=$(oc get clusterversion version -o json)
updates=$(echo $clusterversion | jq '.status.availableUpdates')

len=$(echo $updates | jq '. | length')
if [ "$len" -gt "0" ]; then
    update=$(echo $updates | jq '.[0]')
    echo "Update available: $update"

    image=$(echo $update | jq '.image')
    version=$(echo $update | jq '.version')

    oc patch clusterversion version --type json -p'[
        {"op": "replace", "path": "/spec/desiredUpdate/image", "value": '$image'},
        {"op": "replace", "path": "/spec/desiredUpdate/version", "value": '$version'},
        {"op": "replace", "path": "/spec/desiredUpdate/force", "value": true},
    ]'
else
    echo "No updates available"
    exit 1
fi
