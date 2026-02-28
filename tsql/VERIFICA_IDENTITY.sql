IF OBJECT_ID ('temporaria', 'u') IS NOT NULL
	DROP table temporaria;
GO

create table temporaria(x varchar(100)) ;
go

IF OBJECT_ID ('VERIFICA_IDENTITY', 'P') IS NOT NULL
	DROP PROCEDURE VERIFICA_IDENTITY;
GO

CREATE PROCEDURE VERIFICA_IDENTITY AS
	DECLARE @TEXTO NVARCHAR(200);
BEGIN
	DECLARE PONTEIRO CURSOR 
	FOR 
		SELECT 
			CONCAT(' SELECT concat(''', Name, ''', '' - '', cast(IDENT_CURRENT(''', Name, ''') as varchar(10))) ') AS total
		FROM 
			sysobjects so
		WHERE 
			so.xtype = 'U' 
			and
			(SELECT OBJECTPROPERTY(OBJECT_ID(Name),'TableHasIdentity')) > 0
			
	OPEN PONTEIRO 
	FETCH PONTEIRO INTO @TEXTO
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--EXECUTE sp_executesql  @TEXTO; 
		insert temporaria EXEC sp_executesql  @TEXTO;
		FETCH NEXT FROM PONTEIRO INTO @TEXTO;		
	END
	CLOSE PONTEIRO;
	DEALLOCATE PONTEIRO;	

	select * from temporaria --order by x
END

GO


exec VERIFICA_IDENTITY


