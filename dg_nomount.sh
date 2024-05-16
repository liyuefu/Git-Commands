#!/bin/bash
source ./lib/autodglib.sh
export ORACLE_BASE=`./getcfg.sh oracle_base_dg`
export ORACLE_HOME=`./getcfg.sh oracle_home_dg`
export ORACLE_SID=`./getcfg.sh oracle_dg_sid`
export STAGEDG=`./getcfg.sh stagedg`
export EXECUTE_DATE=`date +%Y%m%d`
export DG_UNIQUE_NAME=`./getcfg.sh dg_unique_name`
TODAY=`date +%Y%m%d`
export LOG_FILE="/home/oracle/autodg/tmp/autodg_dg.log"

msg_info "Standby stop listener_duplicate"
$ORACLE_HOME/bin/lsnrctl stop listener_duplicate>> $LOG_FILE
msg_info "Standby start listener_duplicate"
$ORACLE_HOME/bin/lsnrctl start listener_duplicate>> $LOG_FILE
msg_info "Standby status listener_duplicate"
$ORACLE_HOME/bin/lsnrctl status listener_duplicate>> $LOG_FILE

#delete spfile if it exists
if [ -f $ORACLE_HOME/dbs/spfile"$ORACLE_DG_SID".ora ];then
  rm $ORACLE_HOME/dbs/spfile"$ORACLE_DG_SID".ora
fi

#startup database nomount
msg_info "standby :shutdown abort "
msg_info "standby :statup nomount"
$ORACLE_HOME/bin/sqlplus -s / as sysdba <<EOF
shutdown abort;
startup nomount;
EOF

