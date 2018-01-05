--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdiGeneraComplemComercioExteriorXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdiGeneraComplemComercioExteriorXML
GO

create function dbo.fCfdiGeneraComplemComercioExteriorXML (@soptype smallint, @sopnumbe varchar(21))
returns xml 
as
--Propósito. Genera el complemento de comercio exterior
--Requisitos. 
--05/01/18 jcf Creación Nodo comercio exterior v1.1
--
begin
	declare @cfd xml;
	WITH XMLNAMESPACES
	(
				'http://www.w3.org/2001/XMLSchema-instance' as "xsi",
				'http://www.sat.gob.mx/cfd/3' as "cfdi"
	)
	select @cfd = 
	(
	select 
		'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd'	'@xsi:schemaLocation',
		'1.1'				'@Version',
		2					'@TipoOperacion',

------------------------------------------------------------------------
		rtrim(tv.docid)										'@Serie',
		rtrim(tv.sopnumbe)									'@Folio',
		convert(datetime, tv.fechahora, 126)				'@Fecha',
		''													'@Sello', 

		case when tv.soptype = 3 
			then case when tv.orpmtrvd = tv.total 
					then pg.FormaPago
					else '99'
				end
			else tr.FormaPago
		end													'@FormaPago',
		''													'@NoCertificado', 
		''													'@Certificado', 
		rtrim(tv.pymtrmid)									'@CondicionesDePago',

		cast(tv.subtotal as numeric(19,2))					'@SubTotal',
		case when tv.descuento = 0 then null 
			else cast(tv.descuento as numeric(19,2)) 
		end													'@Descuento',
		tv.curncyid											'@Moneda',

		case when tv.curncyid in ('MXN', 'XXX')
			then null
			else cast(tv.xchgrate as numeric(19,6))
		end													'@TipoCambio',

		cast(tv.total  as numeric(19, 2))					'@Total',
		case when tv.SOPTYPE = 3 
			then 'I' 
			else 'E' 
		end													'@TipoDeComprobante',

		case when tv.soptype = 3
			then case when tv.orpmtrvd = tv.total
				then 'PUE'
				Else 'PPD'
				END
			else case when tr.FormaPago = '99'
				then 'PPD'
				Else 'PUE'
				END
		end													'@MetodoPago',
		emi.codigoPostal									'@LugarExpedicion',

        tr.TipoRelacion										'cfdi:CfdiRelacionados/@TipoRelacion',
		dbo.fCfdiRelacionadosXML(tv.soptype, tv.sopnumbe, tv.docid, tr.TipoRelacion) 'cfdi:CfdiRelacionados',
				
		emi.rfc												'cfdi:Emisor/@Rfc',
		emi.nombre											'cfdi:Emisor/@Nombre', 
		emi.regimen											'cfdi:Emisor/@RegimenFiscal',

		tv.idImpuestoCliente								'cfdi:Receptor/@Rfc',
		tv.nombreCliente									'cfdi:Receptor/@Nombre', 

		case when tv.idImpuestoCliente = 'XEXX010101000'
			then rtrim(tv.ccode)
			else null
		end													'cfdi:Receptor/@ResidenciaFiscal', 
		case when tv.idImpuestoCliente = 'XEXX010101000'
			then rtrim(tv.taxexmt1)
			else null
		end													'cfdi:Receptor/@NumRegIdTrib', 

		case when tv.idImpuestoCliente != 'XEXX010101000'
			then case when tv.usrtab01 = '' then isnull(pc.param1, 'P01') else left(upper(tv.usrtab01), 3) end
			else 'P01'
		END													'cfdi:Receptor/@UsoCFDI',

		dbo.fCfdiConceptosXML(tv.soptype, tv.sopnumbe, tv.subtotal, tv.docid),
		
		cast(tv.impuesto as numeric(19,2))					'cfdi:Impuestos/@TotalImpuestosTrasladados',		
		dbo.fCfdiImpuestosTrasladadosXML(tv.soptype, tv.sopnumbe, 0, 0)	'cfdi:Impuestos',

		''													'cfdi:Complemento'
	from dbo.vwCfdiSopTransaccionesVenta tv
		cross join dbo.fCfdEmisor() emi
		outer apply dbo.fCfdiPagoSimultaneoMayor(tv.soptype, tv.sopnumbe) pg
		outer apply dbo.fCfdiDatosDeUnaRelacion(tv.soptype, tv.sopnumbe, tv.docid) tr
		outer apply dbo.fCfdiParametrosCliente(tv.CUSTNMBR, 'UsoCFDI', 'na', 'na', 'na', 'na', 'na', 'PREDETERMINADO') pc
	where tv.sopnumbe =	@sopnumbe		
	and tv.soptype = @soptype
	FOR XML path('cfdi:Comprobante'), type
	)
	return @cfd;
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiGeneraComplemComercioExteriorXML ()'
ELSE PRINT 'Error en la creación de la función: fCfdiGeneraComplemComercioExteriorXML ()'
GO
-----------------------------------------------------------------------------------------
