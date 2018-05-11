IF (OBJECT_ID ('dbo.vwCfdiRelacionado', 'V') IS NULL)
   exec('create view dbo.[vwCfdiRelacionado] as SELECT 1 as t');
go

alter VIEW [dbo].[vwCfdiRelacionado]
--Propósito. Obtiene el uuid del pago referenciado en el campo nota
--26/10/17 lt Creación

AS
	SELECT rem.NOTEINDX, uu.uuid
	FROM  dbo.SY03900 AS rem 
		outer apply dbo.fCfdiObtieneUUID(9,ltrim(substring(rem.txtfield,1, 21))) uu
go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: [vwCfdiRelacionado]  '
ELSE PRINT 'Error en la creación de la vista: [vwCfdiRelacionado] '
GO

