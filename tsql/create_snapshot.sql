--cria o snapshot
CREATE DATABASE LUNI_2693_SNAP ON
( NAME = LUNI_2693, FILENAME = 
'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\LUNI_2693_SNAP.ss' )
AS SNAPSHOT OF LUNI_2693;
GO

/*
--testa o snapshot
use LUNI_2693_SNAP
select max (hora) from venda where data = cast(getdate() as date)
*/

/*
--apaga o snapshot
use master
drop database LUNI_2693_SNAP
*/