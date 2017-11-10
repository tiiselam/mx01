USE [MEX10]
GO
/****** Object:  UserDefinedFunction [dbo].[fCfdiDocumentoDePagoXMLPago]    Script Date: 11/09/2017 21:17:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER function [dbo].[fCfdiDocumentoDePagoXMLPago] (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
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
			CASE WHEN MCP.PARAM2='SI' then Rtrim(mcpd.grupid) else 
				case fp.CSHRCTYP 
					when 0 then '02' 
					when 1 then Rtrim(ch.CMUSRDF1) 
					when 2 then left(FRTSCHID,2) else null end end
																'@FormaDePagoP',
			LTRIM(RTRIM(C.ISOCURRC))							'@MonedaP',
			case when hdr.curncyid<>'MXN' THEN cast(XCHGRATE as numeric(19,6)) else null END
																'@TipoCambioP',
			cast(hdr.ORTRXAMT as numeric(19,2))					'@Monto',
			[dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (@RMDTYPAL, @DOCNUMBR)
		FROM vwRmTransaccionesTodas  AS hdr
		left join dynamics.dbo.MC40200 c on c.CURNCYID = HDR.CURNCYID
		left join nfmcp20100 mcpfp on mcpfp.numberie = hdr.docnumbr
		left join nfmcp00700 mcpd on mcpd.medioid=mcpfp.medioid
		left join (select CSHRCTYP,docnumbr,rmdtypal,CBKIDCHK,FRTSCHID from RM20101) fp on fp.docnumbr=hdr.docnumbr and fp.rmdtypal=hdr.rmdtypal
		left join CM00100 ch on ch.CHEKBKID=fp.CBKIDCHK
		outer apply dbo.fcfdiparametros('NA','MCP','NA','NA','NA','NA','PREDETERMINADO') mcp
		where hdr.docnumbr =	@docnumbr	
		and hdr.RMDTYPAL = @rmdtypal
		FOR XML PATH('pago10:Pago'), Type	--, root('pago10:Pagos')
		)
	return @cnp;
end

