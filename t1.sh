#!usr/bin/env bash

source ./lib/autodglib.sh

#makeup_file_convert ../test/tmp/pri_convert.txt ../test/tmp/oneline.txt
#makeup_file_convert '../test/tmp/dbpath.txt' '/u03/oradata/orcldg' '../test/tmp/pri_convert.txt' '../test/tmp/dg_convert.txt'
#makeup_file_convert './tmp/dbpath.txt' '/u03/oradata/orcldg' './tmp/pri_convert.txt' './tmp/dg_convert.txt'
makeup_convert_oneline '../tmp/nofile-pri_convert.txt' '../tmp/pri_convert_oneline.txt'

#this test
