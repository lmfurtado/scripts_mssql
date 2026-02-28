DECLARE @startnum INT= (select notainicial FROM NFE_INUTILIZADA ni);
DECLARE @endnum INT=(select notafinal FROM NFE_INUTILIZADA ni);

WITH gen AS (
    SELECT @startnum AS num
    UNION ALL
    SELECT num+1 FROM gen WHERE num+1<=@endnum)
SELECT * FROM gen