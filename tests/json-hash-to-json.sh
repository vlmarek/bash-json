#!/bin/bash

source ../bash-json
set -eEuo pipefail
JSON_SORT_KEYS=1
JSON_COMPACT=

typeset -A HASH

newline=$'\n'
HASH[1]=1
HASH[1 2 3]="1	2	3"
HASH[xyz]=""
HASH[o${newline}o]=$'o\no'
HASH[\\n]='\n'
HASH[$'\n']='newline'
HASH["'"]="'"
HASH['"']='"'

json-hash-to-json HASH

JSON_COMPACT=

json-hash-to-json HASH
