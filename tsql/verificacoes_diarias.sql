/* Anexo 1: Vê queries ativas baseada na sp_who2 */
DECLARE @TEMP_SP_WHO2 TABLE
(
    SPID INT,
    STATUS VARCHAR(200) NULL,
    LOGIN SYSNAME NULL,
    HOSTNAME SYSNAME NULL,
    BLKBY SYSNAME NULL,
    DBNAME SYSNAME NULL,
    COMMAND VARCHAR(200) NULL,
    CPUTIME INT NULL,
    DISKIO INT NULL,
    LASTBATCH VARCHAR(200) NULL,
    PROGRAMNAME VARCHAR(500) NULL,
    SPID2 INT,
	REQUESTID INT NULL
)

--POPULA A TABELA DE PROCESSOS
INSERT  INTO @TEMP_SP_WHO2
EXEC SP_WHO2

SELECT  SPID, STATUS, HOSTNAME, DBNAME, PROGRAMNAME, BLKBY, COMMAND, COUNT(*) QTTHREADS,
	TRY_CAST('<QUERY> '+ CHAR (10)
	+(SELECT TEXT FROM SYS.SYSPROCESSES P OUTER APPLY SYS.DM_EXEC_SQL_TEXT(P.SQL_HANDLE) T WHERE P.SPID = TSW.SPID AND TEXT IS NOT NULL)
	+CHAR(10) + '</QUERY>' AS XML) AS _SQL
FROM    @TEMP_SP_WHO2 TSW
WHERE   1=1
	--AND DBNAME = 'SANTARITACALCADOS_4840'		--ESPECIFICA UM BANCO
	--AND COMMAND != 'AWAITING COMMAND'		--EXCLUI PROCESSOS EM STAND BY
	AND LTRIM(BLKBY) != '.' OR CAST(SPID AS VARCHAR(6)) IN (SELECT BLKBY FROM @TEMP_SP_WHO2)		--PEGA APENAS PROCESSOS BLOQUEADOS OU QUE ESTÃO BLOQUEANDO
GROUP BY SPID, STATUS, HOSTNAME, DBNAME, PROGRAMNAME, BLKBY, COMMAND

/* Anexo 2: Verifica Estado do Always On */ 

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


/* Anexo 3: Vê status de Jobs do SQL Server */

select 
j.name as 'JobName', 
h.message, 
h.run_date, 
h.run_time, 
h.run_duration 
from  
msdb.dbo.sysjobs j INNER JOIN 
msdb.dbo.sysjobhistory h  ON j.job_id = h.job_id 
where 
step_id = 0 and instance_id = (select max(j2.instance_id) from msdb.dbo.sysjobhistory j2 where j2.job_id = j.job_id)
order by j.name

/* Anexo 4: Vê o Log (Com exceção do backup) do SQL Server */

declare @tab table (LogDate datetime, ProcessInfo varchar(50), Text varchar(max))
insert into @tab EXEC sp_readerrorlog

select 
	LogDate,
	ProcessInfo,
	Text
from 
	@tab 
where 
	ProcessInfo != 'Backup' and 
	Text not like 'I/O was resumed%' and 
	Text not like 'I/O is frozen%' and
	Text not like '%misaligned log IOs%' and 
	Text not like '%Login succeeded%' and 
	Text not like 'I/O is frozen%' and
	Text not like '%FlushCache%' and 
	Text not like '%average throughput%' and 
	Text not like '%last target outstanding%' and 
	LogDate > getdate() - 1
order by 
	logdate desc

/* Anexo 5: Vê a última execução de backup completo para cada banco de dados */

SELECT 
	DATABASE_NAME, 
	MAX(MSDB.DBO.BACKUPSET.BACKUP_FINISH_DATE) BACKUP_FINISH_DATE
FROM 
	MSDB.DBO.BACKUPMEDIAFAMILY INNER JOIN 
	MSDB.DBO.BACKUPSET ON MSDB.DBO.BACKUPMEDIAFAMILY.MEDIA_SET_ID = MSDB.DBO.BACKUPSET.MEDIA_SET_ID 
WHERE 
	MSDB.DBO.BACKUPSET.TYPE  = 'D' 
	AND DATABASE_NAME IN (SELECT NAME FROM SYS.DATABASES)
GROUP BY 
	MSDB.DBO.BACKUPSET.DATABASE_NAME
ORDER BY 2 

