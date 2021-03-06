IF OBJECT_ID ('dbo.fCfdiDocumentoDePagoXML_Nodo_Relacionado') IS NOT NULL
   DROP FUNCTION dbo.[fCfdiDocumentoDePagoXML_Nodo_Relacionado]
GO

create function [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Propósito. Devuelve el nodo DoctoRelacionado
--Requisitos. -
--24/10/17 lt Creación cfdi
--11/01/18 jcf Si tipoCambioDR es 1 no debe tener decimales
--
begin
	declare @cnp xml;
	WITH XMLNAMESPACES
	(
			'http://www.sat.gob.mx/Pagos' as "pago10"
	)
	select @cnp = 
	(
        SELECT     
			fa.IdDocumento		'@IdDocumento',
			fa.MonedaDR			'@MonedaDR',
			case when isnull(fa.TipoCambioDR, -1) = 1 then 1
				else cast(fa.TipoCambioDR as numeric(19,6))
			end					'@TipoCambioDR',
			fa.MetodoDePagoDR	'@MetodoDePagoDR',
			fa.NumParcialidad	'@NumParcialidad',
			cast(fa.ImpSaldoAnt as numeric(19,2))		'@ImpSaldoAnt',

			cast(fa.ImpPagado as numeric(19,2))			'@ImpPagado',
			cast(fa.ImpSaldoInsoluto as numeric(19,2))	'@ImpSaldoInsoluto'
		from dbo.[fCfdiDocumentoDePagoRelacionado](@RMDTYPAL, @DOCNUMBR) fa
        FOR XML PATH ('pago10:DoctoRelacionado'), type

	)
	return @cnp;
end
go



IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePagoXML_Nodo_Relacionado]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePagoXML_Nodo_Relacionado]()'
GO
--select [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (9, 'PYMNT00000029')