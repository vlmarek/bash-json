#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

LIST=( $( seq 17 -3 1 ) )

json-list-to-json LIST

LIST=()
json-list-to-json LIST

LIST=('' $'\n' $'\t' '')
json-list-to-json LIST
