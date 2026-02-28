USE master
GO


ALTER DATABASE DES_LITTLE SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE
GO
-- altera o nome virtual do arquivo da base
ALTER DATABASE DES_LITTLE 
MODIFY FILE (NAME = DES_LITTLE, NEWNAME = DES_LITTLE_COPY, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DES_LITTLE_COPY.mdf')
GO

-- altera o nome virtual do arquivo de log da base
ALTER DATABASE DES_LITTLE 
MODIFY FILE (NAME = DES_LITTLE_log, NEWNAME = DES_LITTLE_COPY_log, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DES_LITTLE_COPY_log.ldf')
GO

-- desliga a base
alter database DES_LITTLE set offline
GO

/*

Agora tem que renomear o arquivo na mão pelo SO

*/

--religa a base
alter database DES_LITTLE set Online
GO

ALTER DATABASE DES_LITTLE SET multi_user 

ALTER DATABASE DES_LITTLE
Modify Name = DES_LITTLE_COPY ;
GO