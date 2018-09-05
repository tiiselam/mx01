--x

select top 1000 *
from vwCfdiTrxCobros
where sopnumbe like '%PYMNT0000010%'

select *
from [dbo].fCfdiDocumentoDePago (9, 'PYMNT00000107')

select [dbo].[fCfdiDocumentoDePagoXML] (9, 'PYMNT00000107')

select [dbo].fCfdiDocumentoDePagoXMLPago (9, 'PYMNT00000108')

select dbo.fCfdiConceptosXML(3, '00000693', 4924.00000, 0, '')

select *
from [vwCfdiRMFacturas]
where docnumbr = 'PYMNT00000122'

select *
from vwCfdiRmTrxAplicadas
where apfrdcnm = 'RECCOB00000466'


select *
from vwRmTransaccionesTodas
where docnumbr = 'RECCOB00000466'


select *
from vwRmTransaccionesTodas
where docnumbr = '00000838                                 '
rmdtypal != 1
and month(docdate) = 11


select *
from cfdlogfacturaxml
where soptype = 9

select *
from [vwRmImprimeCobros]
where sopnumbe = ''

select *
from SOP10106
where sopnumbe like '%233'


----------------------------------------------------------------------
--VENTAS
use mex10;

select *
--update s set tracking_number = '00000838'
from sop10107 s
where s.sopnumbe like '00001057'

select dbo.fCfdiGeneraDocumentoDeVentaXML (3, '00000682')
select tx.TXDTLPCT, *--@existeImpuestos = sum(tx.TXDTLPCT)
							from sop10105 imp	--sop_tax_work_hist
							inner join tx00201 tx
								on tx.taxdtlid = imp.taxdtlid
 							where imp.SOPTYPE = 3
							  and imp.SOPNUMBE = '00001792'
							  --and imp.LNITMSEQ = @p_LNITMSEQ
							  and tx.TXDTLPCT >= 0

select top 100 *
from vwCfdiTransaccionesDeVenta s
where year(fechahora) = 2018
and month(fechahora) = 5


SELECT *
FROM dbo.fCfdiPagoSimultaneoMayor(3, '00000682') pg

SELECT *
	from CM00100 cm
WHERE CHEKBKID = 'BAMERICA-MXN   '

	select top (1) cm.FormaPago
select *
	from sop10103 py
	where sopnumbe = '00000694'

	outer apply dbo.fCfdiFormaPagoSimultaneo(py.chekbkid, py.pymttype, py.cardname) cm

select docncorr,replace(docncorr, '09:', '18:'), *
--update s set docncorr = replace(docncorr, '09:', '18:')	-- ITEMDESC = 'Contratacion del servicio de banco de imagenes correspondiente al mes de Diciembre 2017'
from sop30200 s
where datediff(day, '4/11/18', docdate) >= 0

s.sopnumbe in ( '00001419', '00001420', '00001421', '00001422', '00001423')
and soptype = 3

select *
from sop10202
WHERE SOPNUMBE = '00000693             '

select *
from sop30300
WHERE SOPNUMBE = '00000693             '

SP_COLUMNS SOP10202

sp_statistics sop10202



declare @chekbkid varchar(15), @pymttype smallint, @cardname varchar(15)
select @pymttype = 5, @chekbkid = 'BAMERICA-MXN', @cardname = '01'

	select cm.chekbkid, 
		case when left(UPPER(cm.locatnid), 2) = 'CB' then	--ch representa una cuenta bancaria
 			case @pymttype 
 				when 4 then '03'				--transf. electrónica
 				when 5 then '02'				--cheque
 				when 6 then left(@cardname,2)	--tarjeta
				else null 
			end
			else									--representa un medio de pago
 				left(Rtrim(cm.locatnid), 2)
		end	FormaPago
	from CM00100 cm
	where cm.chekbkid = @chekbkid
	union all
	select top(1) @chekbkid,  case @pymttype 
 				when 6 then left(@cardname,2)	--tarjeta
				else null 
			end
	from CM00100 cm
	where @chekbkid = ''

