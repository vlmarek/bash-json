#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

HASH=$( json-empty-hash | json-add-to-hash-key-value a b )

LIST=( $( seq 17 -3 1 ) )

LIST=$( json-list-to-json LIST )

json-empty-hash | json-add-to-hash-key-json 1 "$HASH"

json-empty-hash | json-add-to-hash-key-json 1 "$HASH" |
json-add-to-hash-key-json 2 2 "$LIST" |
json-add-to-hash-key-json 3 3 3 "$HASH"


RET=0
echo '[1,2]' | json-add-to-hash-key-json k l || RET=$?
echo "Error: $RET"

RET=0
# stderr changes for older jq
echo 'string' | json-add-to-hash-key-json k l 2> >( sed -e 's/^p/jq: p/' 1>&2) || RET=$?
[ $RET -ne 4 ] || RET=5 # older jq
echo "Error: $RET"
