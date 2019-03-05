#!/bin/bash

set -e


export DOCKER_REGISTRY=127.0.0.1:5000
export REGISTRY_NAMESPACE=dev
export VOLUMES_BASE_DIR=/opt/data


# Service
if [ "$1" == "" ]; then
  echo "Missing parameter: SERVICE_DIR"
  exit 1
fi
SERVICE_DIR=$1
cd ${SERVICE_DIR}


# Stage
if [ "$2" == "" ]; then
  STAGE=""
else
  STAGE=${2}
  echo "Stage: ${STAGE}"
fi


# Service Name
export SERVICE=$(cat info | grep name= | cut -f2 -d"=")


# Volumes
VOLUME_INFO=$(cat info | grep volumes= | cut -f2 -d"=")
IFS=';' read -ra ADDR <<< "${VOLUME_INFO}"
for VOLUME in "${ADDR[@]}"; do
  VOLUME_PATH=${VOLUME//\$\{VOLUMES_BASE_DIR\}/${VOLUMES_BASE_DIR}}
  if [ ! -d ${VOLUME_PATH} ]; then
    sudo mkdir -p ${VOLUME_PATH}
    sudo chmod -R 777 ${VOLUME_PATH}
  fi
done


# Networks
NETWORK_INFO=$(cat info | grep networks= | cut -f2 -d"=")
IFS=';' read -ra ADDR <<< "${NETWORK_INFO}"
for NETWORK in "${ADDR[@]}"; do
  if [ $(docker network ls | grep -c ${NETWORK}) -eq 0 ]; then
    docker network create --driver overlay ${NETWORK}
  fi
done


# Version
export SERVICE_VERSION=$(cat info | grep version= | cut -f2 -d"=")


# Build Image
docker-compose build
docker-compose push


# Deploy
if [ -f "docker-compose-${STAGE}.yml" ]; then
  COMPOSE_FILE_DEPLOY="docker-compose-${STAGE}.yml"
else
  COMPOSE_FILE_DEPLOY="docker-compose.yml"
fi
echo "Deployment Compose File: ${COMPOSE_FILE_DEPLOY}"
docker stack deploy --compose-file ${COMPOSE_FILE_DEPLOY} ${SERVICE}
