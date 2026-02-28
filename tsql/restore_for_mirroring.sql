--executar no jose
/*
	1. Restaurar o arquivo do banco da pasta C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup
	2. Separe os arquivos de backup de log de transação para serem usados
	3. Substitua no script abaixo:
		a. o Nome do banco (dá um replace all no "CORCELLI_1152" pelo nome do banco necessário
		b. o nome dos arquivos .trn pelos corretos EM ORDEM DE CRIAÇÃO 
	4. Execute o script (recomendo rodar aos poucos e não na tora!)
	5. Ative o mirroring
*/

--restaurar o bak:
USE [master]
RESTORE DATABASE [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\CORCELLI_1152_backup_2018_08_29_003007_9208466.bak' --Use o arquivo extraido aqui
WITH  FILE = 1, 
MOVE N'CORCELLI_1152' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CORCELLI_1152.mdf',  
MOVE N'CORCELLI_1152_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CORCELLI_1152_log.ldf', NORECOVERY,  NOUNLOAD,  STATS = 5
GO

--restaurar os logs
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824070026.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824080015.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824090055.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824100256.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824110212.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824140200.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180824150140.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\Transactionlogs\CORCELLI_1152_20180817160025.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [CORCELLI_1152] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\TransactionLogs\CORCELLI_1152_20180817160025.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10