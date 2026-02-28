
begin try
drop user [devProd]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario devProd';
end catch
go

begin try
drop user [suporte1]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario suporte1';
end catch
go

begin try
drop user [suporte2]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario suporte2';
end catch
go

begin try
drop user [implantacao]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario implantacao';
end catch
go

begin try
drop user [use]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario use';
end catch
go

begin try
drop user [conversao]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario conversao';
end catch
go

begin try
drop user [finconver]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario conversao';
end catch
go

begin try
drop user [atualizacao]
end try 
begin catch 
	PRINT 'Não foi possível remover usuario atualizacao';
end catch
go

begin try
create user [desenvolvimento] for login [desenvolvimento]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario desenvolvimento';
end catch
go
exec sp_addrolemember 'db_datareader', 'desenvolvimento'
go

begin try
create user [devProd] for login [devProd]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario devProd';
end catch
go
exec sp_addrolemember 'db_datareader', 'devProd'
exec sp_addrolemember 'db_datawriter', 'devProd'
exec sp_addrolemember 'db_ddladmin', 'devProd'
grant execute to [devProd]
go

begin try
create user [suporte2] for login [suporte2]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario suporte2';
end catch
go
exec sp_addrolemember 'db_datareader', 'suporte2'


begin try
create user [suporte3] for login [suporte3]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario suporte3';
end catch
go
exec sp_addrolemember 'db_datareader', 'suporte3'
exec sp_addrolemember 'db_datawriter', 'suporte3'
exec sp_addrolemember 'db_ddladmin', 'suporte3'
grant execute to [suporte3]


begin try
create user [implantacao] for login [implantacao]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario implantacao';
end catch
go
exec sp_addrolemember 'db_datareader', 'implantacao'
exec sp_addrolemember 'db_datawriter', 'implantacao'
exec sp_addrolemember 'db_ddladmin', 'implantacao'
grant execute to [implantacao]


begin try
create user [implantacao2] for login [implantacao2]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario implantacao2';
end catch
go
exec sp_addrolemember 'db_datareader', 'implantacao2'


begin try
create user [use] for login [use]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario use';
end catch
go
exec sp_addrolemember 'db_datareader', 'use'
exec sp_addrolemember 'db_datawriter', 'use'
exec sp_addrolemember 'db_ddladmin', 'use'
exec sp_addrolemember 'db_backupoperator', 'use';
grant execute to [use]


begin try
create user [conversao] for login [conversao]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario conversao';
end catch
go
exec sp_addrolemember 'db_datareader', 'conversao'
exec sp_addrolemember 'db_datawriter', 'conversao'
exec sp_addrolemember 'db_ddladmin', 'conversao'
grant execute to [conversao]


begin try
create user [finconver] for login [finconver]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario finconver';
end catch
go
exec sp_addrolemember 'db_datareader', 'finconver'
exec sp_addrolemember 'db_datawriter', 'finconver'
exec sp_addrolemember 'db_ddladmin', 'finconver'
exec sp_addrolemember 'db_backupoperator', 'finconver';
grant execute to [finconver]

begin try
create user [atualizacao] for login [atualizacao]
end try 
begin catch 
	PRINT 'Não foi possível adicionar usuario atualizacao';
end catch
go
exec sp_addrolemember 'db_datareader', 'atualizacao'
exec sp_addrolemember 'db_datawriter', 'atualizacao'
exec sp_addrolemember 'db_ddladmin', 'atualizacao'
grant execute to [atualizacao]