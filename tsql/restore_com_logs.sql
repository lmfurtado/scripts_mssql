--executar no jose
/*
	1. Restaurar o arquivo do banco da pasta D:\SQLSERVER\MSSQL11.MSSQLSERVER\Backup
	2. Se possível, execute o job BackupTransactionLog no Vladimir para ele passar qualquer nova atualização para um novo arquivo de log
	3. Separe os arquivos de backup de log de transação para serem usados
	4. Substitua no script abaixo:
		a. o Nome do banco (dá um replace all no "DIANA_604" pelo nome do banco necessário
		b. o nome dos arquivos .trn pelos corretos EM ORDEM DE CRIAÇÃO 
	5. Execute o script (recomendo rodar aos poucos e não na tora!)
	6. Execute o ADDROLEMEMBER.sql pra liberar os usuários (só pra garantir)
	Loja liberada!
*/

--restaurar o bak:

USE [master]
RESTORE DATABASE [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\Share\DIANA_604_backup_2018_05_18_010007_9026699.bak' --Use o arquivo extraido aqui
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\DIANA_604_RollbackUndo_2018-05-18_10-42-29.bak' --arquivo só pra manter o banco em stand by. deve ser usado no restore de log tbm
,  NOUNLOAD,  STATS = 5
GO


--restaurar os logs

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518070011.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518080010.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518090029.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518100036.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518110033.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518120023.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518130036.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\TransactionLogs\DIANA_604_20180518140027.trn' 
WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\ROLLBACK_UNDO_DIANA_604.BAK',  NOUNLOAD,  STATS = 10
GO

RESTORE LOG [DIANA_604]
GO