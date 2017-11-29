IF OBJECT_ID ('dbo.fCfdiFormaPagoSimultaneo') IS NOT NULL
   DROP FUNCTION dbo.fCfdiFormaPagoSimultaneo
GO

create function dbo.fCfdiFormaPagoSimultaneo(@chekbkid varchar(15), @pymttype smallint, @cardname varchar(15))
returns table
--Prop�sito. Obtiene la forma de pago de un cobro simult�neo con la factura.
--24/10/17 jcf Creaci�n
--
as
return(
	select cm.chekbkid, 
		case when left(UPPER(cm.locatnid), 2) = 'CB' then	--ch representa una cuenta bancaria
 			case @pymttype 
 				when 4 then '03'				--transf. electr�nica
 				when 5 then '02'				--cheque
 				when 6 then left(@cardname,2)	--tarjeta
				else null 
			end
			else									--representa un medio de pago
 				left(Rtrim(cm.locatnid), 2)
		end	FormaPago
	from CM00100 cm
	where cm.chekbkid = @chekbkid
)
go
IF (@@Error = 0) PRINT 'Creaci�n exitosa de: fCfdiFormaPagoSimultaneo()'
ELSE PRINT 'Error en la creaci�n de: fCfdiFormaPagoSimultaneo()'
GO
--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdiFormaPagoManual') IS NOT NULL
   DROP FUNCTION dbo.fCfdiFormaPagoManual
GO

create function dbo.fCfdiFormaPagoManual(@chekbkid varchar(15), @CSHRCTYP smallint, @FRTSCHID varchar(15))
returns table
--Prop�sito. Obtiene la forma de pago de un recibo de cobro
--24/10/17 jcf Creaci�n
--
as
return(
	select cm.chekbkid, 
			case when left(UPPER(cm.locatnid), 2) = 'CB' then	--ch representa una cuenta bancaria
 				case @CSHRCTYP  
 					when 0 then '02'					--cheque
 					when 1 then '03'					--transf. electr�nica
 					when 2 then left(@FRTSCHID,2)
					else null 
				end
				else									--representa un medio de pago
 					left(Rtrim(cm.locatnid), 2)
			end	FormaPago	
	from CM00100 cm
	where cm.chekbkid = @chekbkid
)
go
IF (@@Error = 0) PRINT 'Creaci�n exitosa de: fCfdiFormaPagoManual()'
ELSE PRINT 'Error en la creaci�n de: fCfdiFormaPagoManual()'
GO
--------------------------------------------------------------------------------------------------------

