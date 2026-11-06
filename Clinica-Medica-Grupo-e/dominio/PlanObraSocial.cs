using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class PlanObraSocial
    {
        public int IdPlan { get; set; }
        public int IdObraSocial { get; set; }
        public string NombrePlan { get; set; }
        public bool Activo { get; set; }

        public override string ToString()
        {
            return NombrePlan;
        }
    }
}

