--APAGA A PROCEDURE SE NECESSÁRIO
if (object_id('MUDA_TIPO_CAMPO') is not null)
	DROP PROCEDURE MUDA_TIPO_CAMPO;
GO

/*
	CRIA A PROCEDURE QUE VAI ALTERAR O TIPO DO CAMPO
		CRIA UMA COLUNA TEMPORARIA COM O TIPO NOVO;
		PASSA OS DADOS CONVERTIDOS DA COLUNA ANTIGA PARA ESSA COLUNA NOVA.
		APAGA A COLUNA ANTIGA
		RECRIA A COLUNA INICIAL COM O MESMO NOME E O TIPO NOVO;
		PASSA OS DADOS DA COLUNA TEMPORARIA PARA ESSA COLUNA RECEM CRIADA.
		APAGA A COLUNA TEMPORÁRIA
*/
CREATE PROCEDURE MUDA_TIPO_CAMPO(@CAMPO VARCHAR(50), @TABELA VARCHAR(50), @TIPO VARCHAR (50)) AS
BEGIN
	PRINT 'Alterando campo ' + @CAMPO + ' na tabela ' + @TABELA + '...';
	BEGIN TRY
		BEGIN TRAN;
		DECLARE @TEXTO NVARCHAR(1000);

		SET @TEXTO = CONCAT('ALTER TABLE ',@TABELA,' ADD ',@CAMPO,'_TEMP ',@TIPO); --cria coluna temporária para transição
		EXEC SP_EXECUTESQL @TEXTO;
		SET @TEXTO = CONCAT('UPDATE ',@TABELA,' SET ',@CAMPO,'_TEMP = CAST(',@CAMPO,' AS ',@TIPO,') WHERE ', @CAMPO, ' IS NOT NULL; ');--passa os dados da coluna antiga para a coluna nova já no tipo novo
		EXEC SP_EXECUTESQL @TEXTO;
		SET @TEXTO = CONCAT('ALTER TABLE ',@TABELA,' DROP COLUMN ',@CAMPO,'; ');--apaga a coluna antiga
		EXEC SP_EXECUTESQL @TEXTO;
		SET @TEXTO = CONCAT('ALTER TABLE ',@TABELA,' ADD ',@CAMPO,' ',@TIPO);--cria a coluna nova com o tipo novo
		EXEC SP_EXECUTESQL @TEXTO;
		SET @TEXTO = CONCAT('UPDATE ',@TABELA,' SET ',@CAMPO,' = ',@CAMPO,'_TEMP WHERE ', @CAMPO, '_TEMP IS NOT NULL; ');--passa os dados da coluna temporária para a coluna nova
		EXEC SP_EXECUTESQL @TEXTO;
		SET @TEXTO = CONCAT('ALTER TABLE ',@TABELA,' DROP COLUMN ',@CAMPO,'_TEMP; ');--apaga a coluna temporária
		EXEC SP_EXECUTESQL @TEXTO;
		COMMIT;
		PRINT 'Campo ' + @CAMPO + ' na tabela ' + @TABELA + ' alterado com sucesso.';
	END TRY
	BEGIN CATCH
		PRINT 'ERRO AO ALTERAR CAMPO ' + @CAMPO + ' NA TABELA ' + @TABELA + '!!!';
		RAISE_ERROR ERROR_MESSAGE();
		ROLLBACK;
	END CATCH
END
go

--verifica necessidades de alteração
SELECT  
		concat('EXEC MUDA_TIPO_CAMPO ''', c.[name], ''', ''',
		s.[name] , '.' , t.[name],''',''',
		case (y.[name])
			when 'geometry' then 'varbinary(max)'
			when 'geography' then 'varbinary(max)'
			when 'hierarchyid' then 'varchar(max)'
			when 'image' then 'varbinary(max)'
			when 'text' then 'varchar(max)'
			when 'ntext' then 'varchar(max)'
			when 'timestamp' then 'varbinary(max)'
			when 'xml' then 'varchar(max)'	
		end,''';') [comando]
FROM sys.tables  t
JOIN sys.schemas s on t.[schema_id] = s.[schema_id]
JOIN sys.columns c on t.[object_id]    = c.[object_id]
JOIN sys.types   y on c.[user_type_id] = y.[user_type_id]
WHERE y.[name] IN ('geography','geometry','hierarchyid','image','text','ntext','sql_variant','timestamp','xml')




--EXEMPLOS DE USO:
/*
Rascunho
ALTER TABLE CLIENTE ADD OBSERVACAO_NOVA VARCHAR(4000); 
UPDATE CLIENTE SET OBSERVACAO_NOVA = OBSERVACAO; 
ALTER TABLE CLIENTE DROP COLUMN OBSERVACAO; 
ALTER TABLE CLIENTE ADD OBSERVACAO VARCHAR(4000); 
UPDATE CLIENTE SET OBSERVACAO = OBSERVACAO_NOVA; 
GO;
*/

/*

EXEC MUDA_TIPO_CAMPO 'XMLCARTA', 'dbo.NFE_CCE','varchar(max)';
EXEC MUDA_TIPO_CAMPO 'URL', 'dbo.VENDA','varchar(max)';
EXEC MUDA_TIPO_CAMPO 'INICIO', 'dbo.COBRANCA','varchar(max)';
EXEC MUDA_TIPO_CAMPO 'FIM', 'dbo.COBRANCA','varchar(max)';
EXEC MUDA_TIPO_CAMPO 'OBSERVACAO', 'dbo.VALIDACAOCAIXA','varchar(max)';
EXEC MUDA_TIPO_CAMPO 'VALORIMAGEM', 'dbo.PARAMETROS','varbinary(max)';
*/

