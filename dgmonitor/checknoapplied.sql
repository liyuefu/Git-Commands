set heading off
set echo off
set termout off
spool checkapplystatus.txt
select open_mode from v$database;
spool off
spool checknoapplied.txt
select count(*) from v$archived_log where applied ='NO';

spool off
exit
