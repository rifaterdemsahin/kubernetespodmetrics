#!/bin/bash
# chmod 777 /workspaces/kubernetespodmetrics/symbolic-execute.sh

echo "Starting the application of symbol-metric-server.yaml"
kubectl apply -f symbol-metric-server.yaml
if [ $? -eq 0 ]; then
    echo "Successfully applied symbol-metric-server.yaml"
else
    echo "Failed to apply symbol-metric-server.yaml"
fi