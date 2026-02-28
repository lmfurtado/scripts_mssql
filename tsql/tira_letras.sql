
CREATE OR ALTER FUNCTION [dbo].[TiraLetras]
(@Resultado VARCHAR(8000))
RETURNS VARCHAR(8000) AS
BEGIN
DECLARE @CharInvalido SMALLINT
SET @CharInvalido = PATINDEX('%[^0-9]%', @Resultado)
WHILE @CharInvalido > 0
BEGIN
    SET @Resultado = STUFF(@Resultado, @CharInvalido, 1, '')
    SET @CharInvalido = PATINDEX('%[^0-9]%', @Resultado)
END
SET @Resultado = @Resultado
RETURN @Resultado
END
GO


 --select [dbo].[TiraLetras]('jdp09238dj29jd-w90f8jq-09f8jq-f9qfq-*345f-q3*54f-q34*f8')