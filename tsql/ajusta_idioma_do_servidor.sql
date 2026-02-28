SET DATEFORMAT dmy --Padrão brasileiro

--Configura o idioma padrao do servidor para novos usuários
exec sp_configure'default language', 27--Brazilian
reconfigure with override
 
--Configura o idioma padrao(Portugues) para o usuario SA
ALTER LOGIN sa WITH DEFAULT_LANGUAGE= Brazilian

--Select para alterar demais
declare @ajustes nvarchar(max) = '';
Select @ajustes+=concat('ALTER LOGIN [', name, '] WITH DEFAULT_LANGUAGE= Brazilian; ') 
From sys.syslogins 
Where status = 9 and name != '##MS_AgentSigningCertificate##'
exec sp_executesql @ajustes

--Confere usuários
select name, language 
from sys.syslogins

--Altera o idioma do servidor
set language 'Português (Brasil)'

--testa
Select @@langid, @@language

select dateformat from syslanguages where name = @@LANGUAGE