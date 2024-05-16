#!/bin/sh
source /home/oracle/.bash_profile
sqlplus -s / as sysdba @check_max_applied.sql
