#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}

kubectl -n dev-env get all | grep counter | cut -f1 -d" " | xargs kubectl -n dev-env delete

../../start-service-kubernetes.sh .

sleep 15

kubectl -n dev-env logs $(kubectl -n dev-env get pods | grep counter | grep Running | head -n1 | cut -f1 -d" ") demo-multitech-visits-counter -f
