select 
	db_name(database_id) database_name 
	,(select name from sys.availability_groups ag where hdrs.group_id = ag.group_id) [group]
	,convert(varchar(20),last_commit_time,22) last_commit_time
	,cast(cast(((datediff(s,last_commit_time,getdate()))/3600) as varchar) + ' hour(s), ' 
		+ cast((datediff(s,last_commit_time,getdate())%3600)/60 as varchar) + ' min, '
		+ cast((datediff(s,last_commit_time,getdate())%60) as varchar) + ' sec' as varchar(30)) time_behind_primary
	,log_send_queue_size as send_queue
	--,log_send_rate as send_rate
	,redo_queue_size as redo_queue
	--,nullif(redo_rate,0) redo_rate
	,(redo_queue_size/nullif(redo_rate,0)) [estim_rec(s)]
	,synchronization_state_desc sync_state
from sys.dm_hadr_database_replica_states hdrs
where last_redone_time is not null
order by database_name