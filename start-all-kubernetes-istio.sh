#!/bin/bash

set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${ROOT_DIR}

# To Reset all services
kubectl get all \
    | grep demo \
    | grep -v replicaset.apps \
    | grep -v pod \
    | cut -f1 -d" " \
    | xargs kubectl delete > /dev/null || true

# sleep 5

function startService {
    echo ''
    echo "-- SERVICE: ${1}"
    cd ${ROOT_DIR}/$1
    ../../start-service-kubernetes.sh .
}

startService demo-multitech/demo-multitech-web-vue
startService demo-multitech/demo-multitech-nodejs
startService demo-multitech/demo-multitech-python
startService demo-multitech/demo-multitech-java
startService demo-multitech/demo-multitech-php
startService demo-multitech/demo-multitech-go
startService demo-multitech/demo-multitech-comments

cd ${ROOT_DIR}
./demo-multitech/rules-istio/apply.sh


# startService monitoring/elk-elasticsearch
# startService monitoring/elk-kibana
# startService monitoring/elk-logspout
# startService monitoring/elk-logstash
# startService monitoring/prometheus
# startService monitoring/prometheus-grafana
