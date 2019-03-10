#!/bin/bash

# Usage: Delete backup snapshots:01 which created by the scripts. Usually for clean-up only.

curl -v -X DELETE 'elk-elasticsearch:9200/_snapshot/snapshots/01'
