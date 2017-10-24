IF OBJECT_ID ('dbo.fCfdiObtieneUUID') IS NOT NULL
   DROP FUNCTION dbo.fCfdiObtieneUUID
GO

create function dbo.fCfdiObtieneUUID(@soptype smallint, @sopnumbe varchar(21))
returns table
as
--Propósito. Devuelve el UUID de un cfdi
--Requisitos. 
--13/10/17 jcf Creación 
--
return
(
	select cfdi.uuid
	from dbo.vwCfdTransaccionesDeVenta cfdi
	where cfdi.soptype = @soptype
	and cfdi.sopnumbe = @sopnumbe
	
)
go


IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiObtieneUUID()'
ELSE PRINT 'Error en la creación de la función: fCfdiObtieneUUID()'
GO

-------------------------------------------------------------------------------------------------------------
--select *
--from fCfdiObtieneUUID('000011658                      ', 'tipoAddenda', 'NA', 'NA', 'NA', 'NA', 'NA', 'PREDETERMINADO')

--sp_columns vwCfdTransaccionesDeVenta
