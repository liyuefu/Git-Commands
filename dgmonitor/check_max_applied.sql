set heading off
set echo off
set termout off
spool check_max_applied1.txt
select max(sequence#) from v$archived_log where thread# = 1 and applied in ('YES','IN-MEMORY') and resetlogs_id in (select max(resetlogs_id) from v$archived_log);
spool off
spool check_max_applied2.txt
select max(sequence#) from v$archived_log where thread# = 2 and applied in ('YES','IN-MEMORY') and resetlogs_id in (select max(resetlogs_id) from v$archived_log);
spool off
exit
