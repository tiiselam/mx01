IF OBJECT_ID ('dbo.fCfdiDocumentoDePago') IS NOT NULL
   DROP FUNCTION dbo.fCfdiDocumentoDePago
GO


CREATE function [dbo].fCfdiDocumentoDePago (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns table 
as
--Propósito. Devuelve datos de un cobro
--Requisitos. -
--20/11/17 jcf Creación cfdi
--
return
		(SELECT 
			RMDTYPAL, DOCNUMBR, 
			hdr.docdate, hdr.bchsourc, ch.CMUSRDF1, hdr.mscschid, hdr.CSHRCTYP, hdr.FRTSCHID, 
			CASE WHEN hdr.bchsourc like '%MCP%' then Rtrim(mcp.grupid) 
				else 
					case when left(UPPER(ch.CMUSRDF1), 2) = 'CB' then	--ch representa una cuenta bancaria
 						case hdr.CSHRCTYP 
 							when 0 then '02'					--cheque
 							when 1 then '03'					--transf. electrónica
 							when 2 then left(hdr.FRTSCHID,2)
							else null 
						end
						else										--representa un medio de pago
 							left(Rtrim(ch.CMUSRDF1), 2)
					end						
			end											FormaDePagoP,
 			LTRIM(RTRIM(C.ISOCURRC))					MonedaP,
			case when c.ISOCURRC<>'MXN' THEN 
				hdr.XCHGRATE
				else null 
			END											TipoCambioP,

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
 			left join CM00100 ch on ch.CHEKBKID=hdr.mscschid
			left join CM00101 tef on tef.CHEKBKID = hdr.mscschid
			outer apply dbo.fCfdiMcpFormaPago(hdr.DOCNUMBR) mcp
 			--outer apply dbo.fcfdiparametros('NA','MCP','NA','NA','NA','NA','PREDETERMINADO') pa
			outer apply dbo.fCfdiParametrosCliente(hdr.custnmbr, 'RfcEmisorCtaOrd', 'NomBancoOrdExt', 'CtaOrdenante', 'NA', 'NA', 'NA', 'PREDETERMINADO') cp
		where hdr.docnumbr = @DOCNUMBR	
		and hdr.RMDTYPAL = @RMDTYPAL
		)

go

IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePago]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePago]()'
GO
