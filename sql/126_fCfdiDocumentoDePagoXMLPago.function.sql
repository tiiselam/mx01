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
			convert(datetime, hdr.docdate, 126)	'@FechaPago',
			hdr.FormaDePagoP '@FormaDePagoP',
 			hdr.MonedaP '@MonedaP',
			cast(hdr.TipoCambioP as numeric(19,6)) '@TipoCambioP',
			cast(hdr.Monto as numeric(19,2)) '@Monto',
			hdr.NumOperacion '@NumOperacion',
			case when hdr.RfcEmisorCtaOrd like 'no existe tag%' then null else hdr.RfcEmisorCtaOrd end '@RfcEmisorCtaOrd',
			case when hdr.NomBancoOrdExt like 'no existe tag%' then null else hdr.NomBancoOrdExt  end '@NomBancoOrdExt',
			case when hdr.CtaOrdenante like 'no existe tag%' then null else hdr.CtaOrdenante  end '@CtaOrdenante',
			rtrim(hdr.RfcEmisorCtaBen) '@RfcEmisorCtaBen', 
			rtrim(hdr.CtaBeneficiario) '@CtaBeneficiario',
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
