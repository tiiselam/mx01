IF OBJECT_ID ('dbo.fCfdDatosXmlParaImpresion') IS NOT NULL
   drop function dbo.fCfdDatosXmlParaImpresion
go

create function dbo.fCfdDatosXmlParaImpresion(@archivoXml xml)
--Propósito. Obtiene los datos de la factura electrónica
--Usado por. vwCfdTransaccionesDeVenta
--Requisitos. CFDI
--05/10/10 jcf Creación
--10/07/12 jcf Agrega metodoDePago, NumCtaPago
--
returns table
return(
	WITH XMLNAMESPACES('http://www.sat.gob.mx/TimbreFiscalDigital' as "tfd")
	select 
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@selloCFD)[1]', 'varchar(8000)') selloCFD,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@FechaTimbrado)[1]', 'varchar(20)') FechaTimbrado,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@UUID)[1]', 'varchar(50)') UUID,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@noCertificadoSAT)[1]', 'varchar(20)') noCertificadoSAT,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@version)[1]', 'varchar(5)') [version],
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@selloSAT)[1]', 'varchar(8000)') selloSAT,
	@archivoXml.value('(//@sello)[1]', 'varchar(8000)') sello,
	@archivoXml.value('(//@noCertificado)[1]', 'varchar(20)') noCertificado,
	@archivoXml.value('(//@noAprobacion)[1]', 'integer') noAprobacion,
	@archivoXml.value('(//@anoAprobacion)[1]', 'integer') anoAprobacion,
	@archivoXml.value('(//@formaDePago)[1]', 'varchar(50)') formaDePago,
	@archivoXml.value('(//@metodoDePago)[1]', 'varchar(21)') metodoDePago,
	@archivoXml.value('(//@NumCtaPago)[1]', 'varchar(21)') NumCtaPago
	)
	go
--------------------------------------------------------------------------------------
--PRUEBAS--
--select * from cfdLogFacturaXML
