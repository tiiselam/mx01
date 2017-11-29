IF OBJECT_ID ('dbo.fCfdiDocumentoDePagoXML_Nodo_Relacionado') IS NOT NULL
   DROP FUNCTION dbo.[fCfdiDocumentoDePagoXML_Nodo_Relacionado]
GO

create function [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Propósito. Devuelve el nodo DoctoRelacionado
--Requisitos. -
--24/10/2017 lt Creación cfdi
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
			fa.IdDocumento '@IdDocumento',
			fa.MonedaDR '@MonedaDR',
			cast(fa.TipoCambioDR as numeric(19,6))	'@TipoCambioDR',
			fa.MetodoDePagoDR '@MetodoDePagoDR',
			fa.NumParcialidad '@NumParcialidad',
			cast(fa.ImpSaldoAnt as numeric(19,2))			'@ImpSaldoAnt',

			--case when (fa.ImpPagadoFuncional - fa.ororgtrx * isnull(fa.TipoCambioP, 1)) between 0 and 0.03
			--	then cast(round(fa.ororgtrx * isnull(fa.TipoCambioP, 1), 2) as numeric(19,2)) 
			--	else cast(fa.ImpPagado as numeric(19,2)) 
			--end '@ImpPagado',

			cast(fa.ImpPagado as numeric(19,2))			'@ImpPagado',
			cast(fa.ImpSaldoInsoluto as numeric(19,2))	'@ImpSaldoInsoluto'
		from dbo.[fCfdiDocumentoDePagoRelacionado](@RMDTYPAL, @DOCNUMBR) fa
  --      WHERE  fa.DOCNUMBR = @DOCNUMBR
		--and fa.RMDTYPAL = @RMDTYPAL
        FOR XML PATH ('pago10:DoctoRelacionado'), type

	)
	return @cnp;
end
go



IF (@@Error = 0) PRINT 'Creación exitosa de: [fCfdiDocumentoDePagoXML_Nodo_Relacionado]()'
ELSE PRINT 'Error en la creación de: [fCfdiDocumentoDePagoXML_Nodo_Relacionado]()'
GO
--select [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (9, 'PYMNT00000029')