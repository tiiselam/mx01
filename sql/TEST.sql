--cobros

select top 1000 *
from vwCfdiTrxCobros
where sopnumbe like '%466'

select [dbo].[fCfdiDocumentoDePagoXML] (9, 'PYMNT00000090')

select [dbo].fCfdiDocumentoDePagoXMLPago (9, 'PYMNT00000122')

select dbo.fCfdiConceptosXML(3, '00000840', 10)


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
where sopnumbe like '00000878'


----------------------------------------------------------------------
--VENTAS

select *
--update s set tracking_number = '00000838'
from sop10107 s
where s.sopnumbe like '00000878'

select *
from vwCfdiTransaccionesDeVenta s
where s.sopnumbe like '4001910'



select *
--update s set ITEMDESC = 'Contratacion del servicio de banco de imagenes correspondiente al mes de Diciembre 2017'
from sop30200 s
where s.sopnumbe = '00000882'

select stuff(stuff(stuff(dbo.fCfdReemplazaSecuenciaDeEspacios(rtrim('111015544'), 10)
												, 3, 0, '  '), 7, 0, '  '), 13, 0, '  ')
