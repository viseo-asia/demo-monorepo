#!/bin/bash

set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${ROOT_DIR}

function startService {
    echo ''
    echo "-- SERVICE: ${1}"
    cd ${ROOT_DIR}/$1
    ../start-service-swarm.sh .
}

startService demo-proxy-swarm
startService demo-web-vue
startService demo-web-angular
startService demo-web-react
startService demo-nodejs
startService demo-python
startService demo-java
startService demo-php
startService demo-go
startService demo-comments
