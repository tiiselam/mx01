/****** Object:  UserDefinedFunction [dbo].[fCfdiDocumentoDePagoXMLPagos]    Script Date: 11/09/2017 21:16:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fCfdiDocumentoDePagoXMLPagos] (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
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

