#!/bin/bash

set -e

if [ "$1" == "" ]; then
  echo "Argument 1 Missing: Inventory"
  exit 1
fi
INVENTORY=$1

if [ "$2" == "" ]; then
  echo "Argument 2 Missing: Playbook"
  exit 1
fi
PLAYBOOK=$2

docker exec -ti $(docker ps | grep ansible | cut -f1 -d" ") ansible-playbook -i /opt/ansible/playbooks/${INVENTORY} /opt/ansible/playbooks/${PLAYBOOK}
