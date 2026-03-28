#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

HASH=$( json-add-to-hash-key-value a b )

LIST=( $( seq 17 -3 1 ) )

LIST=$( json-list-to-json LIST )

json-add-to-hash-key-json 1 "$HASH"

json-add-to-hash-key-json 1 "$HASH" |
json-add-to-hash-key-json 2 2 "$LIST" |
json-add-to-hash-key-json 3 3 3 "$HASH"


RET=0
echo '[1,2]' | json-add-to-hash-key-json k l || RET=$?
echo "Error: $RET"

RET=0
echo 'string' | json-add-to-hash-key-json k l || RET=$?
echo "Error: $RET"
