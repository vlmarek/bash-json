#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

typeset -A HASH=(
	[a]=b,
	[c]=d
)

HASH=$( json-hash-to-json HASH )

JSON=$(
	json-empty-list |
	json-add-to-list 1 2 3 |
	json-set-json 1 "$HASH"
)

function testme {
	json-remove "$@" <<<"$JSON"
}

testme 0
testme 1
testme 2
testme 4
testme 1 a
testme 1 c
testme 1 x

RET=0
testme 1 x y z || RET=$?
echo "Error: $RET"

RET=0
testme x || RET=$?
echo "Error: $RET"
