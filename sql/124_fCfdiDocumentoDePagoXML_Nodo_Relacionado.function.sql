USE [MEX10]
GO
/****** Object:  UserDefinedFunction [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado]    Script Date: 11/09/2017 21:18:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER function [dbo].[fCfdiDocumentoDePagoXML_Nodo_Relacionado] (@RMDTYPAL smallint, @DOCNUMBR varchar(21))
returns xml 
as
--Prop�sito. Devuelve el nodo DoctoRelacionado
--Requisitos. -
--24/10/2017 lt Creaci�n cfdi
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
        IdDocumento											'@IdDocumento',
		MonedaDR											'@MonedaDR',
		cast(TipoCambioDR as numeric (19,6))				'@TipoCambioDR',
		'PPD'												'@MetodoDePagoDR',
		NumParcialidad										'@NumParcialidad',
		CAST(ImpSaldoAnt as numeric (19,2))					'@ImpSaldoAnt',
		CAST(ImpPagado as numeric (19,2))					'@ImpPagado',
		CAST(ImpSaldoInsoluto  as numeric (19,2))			'@ImpSaldoInsoluto'
		from dbo.vwCfdiRMFacturas line
        WHERE  line.DOCNUMBR = @DOCNUMBR
		and line.RMDTYPAL = @RMDTYPAL
        FOR XML PATH ('pago10:DoctoRelacionado'), type

	)
	return @cnp;
end
