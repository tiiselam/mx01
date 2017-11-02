-----------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwCfdiTrxCobros]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.[vwCfdiTrxCobros];
GO

create view dbo.vwCfdiTrxCobros as
--Propósito. Todos los cobros 
--			Incluye la cadena original para el cfdi.
--			Si el documento no fue emitido, genera el comprobante xml en el campo comprobanteXml
--Usado por. App Factura digital (doodads)
--Requisitos. El estado "no emitido" indica que no se ha emitido el archivo xml pero que está listo para ser generado.
--			El estado "inconsistente" indica que existe un problema en el folio o certificado, por tanto no puede ser generado.
--			El estado "emitido" indica que el archivo xml ha sido generado y sellado por el PAC y está listo para ser impreso.
--30/10/17 jcf Creación cfdi 3.3
--
select case when cb.rmTipoTrx in ('A', 'H') then 'contabilizado' else 'en lote' end estadoContabilizado, 
	cb.rmdtypal soptype, 'COBRO' docid, cb.docnumbr sopnumbe, convert(datetime, cb.docdate, 126) fechahora,
 
	cb.CUSTNMBR, custname nombreCliente, cb.txrgnnum idImpuestoCliente, cb.TotalDoc total, cb.montoActualOriginal, cb.voidstts, 

	isnull(lf.estado, isnull(fv.estado, 'inconsistente')) estado,
	case when isnull(lf.estado, isnull(fv.estado, 'inconsistente')) = 'inconsistente' 
		then 'folio o certificado inconsistente'
		else ISNULL(lf.mensaje, 'contabilizado')
	end mensaje,

	case when isnull(lf.estado, isnull(fv.estado, 'inconsistente')) = 'no emitido' 
		then [dbo].[fCfdiDocumentoDePagoXML] (cb.RMDTYPAL, cb.DOCNUMBR)
		else cast('' as xml) 
	end comprobanteXml,
	
	--Datos del xml sellado por el PAC:
	isnull(dx.selloCFD, '') selloCFD, 
	isnull(dx.FechaTimbrado, '') FechaTimbrado, 
	isnull(dx.UUID, '') UUID, 
	isnull(dx.noCertificadoSAT, '') noCertificadoSAT, 
	isnull(dx.[version], '') [version], 
	isnull(dx.selloSAT, '') selloSAT, 
	isnull(dx.FormaPago, '') formaDePago,
	isnull(dx.sello, '') sello, 
	isnull(dx.noCertificado, '') noCertificado, 

	'||'+dx.[version]+'|'+dx.UUID+'|'+dx.FechaTimbrado+'|'+dx.RfcPAC + 
	case when isnull(dx.Leyenda, '') = '' then '' else '|'+dx.Leyenda end
	+'|'+dx.selloCFD+'|'+dx.noCertificadoSAT+'||' cadenaOriginalSAT,
	
	fv.ID_Certificado, fv.ruta_certificado, fv.ruta_clave, fv.contrasenia_clave, 
	isnull(pa.ruta_certificado, '_noexiste') ruta_certificadoPac, isnull(pa.ruta_clave, '_noexiste') ruta_clavePac, isnull(pa.contrasenia_clave, '') contrasenia_clavePac, 
	emi.rfc, emi.regimen, emi.rutaXml, 
	isnull(lf.estadoActual, '000000') estadoActual, 
	isnull(lf.mensajeEA, 'contabilizado') mensajeEA,
	isnull(dx.MetodoPago, '') metodoDePago,
	rtrim(mo.isocurrc) isocurrc
from dbo.vwRmTransaccionesTodas cb
	cross join dbo.fCfdEmisor() emi
	outer apply dbo.fCfdCertificadoVigente(cb.docdate) fv
	outer apply dbo.fCfdCertificadoPAC(cb.docdate) pa
	left join cfdlogfacturaxml lf
		on lf.soptype = cb.rmdtypal
		and lf.sopnumbe = cb.docnumbr
		and lf.estado = 'emitido'
	left outer join dynamics..mc40200 mo
		on mo.CURNCYID = cb.curncyid
	outer apply dbo.fCfdiDatosXmlParaImpresion(lf.archivoXML) dx
where cb.rmdtypal = 9

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwCfdiTrxCobros'
ELSE PRINT 'Error en la creación de la vista: vwCfdiTrxCobros'
GO
----------------------------------------------------------------------------------------------------

--sp_columns vwRmTransaccionesTodas
--sp_statistics cfdlogfacturaxml


