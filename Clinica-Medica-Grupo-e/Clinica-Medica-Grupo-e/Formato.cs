using System;
using System.Globalization;

namespace Clinica_Medica_Grupo_e
{
    /// Formatos de texto que se repiten en varias páginas.
    public static class Formato
    {
        public static readonly CultureInfo Cultura = new CultureInfo("es-AR");


        public static string Dni(string dni)
        {
            long numero;
            return long.TryParse(dni, out numero) ? numero.ToString("#,0", Cultura) : dni;
        }

        /// "21/11/2026" -> "Sáb, 21 de nov de 2026".
        /// Si el texto no respeta dd/MM/yyyy, lo devuelve tal cual (no lanza excepción).
        public static string Fecha(string textoFecha)
        {
            DateTime fecha;

            if (!DateTime.TryParseExact(
                    textoFecha,
                    "dd/MM/yyyy",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out fecha))
            {
                return textoFecha;
            }

            return Fecha(fecha);
        }

        /// new DateTime(2026, 11, 21) -> "Sáb, 21 de nov de 2026".
        public static string Fecha(DateTime fecha)
        {
            string raw = fecha.ToString("dd 'de' MMM 'de' yyyy", Cultura);

            // Quitar los puntos de las abreviaturas ("sáb." -> "sáb", "nov." -> "nov")
            string sinPuntos = raw.Replace(".", "");

            if (sinPuntos.Length == 0)
            {
                return sinPuntos;
            }

            // Capitalizar solo la primera letra: "Sáb, 21 de nov de 2026"
            return char.ToUpper(sinPuntos[0], Cultura) + sinPuntos.Substring(1);
        }
    }
}