#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

typeset -A HASH=(
	[a]=b,
	[c]=d
)

typeset -A HASH2=(
	[x]=xx,
	[y]=yy
)

HASH=$( json-hash-to-json HASH )

JSON=$(
	json-add-to-list 1 2 3 4 5 |
	json-set-json 1 "$HASH" |
	json-set-json 1 a "$(json-hash-to-json HASH2)"
)

echo "$JSON"

function testme {
        local -a params=( "$@" )

        echo "testing $(typeset -p params)"
	local RET=0
	json-get "$@" <<<"$JSON" || RET=$?
	if [[ $RET -ne 0 ]]; then
		echo "Error: $RET"
	fi
}

testme 0
testme 1
# Older jq throws different error
testme 8 2> >( sed -e 's/^\(jq: error\).*/\1/' 1>&2 )
testme 1 a
testme 1 c
testme 1 errror
testme # Whole tree
testme x
