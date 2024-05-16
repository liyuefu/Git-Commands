#!/bin/bash
#rac->rac后, 把db服务加到grid.dg搭建完成后,使用本地的spfile启动的.
#先手动建/tmp/a.ora, create pfile='/tmp/a.ora' from spfile.
##然后关闭数据库(只有一个实例在运行,直接shutdown immediate)
#然后执行修改cluster=true,修改remote_listener参数.
#用新的pfile启动,并新建spfile
#SPFILE of a DB instance will be created within 'DB_UNKNOWN' directory on ASM storage (Doc ID 743073.1)
#在建立spfile到asm前,要先mount或者open数据库.
# crsctl delete serverpool ora.testctpdg  如果报错 PRCS-1007 : Server pool testctpdg already exists
#如果dg的执行apply的节点故障. 要手动启动另外节点apply.可以继续.

export DG_UNIQUE_NAME=`./getcfg.sh dg_unique_name`
export DGPATH=`./getcfg.sh dgpath`
export PFILE1="'/tmp/a.ora'"
export PFILE2="/tmp/a.ora"
export SPFILE1="'$DGPATH/$DG_UNIQUE_NAME/spfile${DG_UNIQUE_NAME}.ora'" # for create spfile  with ''.
export SPFILE2="$DGPATH/$DG_UNIQUE_NAME/spfile${DG_UNIQUE_NAME}.ora"   # for srvctl cmd, remove  ''.
export SCAN_VIP="192.168.56.205"

sqlplus / as sysdba <<EOF
create pfile=$PFILE1 from spfile;
shutdown immediate;
exit;
EOF

sed -i s/cluster_database=false/cluster_database=true/Ig $PFILE2
sed -i s/remote_listener=\'\'/remote_listener=\'$SCAN_VIP:1521\'/Ig $PFILE2


sqlplus  / as sysdba <<EOF
startup pfile=$PFILE1;
create spfile=$SPFILE1 from pfile=$PFILE1;
shutdown immediate;
EOF
