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

        public string NombreCompleto
        {
            get { return Apellido + ", " + Nombre; }
        }

        public string EspecialidadesTexto
        {
            get
            {
                if (Especialidades != null && Especialidades.Count > 0)
                    return string.Join(", ", Especialidades.Select(e => e.Descripcion));
                return "Sin asignar";
            }
        }

        public int EspecialidadPrincipalId
        {
            get
            {
                if (Especialidades != null && Especialidades.Count > 0)
                    return Especialidades[0].Id;
                return 0;
            }
        }

        public override string ToString()
        {
            return Apellido + ", " + Nombre;
        }
    }
}