using System;

namespace dominio
{
    /// Lo que registra el médico al atender un turno (tabla ATENCIONES).
    /// El médico tratante es el del turno (Turno.Medico), por eso no se guarda aparte.
    public class Atencion
    {
        public int Id { get; set; }

        /// Turno atendido. Desde la base se cargan Id, Fecha, Hora y Observaciones (motivo de recepción).
        public Turno Turno { get; set; }

        /// Observaciones y diagnóstico clínico (obligatorio).
        public string Evolucion { get; set; }

        /// Indicaciones, medicación o estudios (opcional).
        public string Prescripcion { get; set; }

        // Signos vitales (opcionales).
        public string TensionArterial { get; set; }   // Ej: "120/80"
        public int? FrecuenciaCardiaca { get; set; }  // lpm
        public int? SaturacionOxigeno { get; set; }   // %
        public decimal? Peso { get; set; }            // kg

        public DateTime FechaRegistro { get; set; }
    }
}
