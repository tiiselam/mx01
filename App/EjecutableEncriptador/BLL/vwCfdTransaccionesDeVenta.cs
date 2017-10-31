using System;
using System.Collections.Generic;
using System.Text;

namespace EjecutableEncriptador
{
    class vwCfdTransaccionesDeVenta : vwCfdiTransaccionesDeVenta
    {

        public vwCfdTransaccionesDeVenta(string connstr)
        {
            this.ConnectionString = connstr;
            this.QuerySource = "vwCfdiTransaccionesDeVenta";
            this.MappingName = "vwCfdiTransaccionesDeVenta";
        }

    }
}
