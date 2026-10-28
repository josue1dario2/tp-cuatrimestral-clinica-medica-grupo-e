using System.Collections.Generic;

namespace dominio
{
    /// <summary>
    /// Tabla MEDICOS. La tabla intermedia MEDICOS_ESPECIALIDADES
    /// se representa con la lista Especialidades.
    /// </summary>
    public class Medico
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Matricula { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public TurnoTrabajo TurnoTrabajo { get; set; }

        /// <summary>
        /// Puede ser null: no todos los médicos tienen usuario para ingresar al sistema.
        /// </summary>
        public Usuario Usuario { get; set; }

        public List<Especialidad> Especialidades { get; set; }
        public bool Activo { get; set; }

        public Medico()
        {
            Especialidades = new List<Especialidad>();
        }

        /// <summary>
        /// Ej: "House, Gregory".
        /// </summary>
        public string NombreCompleto
        {
            get { return Apellido + ", " + Nombre; }
        }

        public override string ToString()
        {
            return NombreCompleto;
        }
    }
}
