--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdiPagosRelacionados') IS NOT NULL
   DROP FUNCTION dbo.fCfdiPagosRelacionados
GO

create function dbo.fCfdiPagosRelacionados(@p_doctype smallint, @p_docnumbr varchar(21))
returns table
as
--Propósito. Obtiene la relación con otros documentos. 
--		04 sustituye un doc anulado. Puede ser nc, dev, nd, factura
--
--Requisito. Se asume que sustituye otra(s) cobranza(s)
--02/12/19 jcf Creación
--
return(
			--cobros
			SELECT '04' tipoRelacion, uu.uuid, uu.voidstts, uu.FormaPago
			FROM  dbo.vwRmTransaccionesTodas rmTrx
				inner join dbo.SY03900 AS rem 
				on rem.NOTEINDX = rmTrx.NOTEINDX
				cross apply dbo.SplitStrings (rem.txtfield, ';') cobro
				cross apply dbo.fCfdiObtieneUUID(rmTrx.tipoDoc, cobro.item) uu
			where rmTrx.docnumbr = @p_docnumbr
			and rmTrx.RMDTYPAL = @p_doctype
			and @p_doctype = 9

    -- select '04' tipoRelacion, 'aabbdd' uuid
    -- union ALL
    -- select '04' tipoRelacion, 'aabbxxx' uuid
)	
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiPagosRelacionados()'
ELSE PRINT 'Error en la creación de: fCfdiPagosRelacionados()'
GO

--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdiUuidPagosRelacionadosXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdiUuidPagosRelacionadosXML
GO

create function dbo.fCfdiUuidPagosRelacionadosXML(@p_doctype smallint, @p_docnumbr varchar(21))
returns xml 
as
--Propósito. Obtiene la relación con otros pagos en formato XML. 
--02/12/19 jcf Creación
--
begin

	declare @cncp xml;
		WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
		select @cncp = (
			select rf.UUID             '@UUID'
			from dbo.fCfdiPagosRelacionados(@p_doctype, @p_docnumbr) rf
			FOR XML path('cfdi:CfdiRelacionado'), type
		)
	
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiUuidPagosRelacionadosXML()'
ELSE PRINT 'Error en la creación de: fCfdiUuidPagosRelacionadosXML()'
GO

--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdiPagosRelacionadosXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdiPagosRelacionadosXML
GO

create function dbo.fCfdiPagosRelacionadosXML(@p_doctype smallint, @p_docnumbr varchar(21))
returns xml 
as
--Propósito. Obtiene la relación con otros pagos en formato XML. 
--		04 sustituye un doc anulado. Puede ser nc, dev, nd, factura
--02/12/19 jcf Creación
--
begin

	declare @cncp xml;
		WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
		select @cncp = (
			select rf.tipoRelacion 	'@TipoRelacion',
                dbo.fCfdiUuidPagosRelacionadosXML(@p_doctype, @p_docnumbr)
			from dbo.fCfdiPagosRelacionados(@p_doctype, @p_docnumbr) rf
            group by rf.tipoRelacion
			FOR XML path('cfdi:CfdiRelacionados'), type
		)
	
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiPagosRelacionadosXML()'
ELSE PRINT 'Error en la creación de: fCfdiPagosRelacionadosXML()'
GO

--------------------------------------------------------------------------------------------------------

