#!/usr/bin/env bash

declare -r DIR=$(cd "$(dirname "$0")" && pwd)
echo '$0'
echo $0
echo $(dirname "$0")
echo "bash_source:"
echo $BASH_SOURCE
source ${DIR}/lib/bsfl.sh
file_exists '/etc/passwd' && echo "yes" || echo "no" 

