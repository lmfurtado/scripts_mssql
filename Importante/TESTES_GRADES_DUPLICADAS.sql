-- ALTERA PRODUTO_FK1 PARA CASCADE--

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

--
-- Start Transaction
--
BEGIN TRANSACTION
GO

--
-- Drop foreign key "PRODUTO_fk1" on table "dbo.PRODUTO"
--
ALTER TABLE dbo.PRODUTO
  DROP CONSTRAINT PRODUTO_fk1
GO
IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

--
-- Create foreign key "PRODUTO_fk1" on table "dbo.PRODUTO"
--
ALTER TABLE dbo.PRODUTO
  ADD CONSTRAINT PRODUTO_fk1 FOREIGN KEY (GRADELOJA, GRADE) REFERENCES dbo.GRADE (LOJA, CODIGO) ON UPDATE CASCADE
GO
IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO


--
-- Commit Transaction
--
IF @@TRANCOUNT>0 COMMIT TRANSACTION
GO


--
-- Set NOEXEC to off
--
SET NOEXEC OFF
GO

---------------------------------------------------------------------------------------------------------------------

BEGIN TRANSACTION 

select 
 tipoloja, tipo, marcaloja, marca, referencia, cor1loja, cor1, cor2loja, cor2, cor3loja, cor3, gradetamanho
 , count(*) as qtde
 into #gradecount
from grade
group by tipoloja, tipo, marcaloja, marca, referencia, cor1loja, cor1, cor2loja, cor2, cor3loja, cor3, gradetamanho
having count(*) > 1
order by count(*) desc

 select * from #gradecount

 --  drop table #gradeprod ;
 select g.loja, g.codigo,  
 (select top 1 gnova.codigo from grade gnova where 
	 t.tipoloja			= gnova.tipoloja and 
	 t.tipo				= gnova.tipo and
	 t.marcaloja		= gnova.marcaloja and
	 t.marca			= gnova.marca and
	 t.referencia		= gnova.referencia and
	 t.cor1loja			= gnova.cor1loja and 
	 t.cor1				= gnova.cor1 and 
	 t.cor2loja			= gnova.cor2loja and 
	 t.cor2				= gnova.cor2 and 
	 t.cor3loja			= gnova.cor3loja and 
	 t.cor3				= gnova.cor3 and 
	 t.gradetamanho		= gnova.gradetamanho 
	 order by codigo asc) as codigonovo
 into #gradeprod
  from grade g 
 inner join #gradecount t on
 g.tipoloja = t.tipoloja and 
 g.tipo = t.tipo and
 g.marcaloja = t.marcaloja and
 g.marca = t.marca and
 g.referencia = t.referencia and
 g.cor1loja = t.cor1loja and 
 g.cor1 = t.cor1 and 
 g.cor2loja = t.cor2loja and 
 g.cor2 = t.cor2 and 
 g.cor3loja = t.cor3loja and 
 g.cor3 = t.cor3 and
 g.gradetamanho = t.gradetamanho 

 select * from #gradeprod


update grade set loja = 1


update produto set grade = (select codigonovo from #gradeprod gp where gp.codigo = grade)
where produto.grade in (select codigo from #gradeprod gp where gp.codigo = grade)

delete from grade  where not exists (select 1 from produto p where p.gradeloja = grade.loja and p.grade = grade.codigo)

IF @@TRANCOUNT>0 COMMIT TRANSACTION
GO