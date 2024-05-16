col name for a10
col log_mode for a13
col open_mode for a20
col database_role for a22
col switchover_status for a15
col last_apply_date for a22
set linesize 190
set echo off  feedback off
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
select name,database_role,open_mode,log_mode,switchover_status,to_char(scn_to_timestamp(current_scn),'yyyy-mm-dd hh24:mi:ss') as
last_apply_date,sysdate as check_time, to_number(cast(systimestamp as date) - cast(scn_to_timestamp(current_scn) as date))*24*3600
as "lag_seconds" from v$database;
exit;