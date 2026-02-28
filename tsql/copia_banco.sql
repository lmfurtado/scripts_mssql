drop proc copia_banco_lucas
go

use master
go
create procedure Copia_Banco_Lucas(@sourcedatabase varchar(max), @destinationdatabase varchar(max)) as

if exists (select * from sys.databases where name = @destinationdatabase)
	 raiserror ('Banco destino já existe! use "select * from sys.databases" para ver os bancos existentes',16,1);
else
begin
	--variaveis de info sobre o backup
	declare @backuppath varchar(max) = concat(N'F:\SQLSERVER\backup\' , @sourcedatabase,'_backup_copia.bak')
	declare @backupname varchar(max) = @sourcedatabase+'-full database backup'
	
	--inicio variaveis com nome dos arquivos originais
	declare @sourcefiledbname nvarchar(max) = '';
	declare @sourcefiledblogname nvarchar(max) = '';
	declare @tsqlnomearquivo nvarchar(max) = 'select @sourcefiledbname = name from ' + @sourcedatabase + '.sys.database_files where type = 0'
	declare @tsqlnomelog nvarchar(max) = 'select @sourcefiledbname = name from ' + @sourcedatabase + '.sys.database_files where type = 1'
	declare @parmdefnomearquivo nvarchar(max) = '@sourcefiledbname varchar(max) output'

	execute sp_executesql  @tsqlnomearquivo, @parmdefnomearquivo, @sourcefiledbname output
	execute sp_executesql  @tsqlnomelog, @parmdefnomearquivo, @sourcefiledblogname output
	--fim variaveis com nome dos arquivos originais

	--inicio variaveis com nome dos arquivos destino
	declare @destinationdatabaselogfile varchar(50) = @destinationdatabase + '_log'
	declare @filedb varchar(max) = N'F:\SQLSERVER\DATA\' + @destinationdatabase + '.mdf'
	declare @filelog varchar(max) = N'F:\SQLSERVER\DATA\' + @destinationdatabaselogfile + '.ldf'
	--fim variaveis com nome dos arquivos destino

	--faz backup
	backup database @sourcedatabase to  disk = @backuppath with format, name = @backupname, skip, norewind, nounload,  stats = 10

	--restaura
	restore database @destinationdatabase from  disk = @backuppath with  file = 1,  
	move @sourcefiledbname to @filedb,  
	move @sourcefiledblogname to @filelog,  nounload,  stats = 5

	--renomeia os arquivos
	begin try
		declare @comando nvarchar(max) = N'alter database '+@destinationdatabase+' modify file (name = '+@sourcedatabase+', newname = '+@destinationdatabase+')';
		exec sp_executesql @comando;
		set @comando = N'alter database '+@destinationdatabase+' modify file (name = '+@sourcedatabase+'_log, newname = '+@destinationdatabase+'_log)';
		exec sp_executesql @comando;
	end try
	begin catch
		print 'Não foi possível renomear os arquivos lógicos'
		print @comando
		print error_message () 
	end catch
end

go
