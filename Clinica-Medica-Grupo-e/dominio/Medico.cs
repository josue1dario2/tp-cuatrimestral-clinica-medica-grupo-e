using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Medico
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Matricula { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public TurnoTrabajo TurnoTrabajo { get; set; }
        public Usuario Usuario { get; set; }
        public List<Especialidad> Especialidades { get; set; }
        public bool Activo { get; set; }

        public override string ToString()
        {
            return Apellido + ", " + Nombre;
        }
    }
}