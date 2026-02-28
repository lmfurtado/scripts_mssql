CREATE TRIGGER prevent_insert
   ON  UsuarioAplicativo
   AFTER INSERT
AS 
BEGIN
	ROLLBACK TRANSACTION
END
GO
