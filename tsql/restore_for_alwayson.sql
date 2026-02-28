--executar no kolinda
/*
	1. Restaurar o arquivo do banco da pasta E:\MSSQL\Backup_Cirao
	2. Separe os arquivos de backup de log de transação para serem usados
	3. Substitua no script abaixo:
		a. o Nome do banco (dá um replace all no "ESTRELALOJAS_3139" pelo nome do banco necessário
		b. o nome dos arquivos .trn pelos corretos EM ORDEM DE CRIAÇÃO 
	4. Execute o script (recomendo rodar aos poucos e não na tora!)
	5. Inclua o banco no grupo de disponibilidade (sem sincronizacao inicial) pelo Cirao
	6. Pelo Kolinda, inicie a sincronizacao
*/

USE [master]
--restaurar o bak:
RESTORE DATABASE [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\ESTRELALOJAS_3139_backup_20191031.bak' --Use o arquivo extraido aqui
WITH  FILE = 1, 
MOVE N'ESTRELALOJAS_3139' TO N'D:\MSSQL\Data\ESTRELALOJAS_3139.mdf',  
MOVE N'ESTRELALOJAS_3139_log' TO N'D:\MSSQL\Data\ESTRELALOJAS_3139_log.ldf', NORECOVERY,  NOUNLOAD,  STATS = 5
GO


--restaurar os logs
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20191031070114.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20191031100008.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20191031130014.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10

RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20191002160003.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20181119110010.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20181119120010.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\TransactionLogs\ESTRELALOJAS_3139_20181119140011.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\Transactionlogs\ESTRELALOJAS_3139_20181119150010.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\Transactionlogs\ESTRELALOJAS_3139_20181119160015.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
RESTORE LOG [ESTRELALOJAS_3139] FROM  DISK = N'E:\MSSQL\Backup_Cirao\Transactionlogs\ESTRELALOJAS_3139_20181018160039.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10