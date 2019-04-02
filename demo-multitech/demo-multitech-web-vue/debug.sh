#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}

kubectl -n dev-env get all | grep web-vue | cut -f1 -d" " | xargs kubectl -n dev-env delete

../../start-service-kubernetes.sh .

