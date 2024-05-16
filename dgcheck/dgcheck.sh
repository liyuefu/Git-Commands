#!/bin/bash
CHECK_HOME=/home/oracle/autodg/tmp
source /home/oracle/.bash_profile
if [ -z $1 ];then
	echo "USAGE:hostname"
	exit 0
fi
standby=$1


export ORACLE_DG_SID=`cd ../dgcreate;./getcfg.sh oracle_dg_sid`
echo "oracle sid : $ORACLE_DG_SID"
#check pri
$CHECK_HOME/pri.sh

echo $standby
#check dg
ssh oracle@$standby -t "if [ ! -d /home/oracle/autodg/tmp ];then mkdir -p $CHECK_HOME; fi"
scp $CHECK_HOME/dg.sh  oracle@$standby:$CHECK_HOME
ssh oracle@$standby -t "cd $CHECK_HOME;chmod +x *.sh;./dg.sh"
scp oracle@$standby:$CHECK_HOME/dg.out $CHECK_HOME
scp oracle@$standby:$ORACLE_BASE/diag/rdbms/${ORACLE_DG_SID}dg/$ORACLE_DG_SID/trace/alert* $CHECK_HOME

rm $CHECK_HOME/pri.sql
