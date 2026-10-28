namespace dominio
{
    /// <summary>
    /// Tabla TURNOS_TRABAJO. Las horas se guardan como enteros (8 = 08:00 hs).
    /// </summary>
    public class TurnoTrabajo
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public int HoraEntrada { get; set; }
        public int HoraSalida { get; set; }

        /// <summary>
        /// Ej: "Mañana (08:00 a 14:00 hs)".
        /// </summary>
        public override string ToString()
        {
            return Nombre + " (" + HoraEntrada.ToString("00") + ":00 a " + HoraSalida.ToString("00") + ":00 hs)";
        }
    }
}
