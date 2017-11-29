
select [dbo].[fCfdiDocumentoDePagoXML] (9, 'PYMNT00000090')

select [dbo].fCfdiDocumentoDePagoXMLPago (9, 'PYMNT00000122')


select *
from [vwCfdiRMFacturas]
where docnumbr = 'PYMNT00000122'

select *
from vwCfdiRmTrxAplicadas
where apfrdcnm = 'PYMNT00000085        '


select *
from vwRmTransaccionesTodas
where docnumbr = 'PYMNT00000085        '

select *
from vwRmTransaccionesTodas
where rmdtypal != 1
and month(docdate) = 11


select *
from cfdlogfacturaxml
where soptype = 9

select *
from [vwRmImprimeCobros]
where sopnumbe = ''
