#!/bin/bash

# Usage: Init Repository

if [ "$LOCAL_PATH_REPO" == "" ]; then
  # defined in the elasticsearch.yml 'path.repo' property.
  LOCAL_PATH_REPO="/usr/share/elasticsearch/backup/snapshots"
fi

HTTP_CODE=`curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: application/json' -X PUT -d '{"type":"fs", "settings": { "location": "'$LOCAL_PATH_REPO'" }}' "elk-elasticsearch:9200/_snapshot/snapshots"`
if [ "${HTTP_CODE}" != "200" ]; then
  exit 1
else
  exit 0
fi
