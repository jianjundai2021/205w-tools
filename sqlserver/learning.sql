-- try_convert to try convert char to date or char to number
try_convert(date, '2020-10-08')
try_convert(int, '001008')

sql server view server stat privileges

activity monitor

PAGEIOLATCH_SH 


-- Long run query
SELECT
    des.login_name AS 'UserName',
    deqs.creation_time AS 'QueryStartTime',
    deqs.execution_count AS 'ExecutionCount',
	deqs.total_elapsed_time / 1000 / 60 / 60 AS 'TotalElapsedTimeHour',
    deqs.total_elapsed_time / 1000 AS 'TotalElapsedTimeSec',
    deqs.total_elapsed_time AS 'TotalElapsedTimeMS',
    deqs.last_execution_time AS 'LastExecutionTime',
    dest.text AS 'QueryText'
FROM
    sys.dm_exec_query_stats deqs
JOIN
    sys.dm_exec_requests der ON deqs.plan_handle = der.plan_handle
JOIN
    sys.dm_exec_sessions des ON der.session_id = des.session_id
CROSS APPLY
    sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE
    deqs.creation_time > DATEADD(DAY, -1, GETDATE())
ORDER BY
    deqs.total_elapsed_time DESC;

-- long run query 2 

SELECT TOP 5
    qs.*, 
    total_worker_time/execution_count AS [Avg CPU Time],  
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,   
        ((CASE qs.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE qs.statement_end_offset  
         END - qs.statement_start_offset)/2) + 1) AS statement_text  
FROM sys.dm_exec_query_stats AS qs  
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st  
ORDER BY total_worker_time/execution_count DESC;


