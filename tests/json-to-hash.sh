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
set +x

typeset -A MYHASH

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

function testme {
        local -a params=( "$@" )
        echo "testing $(showlist params)"

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
