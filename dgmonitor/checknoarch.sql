set heading off
set echo off
set termout off
spool checknoarch1.txt
select max(sequence#) from v$archived_log where thread# =1 and resetlogs_id in (select max(resetlogs_id) from v$archived_log); 
spool off
spool checknoarch2.txt
select max(sequence#) from v$archived_log where thread# =2  and resetlogs_id in (select max(resetlogs_id) from v$archived_log);
spool off
exit

