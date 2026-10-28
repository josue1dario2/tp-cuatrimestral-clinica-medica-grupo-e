using System;

namespace dominio
{
    /// <summary>
    /// Tabla PACIENTES.
    /// </summary>
    public class Paciente
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Dni { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public bool Activo { get; set; }

        /// <summary>
        /// Ej: "Pérez, Juan".
        /// </summary>
        public string NombreCompleto
        {
            get { return Apellido + ", " + Nombre; }
        }

        /// <summary>
        /// Edad en años cumplidos a la fecha de hoy.
        /// </summary>
        public int Edad
        {
            get
            {
                DateTime hoy = DateTime.Today;
                int edad = hoy.Year - FechaNacimiento.Year;
                if (FechaNacimiento.Date > hoy.AddYears(-edad))
                    edad--;
                return edad;
            }
        }

        public override string ToString()
        {
            return NombreCompleto;
        }
    }
}
