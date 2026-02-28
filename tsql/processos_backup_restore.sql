SELECT 
	session_id as SPID, 
	command, 
	a.text AS Query, 
	start_time, 
	DB_NAME(database_id) as [Database],
	USER_NAME(user_id) as [User],
	percent_complete, 
	dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time 
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP LOG', 'BACKUP DATABASE','RESTORE DATABASE', 'RESTORE LOG')

