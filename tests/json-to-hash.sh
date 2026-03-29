#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

JSON=$( cat <<'EOT'
{"\n":"newline","\"":"\"","'":"'","1":"1","1 2 3":"1\t2\t3","\\n":"\\n","o\no":"o\no","xyz":""}
EOT
)

RET=0
json-to-hash MYHASH <<<"$JSON" || RET=$?
echo "ERROR: $RET"

typeset -A MYHASH

function testme {
        local -a params=( "$@" )

	local RET=0
	json-to-hash MYHASH <<<"$1" || RET=$?
	typeset -p MYHASH

	return $RET
}

testme '{"a":"b"}'
testme '{"\n":"newline"}'
testme '{"\"":"\""}'
testme "{\"'\":\"'\"}"
testme '{"1\t2\n3":"1\t2\n3"}'
testme '{"\\n":"\\n"}'
testme '{"o\no":"o\no"}'
testme '{"xyz":""}'

# Bash can't do empty keys, such a key produces an error
RET=0
testme '{"":"empty"}' || RET=$?
echo "Error: $RET"

# Error
RET=0
# stderr changes for older jq
testme '{"1":"empty}' 2> >( sed -e 's/^p/jq: p/' 1>&2) || RET=$?
[ $RET -ne 4 ] || RET=5 # older jq
echo "Error: $RET"
