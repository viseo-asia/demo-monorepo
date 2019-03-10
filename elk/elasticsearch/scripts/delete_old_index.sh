#!/bin/bash

if  [ "$1" -eq "$1" ] 2>/dev/null; then
  MAX_AGE=$1
else
  MAX_AGE=120
fi

echo "Deleting index older than ${MAX_AGE} days"
ELAST_CLOSE_DATE=$(date --date="$(date +%Y-%m-%d) -${MAX_AGE} day" +'%Y.%m.*') 
curl -X DELETE http://localhost:9200/logstash-${ELAST_CLOSE_DATE}/