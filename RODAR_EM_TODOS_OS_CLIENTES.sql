use master;
DECLARE @TEXTO NVARCHAR(max);
DECLARE PONTEIRO CURSOR 
FOR 
	select concat('IF EXISTS (SELECT * FROM [', name, '].dbo.SYSOBJECTS WHERE XTYPE=''U'' and name = ''ITEMPED'')BEGIN TRY use [', name, 
		'] 
		print db_name()
begin try
create user [desenvolvimento] for login [desenvolvimento]
end try 
begin catch 
	PRINT ''Não foi possível adicionar usuario desenvolvimento'';
end catch
;
exec sp_addrolemember ''db_datareader'', ''desenvolvimento''
;

begin try
create user [devProd] for login [devProd]
end try 
begin catch 
	PRINT ''Não foi possível adicionar usuario devProd'';
end catch
;
exec sp_addrolemember ''db_datareader''	, ''devProd''
exec sp_addrolemember ''db_datawriter'', ''devProd''
exec sp_addrolemember ''db_ddladmin'', ''devProd''
grant execute to [devProd]
;	'
		+' END TRY BEGIN CATCH END CATCH; ' 
		) 
	from sys.databases 
	where 
		state_desc = 'ONLINE' 
		AND DATABASE_ID > 4
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