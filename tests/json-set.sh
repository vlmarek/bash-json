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
	local TESTJSON='["h","a","!"]'

	echo "testing $(typeset -p params)"
	local RET=0
	json-set-value "$@" <<<"$JSON" || RET=$?
	if [[ $RET -ne 0 ]]; then
		echo "Error: $RET"
	fi

	params[-1]="$TESTJSON"
	set -- "${params[@]}"

	echo "testing $(typeset -p params)"
	local RET=0
	json-set-json "$@" <<<"$JSON" || RET=$?
	if [[ $RET -ne 0 ]]; then
		echo "Error: $RET"
	fi

}

testme 0 # Error, no value set
testme 0 new
testme 1 new
testme 8 new # Creates null values. Do we want that
testme 1 a new-in-hash
testme 1 x new-in-hash
testme a x # string as array index
testme 5 a b x # Create hash which did not exist before
