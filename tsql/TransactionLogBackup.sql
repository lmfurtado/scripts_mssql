DECLARE @TEXTO NVARCHAR(max);
DECLARE PONTEIRO CURSOR 
FOR 
	select concat(' BACKUP LOG ',name,' TO DISK = ''C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\', name ,'.trn'' ',
		' MIRROR TO DISK = ''Z:\TransactionLogs\', name ,'.trn'' WITH FORMAT ')
	from sys.databases 
	where database_id > 4 and recovery_model = 1 and state = 0
	order by name			
OPEN PONTEIRO 
FETCH PONTEIRO INTO @TEXTO
WHILE (@@FETCH_STATUS = 0)
BEGIN
	EXECUTE sp_executesql  @TEXTO; 
	FETCH NEXT FROM PONTEIRO INTO @TEXTO;		
END
CLOSE PONTEIRO;
DEALLOCATE PONTEIRO;	
