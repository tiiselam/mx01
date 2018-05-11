IF OBJECT_ID ('dbo.fCfdiDocumentoDePago') IS NOT NULL
   DROP FUNCTION dbo.fCfdiDocumentoDePago
GO


CREATE function [dbo].fCfdiDocumentoDePago (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns table 
as
--Propósito. Devuelve datos de un cobro
--Requisitos. Obtiene la tc del pago que permita que el monto del pago sea siempre mayor en casos especiales. Ver fCfdiDocumentoDePagoRelacionado.
--30/11/17 jcf Creación cfdi
--
return
		(
		SELECT 
			RMDTYPAL, DOCNUMBR, 
			CONVERT(datetime, 
						replace(convert(varchar(20), hdr.DOCDATE, 102), '.', '-')+'T'+
						substring(convert(varchar(30), 
							DATEADD(hh,
									case when isnumeric(pa.param1) = 1 then convert(int, pa.param1) else 0 end, 
									hdr.dex_row_ts
									)
							, 126), 12, 8)
					,126) 
			fechaHora,
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
			outer apply dbo.fCfdiMcpFormaPago(hdr.DOCNUMBR) mcp
			left join CM00101 tef 
				on tef.CHEKBKID = CASE WHEN hdr.bchsourc like '%MCP%' then mcp.tii_chekbkid else hdr.mscschid end
			outer apply dbo.fCfdiFormaPagoManual(hdr.mscschid, hdr.CSHRCTYP, hdr.FRTSCHID) ch
			outer apply dbo.fCfdiParametrosCliente(hdr.custnmbr, 'RfcEmisorCtaOrd', 'NomBancoOrdExt', 'CtaOrdenante', 'NA', 'NA', 'NA', 'PREDETERMINADO') cp
			outer apply (select max(TipoCambioP) TipoCambioP from dbo.fCfdiDocumentoDePagoRelacionado(hdr.RMDTYPAL, hdr.docnumbr)) pago
			outer apply dbo.fcfdiparametros('MEXTZONE','NA','NA','NA','NA','NA','PREDETERMINADO') pa
		where hdr.docnumbr = @DOCNUMBR	
		and hdr.RMDTYPAL = @RMDTYPAL
		)

go

IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePago]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePago]()'
GO
