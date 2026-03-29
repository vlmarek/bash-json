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

typeset -a MYLIST

function testme {
        local -a params=( "$@" )

	local RET=0
	json-to-list MYLIST <<<"$1" || RET=$?
	typeset -p MYLIST

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
