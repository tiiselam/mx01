IF OBJECT_ID ('dbo.fCfdiDocumentoDePagoXMLPago') IS NOT NULL
   DROP FUNCTION dbo.fCfdiDocumentoDePagoXMLPago
GO


CREATE function [dbo].fCfdiDocumentoDePagoXMLPago (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Propósito. DEVOLVER UN XML PARA UN COBRO TOTALMENTE APLICADO Y CONTABILIZADO, DE OTRO MODO DEVOLVER NULL
--Requisitos. EL COBRO DEBE ESTAR TOTALMENTE APLICADO Y CONTABILIZADO
--24/10/17 lt Creación cfdi
--10/11/17 jcf Correcciones varias
--
begin
	declare @cnp xml;
	WITH XMLNAMESPACES
	(
				'http://www.sat.gob.mx/Pagos' as "pago10"
	)
	select @cnp = 
		(SELECT  
			convert(datetime, hdr.docdate, 126)	FechaPago,
			hdr.FormaDePagoP,
 			hdr.MonedaP,
			hdr.TipoCambioP,
			hdr.Monto,
			hdr.NumOperacion,
			hdr.RfcEmisorCtaOrd,
			hdr.NomBancoOrdExt,
			hdr.CtaOrdenante,
			hdr.RfcEmisorCtaBen, 
			hdr.CtaBeneficiario,
			[dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (hdr.RMDTYPAL, hdr.DOCNUMBR)
		FROM dbo.fCfdiDocumentoDePago(@RMDTYPAL, @DOCNUMBR) hdr
		where hdr.docnumbr = @DOCNUMBR	
			and hdr.RMDTYPAL = @RMDTYPAL
			FOR XML PATH('pago10:Pago'), Type	--, root('pago10:Pagos')
		)
	return @cnp;
end

go

IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePagoXMLPago]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePagoXMLPago]()'
GO
