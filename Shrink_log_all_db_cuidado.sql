DECLARE @TEXTO NVARCHAR(max);
DECLARE PONTEIRO CURSOR 
FOR 
	SELECT 
		  'use master alter database ['+ d.name +'] set recovery simple'
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) 	
		+ 'USE [' + d.name + N']' + CHAR(13) + CHAR(10) 
		+ 'DBCC SHRINKFILE (N''' + mf.name + N''' , 0, TRUNCATEONLY)' 
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) 
		+ 'use master alter database ['+ d.name +'] set recovery full'
	FROM 
			 sys.master_files mf 
		JOIN sys.databases d 
			ON mf.database_id = d.database_id 
	WHERE d.database_id > 4 AND mf.type_desc = 'LOG' and d.recovery_model_desc = 'FULL'
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

/*
use master 
alter database BANCO set recovery simple

USE BANCO 
DBCC SHRINKFILE ('BANCO_LOG', 0, TRUNCATEONLY)

use master 
alter database BANCO set recovery full
*/