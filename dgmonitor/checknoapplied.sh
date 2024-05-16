#!/bin/sh
source /home/oracle/.bash_profile
sqlplus -s / as sysdba @checknoapplied.sql
