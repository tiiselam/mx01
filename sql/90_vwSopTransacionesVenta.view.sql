IF OBJECT_ID ('dbo.vwSopTransaccionesVenta') IS NOT NULL
   DROP view vwSopTransaccionesVenta
GO

create view dbo.vwSopTransaccionesVenta
--Propósito. Obtiene las transacciones de venta SOP. 
--Utiliza:	vwRmTransaccionesTodas
--Requisitos. No muestra facturas registradas en cuentas por cobrar. 
--23/04/12 JCF Modificaciones CFDI v3.2
--11/05/12 jcf Ajusta descuento, debe ser comercial y por línea. 
--			Ajusta subtotal, debe ser antes de descuentos e impuestos.
--12/06/12 jcf Agrega userdef2
--02/07/12 jcf Cambia el modo de obtener datos adicionales para la factura. 
--			Usa la función fCfdDatosAdicionales() para obtener los datos correctos.
--09/11/12 JCF xchgrate debe ser mayor que cero
--23/11/12 jcf Retira los milisegundos del campo fechaHora
--27/08/13 jcf Agrega campo cstponbr 
--12/07/16 jcf Modifica método de pago predeterminado a NA
--22/03/17 jcf Modifica curncyid por isocurrc
--
AS

SELECT	'contabilizado' estadoContabilizado,
		case when cn.TXRGNNUM = '' 
			then rtrim(dbo.fCfdReemplazaCaracteresNI(replace(cab.custnmbr, '-', '')))
			else rtrim(dbo.fCfdReemplazaCaracteresNI(rtrim(left(replace(cn.TXRGNNUM, '-', ''), 23))))	--loc argentina usa los 23 caracteres de la izquierda
		end idImpuestoCliente,
		cab.CUSTNMBR,
		dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(cab.CUSTNAME))), 10)	nombreCliente,
		rtrim(cab.docid) docid, cab.SOPTYPE, 
		rtrim(cab.sopnumbe) sopnumbe, 
		cab.docdate, 
		CONVERT(datetime, 
				replace(convert(varchar(20), cab.DOCDATE, 102), '.', '-')+'T'+
				case when substring(cab.DOCNCORR, 3, 1) = ':' then rtrim(LEFT(cab.docncorr, 8)) --+'.'+ right(rtrim(cab.docncorr), 3) 
				else '00:00:00' end,
				126) fechaHora,
		cast(cab.ORDOCAMT as numeric(19,6)) total,														--se requieren 6 decimales fijos para generar el código de barras
		cab.ORSUBTOT + cab.ORMRKDAM subtotal, 
		cab.ORTAXAMT impuesto, cab.ORMRKDAM, cab.ORTDISAM, cab.ORMRKDAM + cab.ORTDISAM descuento, 
--		cab.docamnt total, cab.SUBTOTAL subtotal, cab.TAXAMNT impuesto, cab.trdisamt descuento,
		cab.orpmtrvd, rtrim(mo.isocurrc) curncyid, 
		case when cab.xchgrate <= 0 then 1 else cab.xchgrate end xchgrate, 
		cab.voidStts + isnull(rmx.voidstts, 0) voidstts, 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.address1), 10)) address1, 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.address2), 10)) address2, 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.address3), 10)) address3, 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.city), 10)) city, 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.[STATE]), 10)) [state], 
		dbo.fCfdEsVacio(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.country), 10)) country, 
		right('00000'+dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.zipcode), 10), 5) zipcode, 
		cab.duedate, cab.pymtrmid, cab.glpostdt, 
		isnull(da.nroOrden, '') nroOrden,
		isnull(da.NumCtaPago , 'no identificado') NumCtaPago,
		'Pago en una sola exhibición' formaDePago,
		isnull(da.metodoDePago, 'NA') metodoDePago,
		dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(cab.cstponbr), 10) cstponbr
  from	sop30200 cab							--sop_hdr_hist
		inner join vwCfdIdDocumentos id
			on id.docid = cab.DOCID
        left outer join RM00101 cn				--rm_customer_mstr
			on cn.CUSTNMBR = cab.CUSTNMBR
		left outer join vwRmTransaccionesTodas rmx
             ON rmx.RMDTYPAL in (1, 8)			-- 1 invoice, 8 return
            and rmx.bchsourc = 'Sales Entry'	-- incluye sop
            and (cab.sopType-2 = rmx.rmdTypAl or cab.sopType+4 = rmx.rmdTypAl) --elimina la posibilidad de repetidos
            and cab.sopnumbe = rmx.DOCNUMBR
		OUTER APPLY dbo.fCfdDatosAdicionales(cab.orpmtrvd, cab.soptype, cab.sopnumbe, cab.custnmbr, cab.prbtadcd) da
		left outer join dynamics..mc40200 mo
			on mo.CURNCYID = cab.curncyid
 where cab.soptype in (3, 4)					--3 invoice, 4 return
 union all
 select 'en lote' estadoContabilizado, cab.custnmbr idImpuestoCliente, cab.CUSTNMBR, cab.CUSTNAME nombreCliente,
		rtrim(cab.docid) docid, cab.SOPTYPE, rtrim(cab.sopnumbe) sopnumbe, 
		cab.docdate, cab.docdate fechaHora,
		cab.ORDOCAMT total, cab.ORSUBTOT subtotal, cab.ORTAXAMT impuesto, 0, cab.ORTDISAM, cab.ORTDISAM descuento, 
--		cab.docamnt total, cab.SUBTOTAL subtotal, cab.TAXAMNT impuesto, cab.trdisamt descuento,
		cab.orpmtrvd, rtrim(cab.curncyid) curncyid, 
		cab.xchgrate, 
		cab.voidStts, cab.address1, cab.address2, cab.address3, cab.city, cab.[STATE], cab.country, cab.zipcode, 
		cab.duedate, cab.pymtrmid, cab.glpostdt, 
		ctrl.USERDEF1, ctrl.userdef2,
		'Pago en una sola exhibición' formaDePago,
		isnull(ctrl.usrtab01, 'NA') metodoDePago,
		cab.cstponbr
 from  SOP10100 cab								--sop_hdr_work
		inner join vwCfdIdDocumentos id
			on id.docid = cab.DOCID
        left outer join SOP10106 ctrl			--campos def. por el usuario.
            on ctrl.SOPTYPE = cab.SOPTYPE
            and ctrl.SOPNUMBE = cab.SOPNUMBE
 where cab.SOPTYPE in (3, 4)					--3 invoice, 4 return
go

IF (@@Error = 0) PRINT 'Creación exitosa de: vwSopTransaccionesVenta'
ELSE PRINT 'Error en la creación de: vwSopTransaccionesVenta'
GO

-------------------------------------------------------------------------------------------------------
--select isocurrc, curncyid, *
--from dynamics..mc40200
--use dynamics;
