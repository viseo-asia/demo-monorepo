#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}

export ENV=dev

kubectl -n ${ENV}-env get gateway | grep demo-multitech | cut -f1 -d" " | xargs kubectl -n ${ENV}-env delete gateway 
kubectl -n ${ENV}-env get virtualservice | grep demo-multitech | cut -f1 -d" " | xargs kubectl -n ${ENV}-env delete virtualservice 

kubectl -n ${ENV}-env apply -f gateway.yaml