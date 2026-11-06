using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class ObraSocial
    {
        public int IdObraSocial { get; set; }
        public string Nombre { get; set; }
        public string Sigla { get; set; }
        public bool Activo { get; set; }

        public override string ToString()
        {
            return Nombre;
        }
    }
}

