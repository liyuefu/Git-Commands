#!/bin/bash
#添加database和instance.修改数据库为standby. 
#rac->rac后, 把db服务加到grid.dg搭建完成后,使用本地的spfile启动的.
#然后执行这个脚本. 注意先设置如下几个参数
#SPFILE of a DB instance will be created within 'DB_UNKNOWN' directory on ASM storage (Doc ID 743073.1)
#在建立spfile到asm前,要先mount或者open数据库.
# crsctl delete serverpool ora.testctpdg  如果报错 PRCS-1007 : Server pool testctpdg already exists
#如果dg的执行apply的节点故障. 要手动启动另外节点apply.可以继续.


export NODE1='rac1' #节点1的主机名
export NODE2='rac2' #节点2的主机名
export ORACLE_DG_SID1='ctp1' #节点1上 ORACLE_SID的值
export ORACLE_DG_SID2='ctp2'
export PFILE1="'/tmp/a.ora'"
export PFILE2="/tmp/a.ora"

export DGPATH=`./getcfg.sh dgpath`
export ORACLE_DG_HOME=`./getcfg.sh oracle_home_dg`
export DG_UNIQUE_NAME=`./getcfg.sh dg_unique_name`
export SPFILE1="'$DGPATH/$DG_UNIQUE_NAME/spfile${DG_UNIQUE_NAME}.ora'" # for create spfile  with ''.
export SPFILE2="$DGPATH/$DG_UNIQUE_NAME//spfile${DG_UNIQUE_NAME}.ora"   # for srvctl cmd, remove  ''.


#add database , instance to cluster
srvctl add database -d $DG_UNIQUE_NAME -o $ORACLE_DG_HOME
srvctl add instance -d $DG_UNIQUE_NAME -i $ORACLE_DG_SID1 -n $NODE1
srvctl add instance -d $DG_UNIQUE_NAME -i $ORACLE_DG_SID2 -n $NODE2
srvctl modify database -d $DG_UNIQUE_NAME -r physical_standby -p  $SPFILE2
srvctl config database -d $DG_UNIQUE_NAME

mv $ORACLE_DG_HOME/dbs/spfile${ORACLE_DG_SID1}.ora $ORACLE_DG_HOME/dbs/spfile${ORACLE_DG_SID1}.ora.old 2>/dev/null

