

		case when ctrl.USERDEF5 != '' 
			then '04'	--sustituye otro cfdi
			else
				case when idDoc = p.param1 then '01'	--nc
					when idDoc = p.param2 then '02'		--nd
					when idDoc = p.param3 then '03'		--devolución
					else null
				end
		end tipoRelacion,
		xml cfdiRelacionado,


parametros('TIPORELACION01', 'TIPORELACION02', 'TIPORELACION03', 'TIPORELACION04')