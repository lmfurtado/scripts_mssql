DECLARE @TEXTO NVARCHAR(max);
DECLARE PONTEIRO CURSOR 
FOR 
	SELECT 
		  'USE [' + d.name + N'] CHECKPOINT' + CHAR(13) + CHAR(10) 
		  -- se precisar, force uma transação insert/update aqui
		+ case when recovery_model_desc = 'FULL' then '
				create table testtran(test int)
				insert testtran values (1)
				drop table testtran; CHECKPOINT' + CHAR(13) + CHAR(10) 
			+ 'BACKUP LOG [' + d.name + N'] TO DISK = N''' + d.name + '_' + REPLACE(REPLACE(REPLACE(convert(varchar, getdate(), 120), ':', ''), '-', ''), ' ', '') + '.trn'' ' + CHAR(13) + CHAR(10) 
			+ 'WITH NOFORMAT, NOINIT,  NAME = ''N' + d.name + N'-Full Log Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 5 ' + CHAR(13) + CHAR(10) else '' end
		+ 'DBCC SHRINKFILE (N''' + mf.name + N''' , 0, TRUNCATEONLY)' 
	FROM 
			 sys.master_files mf 
		JOIN sys.databases d 
			ON mf.database_id = d.database_id 
	WHERE mf.type_desc = 'LOG'  and d.state = 0 and d.name != 'master' 
	order by d.name;
			
OPEN PONTEIRO 
FETCH PONTEIRO INTO @TEXTO
WHILE (@@FETCH_STATUS = 0)
BEGIN
	EXECUTE sp_executesql  @TEXTO; 
	FETCH NEXT FROM PONTEIRO INTO @TEXTO;		
END
CLOSE PONTEIRO;
DEALLOCATE PONTEIRO;	
