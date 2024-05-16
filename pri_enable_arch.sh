#!/bin/bash

source ./lib/autodglib.sh
#source $HOME/.bash_profile
export ORACLE_HOME=`./getcfg.sh oracle_home_pr`
export DB_NAME=`cat $TMPDIR/dbname.txt`
#export DG_UNIQUE_NAME=`cat dbname.txt`dg
export DG_UNIQUE_NAME=`./getcfg.sh dg_unique_name`
export ORACLE_SID=`./getcfg.sh oracle_sid`
export LOG_FILE='/home/oracle/autodg/tmp/autodg.log'
export INFO='\033[0;34mINFO: \033[0m'


msg_info "primary  lsnrctl status"
$ORACLE_HOME/bin/lsnrctl status >> ${LOG_FILE}
msg_info "primary lsnrctl start"
$ORACLE_HOME/bin/lsnrctl start >> ${LOG_FILE}
msg_info "primary tnsping $DB_NAME "
$ORACLE_HOME/bin/tnsping $DB_NAME >> ${LOG_FILE}
msg_info "primary tnsping $DG_UNIQUE_NAME "
$ORACLE_HOME/bin/tnsping $DG_UNIQUE_NAME >> ${LOG_FILE}

msg_info "primary enable sending archivelog to standby,check pri_modify.model for details."
msg_info "Primary register to listener, check archive_dest_status,..."
$ORACLE_HOME/bin/sqlplus -s / as sysdba<<EOF >>$LOG_FILE
col error for a30
col status for a10
@${TMPDIR}/pri_modify.sql
alter system register;
select dest_id,status,error from v\$archive_dest_status where dest_id <6;
alter system switch logfile;
alter system switch logfile;
exit;
EOF
