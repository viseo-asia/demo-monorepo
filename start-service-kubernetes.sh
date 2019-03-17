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


# Version
export SERVICE_VERSION=$(cat info | grep version= | cut -f2 -d"=")


# Build Image
docker-compose build
docker-compose push


# Deploy
if [ -f "kube-deploy-${STAGE}.yml" ]; then
  KUBE_FILE_DEPLOY="kube-deploy-${STAGE}.yml"
else
  KUBE_FILE_DEPLOY="kube-deploy.yml"
fi
echo "Deployment Kube File: ${KUBE_FILE_DEPLOY}"

VOLUMES_BASE_DIR_ESCAPED=${VOLUMES_BASE_DIR//\//\\\/}
cat ${KUBE_FILE_DEPLOY} \
  | sed "s/\${SERVICE}/${SERVICE}/g" \
  | sed "s/\${SERVICE_VERSION}/${SERVICE_VERSION}/g" \
  | sed "s/\${DOCKER_REGISTRY}/${DOCKER_REGISTRY}/g" \
  | sed "s/\${REGISTRY_NAMESPACE}/${REGISTRY_NAMESPACE}/g" \
  | sed "s/\${VOLUMES_BASE_DIR}/${VOLUMES_BASE_DIR_ESCAPED}/g" \
  | sed "s/\${STAGE}/${STAGE}/g" > .tmp_${KUBE_FILE_DEPLOY}

kubectl apply -f .tmp_${KUBE_FILE_DEPLOY}
rm -f .tmp_${KUBE_FILE_DEPLOY}
