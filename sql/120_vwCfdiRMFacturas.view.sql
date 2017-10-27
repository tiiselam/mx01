USE [MEX10]
GO


alter VIEW [dbo].[vwCfdiRMFacturas]
--Propósito. Calcula los datos para nodo xml DoctoRelacionado de cfdi de pagos 33.
--26/10/17 lt Creación
--27/10/17 jcf Agrega y modifica llamada a funciones
--
AS
SELECT  
			pa.inet8 RegimenFiscal, 
			d.TXRGNNUM AS rfc, 
            CASE WHEN d.TXRGNNUM = 'XEXX010101000' THEN pac.param1 else null END AS ResidenciaFiscal, 
            CASE WHEN d.TXRGNNUM = 'XEXX010101000' THEN pac.param2 else null END AS NumRegIdTrib,

            d.DOCDATE AS FechaPago, cup.ISOCURRC AS MonedaP, 
			CASE WHEN cup.ISOCURRC <> 'MXN' 
				THEN cast(d.XCHGRATE  as numeric(19,6))
				ELSE null 
			END AS TipoCambioP, 
			d.ORTRXAMT AS Monto,
            cuf.ISOCURRC AS MonedaDR, 

			case when cup.isocurrc = cuf.isocurrc 
				then null
				else
					CASE WHEN cuf.ISOCURRC = 'MXN' 
						THEN 1 
						ELSE a.oraptoam / a.apptoamt
					END  
			end TipoCambioDR,

			CASE WHEN LEFT(UPPER(d.TRXDSCRN), 1) = 'C' and isnumeric(substring(d.TRXDSCRN, 2, 2)) = 1
				THEN CAST(substring(d.TRXDSCRN, 2, 2) AS int) 
				ELSE pcm.numCuota
			end NumParcialidad,

			F.ORTRXAMT - pcm.sumaDePagosAplicados + a.oraptoam ImpSaldoAnt,

			a.ORAPTOAM AS ImpPagado,
            
			F.ORTRXAMT - pcm.sumaDePagosAplicados ImpSaldoInsoluto,

			d.DOCNUMBR, a.APTODCNM, d.TRXDSCRN, d.RMDTYPAL, d.VOIDSTTS,

            uf.uuid AS IdDocumento
FROM    dbo.vwRmTransaccionesTodas AS d 
		inner JOIN dbo.vwCfdiRmTrxAplicadas AS a ON d.RMDTYPAL = a.APFRDCTY AND d.DOCNUMBR = a.APFRDCNM 
		inner JOIN dbo.vwRmTransaccionesTodas AS F ON F.RMDTYPAL = a.APTODCTY AND F.DOCNUMBR = a.APTODCNM and F.voidstts = 0
		LEFT OUTER JOIN DYNAMICS.dbo.MC40200 AS cup ON cup.CURNCYID = d.CURNCYID
		LEFT OUTER JOIN DYNAMICS.dbo.MC40200 AS cuf ON cuf.CURNCYID = F.CURNCYID
		outer apply dbo.fCfdiParametros('VERSION', 'NA', 'NA', 'NA', 'NA', 'NA', 'PREDETERMINADO') pa
		outer apply dbo.fCfdiParametrosCliente(d .CUSTNMBR, 'ResidenciaFiscal', 'NumRegIdTrib', 'NA', 'NA', 'NA', 'NA', 'PREDETERMINADO') pac
		outer apply dbo.fCfdiObtieneUUID(a.APTODCTY, a.APTODCNM) uf
		outer apply dbo.fCfdiPagosAcumulados(a.APFRDCTY, a.APFRDCNM, a.APFRDCDT, a.APTODCTY, a.APTODCNM, d.TRXDSCRN) pcm

GO

