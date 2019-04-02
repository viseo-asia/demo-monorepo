#!/bin/bash

set -e

/opt/scripts/init_mongo_rs.sh &

/usr/local/bin/docker-entrypoint.sh mongod --replSet rs0
