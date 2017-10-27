IF OBJECT_ID ('dbo.fCfdiDatosXmlParaImpresion') IS NOT NULL
   drop function dbo.fCfdiDatosXmlParaImpresion
go

create function dbo.fCfdiDatosXmlParaImpresion(@archivoXml xml)
--Propósito. Obtiene los datos de la factura electrónica
--Usado por. vwCfdTransaccionesDeVenta
--Requisitos. CFDI
--25/10/17 jcf Creación cfdi 3.3
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
	@archivoXml.value('(//@Sello)[1]', 'varchar(8000)') sello,
	@archivoXml.value('(//@NoCertificado)[1]', 'varchar(20)') noCertificado,
	@archivoXml.value('(//@FormaPago)[1]', 'varchar(50)') FormaPago,
	@archivoXml.value('(//@MetodoPago)[1]', 'varchar(21)') MetodoPago
	)
	go
--------------------------------------------------------------------------------------
--PRUEBAS--
--select * from cfdLogFacturaXML
