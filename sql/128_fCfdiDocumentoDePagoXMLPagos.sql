USE [MEX10]
GO

alter function [dbo].fCfdiDocumentoDePagoXMLPagos (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Propósito. Obtiene nodo Pagos
--Requisitos. -
--24/10/2017 LT Creación cfdi
--
begin
	declare @cnp xml;
	WITH XMLNAMESPACES
	(
				'http://www.sat.gob.mx/Pagos' as "pago10"
	)
	select @cnp = 
		(SELECT  '1.0'											'@Version',
			[dbo].fCfdiDocumentoDePagoXMLPago (@RMDTYPAL, @DOCNUMBR)
		FOR XML PATH('pago10:Pagos'), Type
		)
	return @cnp;
end

