#!/bin/bash
source ./lib/autodglib.sh
export ORACLE_BASE=`./getcfg.sh oracle_base_dg`
export ORACLE_HOME=`./getcfg.sh oracle_home_dg`
export ORACLE_SID=`./getcfg.sh oracle_dg_sid`
export STAGEDG=`./getcfg.sh stagedg`
export EXECUTE_DATE=`date +%Y%m%d`
export EXECUTE_DATE=`date +'%Y-%m-%d_%H-%M-%S'`
export DB_NAME=`cat dbname.txt`
export DG_UNIQUE_NAME=`./getcfg.sh dg_unique_name`
#export DG_UNIQUE_NAME="$DB_NAME"dg
export LOG_FILE='/home/oracle/autodg/tmp/autodg_dg.log'

#move configuration file
msg_info "Standby move tnsname.ora, init, orapw,restore.rcv from $STAGEDG to network/admin or dbs"
if [ -f $ORACLE_HOME/network/admin/tnsnames.ora ];then
  mv $ORACLE_HOME/network/admin/tnsnames.ora $ORACLE_HOME/network/admin/tnsnames.ora.$EXECUTE_DATE
fi
if [ -f $ORACLE_HOME/network/admin/listener.ora ];then
  mv $ORACLE_HOME/network/admin/listener.ora $ORACLE_HOME/network/admin/listener.ora.$EXECUTE_DATE
fi
if [ -f  $STAGEDG/tnsnames.ora ];then
  mv $STAGEDG/tnsnames.ora $ORACLE_HOME/network/admin/
else
  msg_info "Standby ERROR : check tnsnames.ora file in $STAGEDG, or copy from primary db"
  exit;
fi
if [ -f  $STAGEDG/init"$ORACLE_SID".ora ];then
  mv $STAGEDG/init"$ORACLE_SID".ora $ORACLE_HOME/dbs/
else
  msg_info "Standby ERROR : check init$ORACLE_SID.ora file in $STAGEDG, or copy from primary db"
  exit;
fi

if [ -f $STAGEDG/orapw$ORACLE_SID ];then
  mv $STAGEDG/orapw$ORACLE_SID $ORACLE_HOME/dbs/
else
  msg_info "Standby ERROR : check orapw$ORACLE_SID file in $STAGEDG, or copy from primary db"
  exit;
fi

mv $STAGEDG/restore.rcv /home/oracle/autodg/tmp

#start lsnrctl
msg_info "Standby  lsnrctl start"
$ORACLE_HOME/bin/lsnrctl start listener_duplicate>>$LOG_FILE
msg_info "Standby  lsnrctl status listener_duplicate"
$ORACLE_HOME/bin/lsnrctl status listener_duplicate>> $LOG_FILE

msg_info "Standby  tnsping  $DB_NAME" 
$ORACLE_HOME/bin/tnsping $DB_NAME >>$LOG_FILE
msg_info "Standby  tnsping  $DG_UNIQUE_NAME"
$ORACLE_HOME/bin/tnsping $DG_UNIQUE_NAME >>$LOG_FILE

#startup database nomount
msg_info "Standby  startup nomount"
$ORACLE_HOME/bin/sqlplus -s / as sysdba <<EOF
shutdown abort;
startup nomount;
EOF

#create spfile from pfile;
#restore controlfile,restore, recover database
msg_info "Standby  start rman restore"
$ORACLE_HOME/bin/rman  @$TMPDIR/restore.rcv >> $LOG_FILE


msg_info "Starndby alter database recover managed standby database disconnect from session..."
$ORACLE_HOME/bin/sqlplus -s / as sysdba <<EOF
alter database recover managed standby database disconnect from session;
EOF
