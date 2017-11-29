IF not EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.nfmcp20100') AND OBJECTPROPERTY(id,N'IsTable') = 1)
begin
	create table dbo.nfmcp20100
	(
	medioid		varchar(15) NOT NULL default 'NA',
	numberie 	varchar(21) NOT NULL default '',
	lineamnt int NOT NULL default 0,
	) on [PRIMARY];
end

-----------------------------------------------------------------------------------------------------------------------------
IF not EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.nfmcp00700') AND OBJECTPROPERTY(id,N'IsTable') = 1)
begin
	create table dbo.nfmcp00700
	(
	grupid		varchar(21) NOT NULL default 'NA',
	medioid 	varchar(15) NOT NULL default ''
	) on [PRIMARY];
end

-----------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdiMcpFormaPago') IS NOT NULL
   DROP FUNCTION dbo.fCfdiMcpFormaPago
GO

create function dbo.fCfdiMcpFormaPago(@DOCNUMBR varchar(21))
returns table
--Propósito. Obtiene la forma de pago de MCP
--10/11/17 jcf Creación
--
as
return(
	select top (1) mcpd.grupid
	from  nfmcp20100 mcpfp 
 	left join nfmcp00700 mcpd 
		on mcpd.medioid=mcpfp.medioid
	where mcpfp.numberie = @DOCNUMBR
	order by mcpfp.lineamnt desc
)

go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiMcpFormaPago()'
ELSE PRINT 'Error en la creación de: fCfdiMcpFormaPago()'
GO
--------------------------------------------------------------------------------------------------------

