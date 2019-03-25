#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}

docker rm -f docker-registry_registry_1 || true

docker-compose up -d