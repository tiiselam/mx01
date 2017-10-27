USE [MEX10]
GO


alter function [dbo].fCfdiDocumentoDePagoXMLPago (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Propósito. DEVOLVER UN XML PARA UN COBRO TOTALMENTE APLICADO Y CONTABILIZADO, DE OTRO MODO DEVOLVER NULL
--Requisitos. EL COBRO DEBE ESTAR TOTALMENTE APLICA Y CONTABILIZADO
--24/10/2017  Creación cfdi
--
begin
	declare @cnp xml;
	WITH XMLNAMESPACES
	(
				'http://www.sat.gob.mx/Pagos' as "pago10"
	)
	select @cnp = 
		(SELECT  
			convert(datetime, hdr.docdate, 126)					'@FechaPago',
			''													'@FormaDePagoP',
			c.ISOCURRC											'@MonedaP',
			case when c.ISOCURRC<>'MXN' THEN cast(m.XCHGRATE as numeric(19,6)) else null END
																'@TipoCambioP',
			cast(hdr.ORTRXAMT as numeric(19,2))					'@Monto',
			[dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (@RMDTYPAL, @DOCNUMBR)
		FROM RM20101  AS hdr
			left join RM00101 cl on cl.CUSTNMBR=hdr.CUSTNMBR
			left join MC020102 m on m.DOCNUMBR=hdr.DOCNUMBR and m.RMDTYPAL=hdr.RMDTYPAL
			left join dynamics.dbo.MC40200 c on c.CURNCYID = hdr.CURNCYID
		where hdr.docnumbr =	@docnumbr	
		and hdr.RMDTYPAL = @rmdtypal
		FOR XML PATH('pago10:Pago'), Type	--, root('pago10:Pagos')
		)
	return @cnp;
end

