#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

json-add-to-hash-key-value a b

echo '{}' | json-add-to-hash-key-value c d

json-add-to-hash-key-value e f |
json-add-to-hash-key-value 'g h' 'i j'

RET=0
echo '[1,2]' | json-add-to-hash-key-value k l || RET=$?
echo "Error: $RET"

RET=0
# Modify the stderr and exit code so that it matches the output of more recent jq
echo 'string' | json-add-to-hash-key-value k l 2> >(sed -e 's/^p/jq: p/' >&2) || RET=$?
[ $RET != 4 ] || RET=5
echo "Error: $RET"

json-add-to-hash-key-value $(seq 1 10)
