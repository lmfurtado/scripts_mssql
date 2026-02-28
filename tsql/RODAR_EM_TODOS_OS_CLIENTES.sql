use master;
DECLARE @TEXTO NVARCHAR(max);
DECLARE PONTEIRO CURSOR 
FOR 
	select concat('if exists (select * from [', name, '].dbo.sysobjects where xtype=''u'' and name = ''pagamento'')begin try use [', name, 
		'] 
print db_name();

select db_name(), * from cliente where nome = ''GABRIELI MONIQUE ARAUJO IRRTHUM''




		'-- TROQUE O CONTEUDO DESSA LINHA PELO SELECT. É BOM MANTER O DB_NAME() NO SELECT PARA FACILITAR declare ponteiro cur
		+' END TRY BEGIN CATCH END CATCH; ' 
		) 
	from sys.databases where state_desc = 'ONLINE'  and database_id > 4
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