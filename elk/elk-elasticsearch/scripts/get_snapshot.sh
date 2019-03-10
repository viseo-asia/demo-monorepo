#!/bin/bash

# Usage: GET snapshots:01
#        Output Result to verify if the snapshot created by the scripts exist

curl -v 'elk-elasticsearch:9200/_snapshot/snapshots/01'
