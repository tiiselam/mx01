IF OBJECT_ID ('dbo.fCfdiDocumentoDePago') IS NOT NULL
   DROP FUNCTION dbo.fCfdiDocumentoDePago
GO


CREATE function [dbo].fCfdiDocumentoDePago (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns table 
as
--Propósito. Devuelve datos de un cobro
--Requisitos. Obtiene la tc del pago que permita que el monto del pago sea siempre mayor en casos especiales. Ver fCfdiDocumentoDePagoRelacionado.
--20/11/17 jcf Creación cfdi
--
return
		(SELECT 
			RMDTYPAL, DOCNUMBR, 
			hdr.docdate, hdr.bchsourc, hdr.mscschid, hdr.CSHRCTYP, hdr.FRTSCHID, 
			CASE WHEN hdr.bchsourc like '%MCP%' then Rtrim(mcp.grupid) 
				else ch.FormaPago
			end											FormaDePagoP,
 			LTRIM(RTRIM(C.ISOCURRC))					MonedaP,
			pago.TipoCambioP,

			hdr.ororgtrx								Monto,
			CASE when hdr.cheknmbr = '' then null 
				else rtrim(hdr.cheknmbr) 
			end											NumOperacion,
			cp.param1									RfcEmisorCtaOrd,
			cp.param2									NomBancoOrdExt,
			cp.param3									CtaOrdenante,
			tef.TXRGNNUM								RfcEmisorCtaBen, 
			tef.EFTBANKACCT								CtaBeneficiario
		FROM dbo.vwRmTransaccionesTodas hdr
 			left join dynamics.dbo.MC40200 c on c.CURNCYID = HDR.CURNCYID
 			--left join CM00100 ch on ch.CHEKBKID=hdr.mscschid
			left join CM00101 tef on tef.CHEKBKID = hdr.mscschid
			outer apply dbo.fCfdiFormaPagoManual(hdr.mscschid, hdr.CSHRCTYP, hdr.FRTSCHID) ch
			outer apply dbo.fCfdiMcpFormaPago(hdr.DOCNUMBR) mcp
			outer apply dbo.fCfdiParametrosCliente(hdr.custnmbr, 'RfcEmisorCtaOrd', 'NomBancoOrdExt', 'CtaOrdenante', 'NA', 'NA', 'NA', 'PREDETERMINADO') cp
			outer apply (select max(TipoCambioP) TipoCambioP from dbo.fCfdiDocumentoDePagoRelacionado(@RMDTYPAL, @DOCNUMBR)) pago
		where hdr.docnumbr = @DOCNUMBR	
		and hdr.RMDTYPAL = @RMDTYPAL
		)

go

IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePago]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePago]()'
GO
