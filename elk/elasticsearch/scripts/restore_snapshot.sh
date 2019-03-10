#!/bin/bash

# Usage: Basic POST command to restore the snapshot snapshots:01.
#        Before restore,
#        1. The files of the snapshot should exists in the snapshot local dirpath first.
#        For details, please refer to the link:
#        https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html#_restore

curl -v -X POST 'elk-elasticsearch:9200/_snapshot/snapshots/01/_restore'
