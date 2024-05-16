#!/bin/bash
#export INFO='\033[0;34mINFO: \033[0m'
source ./lib/autodglib.sh

export ORACLE_HOME=`./getcfg.sh oracle_home_pr`
sed  "s#TMPPATH#$TMPDIR#g" getdbinfo.sql.model >getdbinfo.sql
#get database info and save to TMPDIR
$ORACLE_HOME/bin/sqlplus -s "/ as sysdba" @getdbinfo.sql >/dev/null 2>&1

format_dbinfo

if grep "ORACLE" $TMPDIR/dbname.txt; then
  #oracle not started yet.
  msg_error "Primary ERROR: Oracle is not started,start oracle first"
  exit
else
  msg_ok "Get database info done."
fi
