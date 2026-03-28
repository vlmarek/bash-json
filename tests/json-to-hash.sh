#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

set -x
JSON=$( cat <<'EOT'
{"\n":"newline","\"":"\"","'":"'","1":"1","1 2 3":"1\t2\t3","\\n":"\\n","o\no":"o\no","xyz":""}
EOT
)

RET=0
json-to-hash MYHASH <<<"$JSON" || RET=$?
echo "ERROR: $RET"
set +x

typeset -A MYHASH

function testme {
        local -a params=( "$@" )
        echo "testing $(typeset -p params)"

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
testme '{"1":"empty}' || RET=$?
echo "Error: $RET"
