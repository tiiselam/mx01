IF (OBJECT_ID ('dbo.vwCfdiRMFacturas', 'V') IS NULL)
   exec('create view dbo.[vwCfdiRMFacturas] as SELECT 1 as t');
go

alter VIEW [dbo].[vwCfdiRMFacturas]
--Propósito. Calcula los datos para nodo xml DoctoRelacionado de cfdi de pagos 33.
--26/10/17 lt Creación
--27/10/17 jcf Agrega y modifica llamada a funciones
--
AS
SELECT  
            pago.DOCDATE AS FechaPago, cup.ISOCURRC AS MonedaP, 
			CASE WHEN cup.ISOCURRC <> 'MXN' 
				THEN 
					case when cuf.ISOCURRC = 'MXN' 
						then round(a.ORAPTOAM/a.actualapplytoamount, 6) + 0.000001	--usar un truco para que el pago sea siempre mayor
						else pago.XCHGRATE
					end
				ELSE null 
			END AS TipoCambioP, 

			pago.ororgtrx AS Monto,
            cuf.ISOCURRC AS MonedaDR, 

			case when cup.isocurrc = cuf.isocurrc or a.actualapplytoamount = 0
				then null
				else 
					CASE WHEN cuf.ISOCURRC = 'MXN' 
						THEN 1
						ELSE --moneda factura / moneda pago
							round(a.ORAPTOAM / a.actualapplytoamount, 6) - --restar un infinitésimo para que el pago sea mayor
							case when cup.ISOCURRC = 'MXN' and cuf.ISOCURRC != 'MXN' then 0.000001 else 0 end
					END  
			end TipoCambioDR,

			CASE WHEN LEFT(UPPER(pago.TRXDSCRN), 1) = '#' and isnumeric(substring(pago.TRXDSCRN, 2, 2)) = 1
				THEN CAST(substring(pago.TRXDSCRN, 2, 2) AS int) 
				ELSE pcm.numCuota
			end NumParcialidad,

			--moneda de la factura: 
			--monto Original de factura -  acumulado de aplicaciones en moneda de factura + monto aplicado
			F.ororgtrx - pcm.sumaORAPTOAM + a.ORAPTOAM ImpSaldoAntMonFac,
			a.ORAPTOAM ImpPagadoMonFac,
			F.ororgtrx - pcm.sumaORAPTOAM ImpSaldoInsolutoMonFac,

			--moneda funcional
			(F.ORTRXAMT+isnull(reval.Total_Gain_or_Loss_on_Cu, 0)) - (pcm.sumaApfrmaplyamt+ pcm.sumaAPFRMWROFAMT) + a.Apfrmaplyamt ImpSaldoAnt,
			a.Apfrmaplyamt ImpPagado,
			(F.ORTRXAMT+isnull(reval.Total_Gain_or_Loss_on_Cu, 0)) - (pcm.sumaApfrmaplyamt+ pcm.sumaAPFRMWROFAMT) ImpSaldoInsoluto,

			pago.DOCNUMBR, a.APTODCNM, pago.TRXDSCRN, pago.RMDTYPAL, pago.VOIDSTTS, pago.ororgtrx,

            uf.uuid AS IdDocumento
FROM    dbo.vwRmTransaccionesTodas AS pago
		inner JOIN dbo.vwCfdiRmTrxAplicadas AS a ON pago.RMDTYPAL = a.APFRDCTY AND pago.DOCNUMBR = a.APFRDCNM 
		inner JOIN dbo.vwRmTransaccionesTodas AS F ON F.RMDTYPAL = a.APTODCTY AND F.DOCNUMBR = a.APTODCNM and F.voidstts = 0
		LEFT OUTER JOIN DYNAMICS.dbo.MC40200 AS cup ON cup.CURNCYID = pago.CURNCYID
		LEFT OUTER JOIN DYNAMICS.dbo.MC40200 AS cuf ON cuf.CURNCYID = F.CURNCYID
		outer apply dbo.fCfdiObtieneUUID(F.soptype, a.APTODCNM) uf
		outer apply dbo.fCfdiRmAjusteAcumuladoDeRevaluacion(a.APTODCNM, a.APTODCTY, pago.curncyid, a.APFRDCDT) reval
		outer apply dbo.fCfdiPagosAcumulados(a.APFRDCTY, a.APFRDCNM, a.APFRDCDT, a.APTODCTY, a.APTODCNM, pago.TRXDSCRN) pcm
where F.rmdtypal != 3	--nota de débito

GO

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: [vwCfdiRMFacturas]  '
ELSE PRINT 'Error en la creación de la vista: [vwCfdiRMFacturas] '
GO
