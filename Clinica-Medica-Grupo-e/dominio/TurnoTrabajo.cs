using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class TurnoTrabajo
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public int HoraEntrada { get; set; }
        public int HoraSalida { get; set; }
        public bool Activo { get; set; }

        // Cantidad de médicos activos que tienen asignado este turno (no es una columna: la calcula la consulta).
        public int CantidadMedicos { get; set; }

        // Horas de atención: 8 a 14 = 6 (cada hora es un bloque de turno).
        public int CantidadHoras
        {
            get { return HoraSalida - HoraEntrada; }
        }

        public override string ToString()
        {
            return Nombre;
        }
    }
}
