using System;

namespace dominio
{
    /// <summary>
    /// Tabla TURNOS. Hora se guarda como entero (10 = bloque de 10:00 a 11:00).
    /// </summary>
    public class Turno
    {
        public int Id { get; set; }
        public int NumeroTurno { get; set; }
        public DateTime Fecha { get; set; }
        public int Hora { get; set; }
        public Paciente Paciente { get; set; }
        public Medico Medico { get; set; }
        public Especialidad Especialidad { get; set; }
        public string Observaciones { get; set; }
        public EstadoTurno Estado { get; set; }

        public Turno()
        {
            Estado = EstadoTurno.Nuevo;
        }

        /// <summary>
        /// Ej: "10:00 hs".
        /// </summary>
        public string HoraTexto
        {
            get { return Hora.ToString("00") + ":00 hs"; }
        }

        /// <summary>
        /// Fecha y hora juntas, útil para comparar o mostrar.
        /// </summary>
        public DateTime FechaHora
        {
            get { return Fecha.Date.AddHours(Hora); }
        }
    }
}
