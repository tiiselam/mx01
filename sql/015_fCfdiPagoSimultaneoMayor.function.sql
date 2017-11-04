IF OBJECT_ID ('dbo.fCfdiPagoSimultaneoMayor') IS NOT NULL
   DROP FUNCTION dbo.fCfdiPagoSimultaneoMayor
GO

create function dbo.fCfdiPagoSimultaneoMayor(@soptype smallint, @sopnumbe varchar(21))
returns table
--Propósito. Obtiene la forma de pago del pago más grande. Este pago ha sido ingresado simultáneamente con la factura.
--24/10/17 jcf Creación
--
as
return(
	select top (1) 
		case when py.pymttype = 5 then '02'					--02 cheque
			when py.pymttype = 4 then						--efectivo
				case when cm.cmusrdf1 = '' then '03'		--03 transferencia
					else rtrim(cm.cmusrdf1)					--?
				end
			when py.pymttype = 6 then left(py.cardname, 2)	--tarjeta
			else '99'										--por definir
		end FormaPago
	from sop10103 py
		left join CM00100 cm
			on cm.chekbkid = py.chekbkid
	where py.soptype = @soptype
	and py.sopnumbe = @sopnumbe
	order by py.oamtpaid desc
)

go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiPagoSimultaneoMayor()'
ELSE PRINT 'Error en la creación de: fCfdiPagoSimultaneoMayor()'
GO
--------------------------------------------------------------------------------------------------------

