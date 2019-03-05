#!/bin/bash

set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${ROOT_DIR}

# To Reset all services
# kubectl get all \
#     | grep demo \
#     | grep -v replicaset.apps \
#     | grep -v pod \
#     | cut -f1 -d" " \
#     | xargs kubectl delete > /dev/null || true

# sleep 5

function startService {
    echo ''
    echo "-- SERVICE: ${1}"
    cd ${ROOT_DIR}/$1
    ../start-service-kubernetes.sh .
}

startService demo-proxy-kubernetes
startService demo-web-vue
startService demo-web-angular
startService demo-web-react
startService demo-cats
startService demo-dogs
startService demo-hamsters
startService demo-parrots
startService demo-turtles
startService demo-comments
