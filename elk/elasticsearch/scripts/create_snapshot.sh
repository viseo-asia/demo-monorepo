#!/bin/bash

# Usage: Create backup snapshots:01

HTTP_CODE=`curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: application/json' -X PUT 'elk-elasticsearch:9200/_snapshot/snapshots/01'`
if [ "${HTTP_CODE}" != "200" ]; then
  exit 1
else
  exit 0
fi
