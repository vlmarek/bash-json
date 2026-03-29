#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

JSON=$( cat <<'EOT'
["\n","newline","\"","\"","'","'","1","1","1 2 3","1\t2\t3","\\n","\\n","o\no","o\no","xyz",""]
EOT
)

RET=0
json-to-list MYLIST <<<"$JSON" || RET=$?
echo "ERROR: $RET"

# Older bash shows list differently, let's make my function
function showlist {
	local -n LIST_REF=$1
	printf "declare -a %s=(" "$1"
	local i=0
	while [[ $i -lt "${#LIST_REF[@]}" ]]; do
		[[ $i -eq 0 ]] || printf ' '
		printf '[%d]=%q' $i "${LIST_REF[$i]}"
		i=$(( $i + 1 ))
	done
	printf ')\n'
}

typeset -a MYLIST

function testme {
        local -a params=( "$@" )
        echo "testing $(showlist params)"

	local RET=0
	json-to-list MYLIST <<<"$1" || RET=$?
	showlist MYLIST

	return $RET
}

testme '["a","b"]'
testme '["\n","newline"]'
testme '["\"","\""]'
testme "[\"'\",\"'\"]"
testme '["1\t2\n3","1\t2\n3"]'
testme '["\\n","\\n"]'
testme '["o\no","o\no"]'
testme '["xyz",""]'

# Error
RET=0
# stderr changes for older jq
testme '["1","empty' 2> >( sed -e 's/^p/jq: p/' 1>&2) || RET=$?
[ $RET -ne 4 ] || RET=5 # older jq
echo "Error: $RET"

# Error, wrong type
RET=0
testme '{"a":"b"}' || RET=$?
echo "Error: $RET"
