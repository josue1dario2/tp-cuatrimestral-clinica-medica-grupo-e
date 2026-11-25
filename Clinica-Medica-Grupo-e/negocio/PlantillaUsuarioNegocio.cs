using dominio;
using System;
using System.Globalization;
using System.IO;
using System.Web;

namespace negocio
{
    internal class PlantillaUsuarioNegocio
    {
        private string urlPlantilla = "~/Plantillas/AltaPaciente.html";
        private MotivoNotificacionPaciente motivoPlantilla;
        private string plantillaCorreo;
        private Paciente pacientePlantilla;

        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        public PlantillaUsuarioNegocio(MotivoNotificacionPaciente motivo, Paciente paciente)
        {
            this.motivoPlantilla = motivo;
            this.pacientePlantilla = paciente;
            this.plantillaCorreo = File.ReadAllText(HttpContext.Current.Server.MapPath(urlPlantilla));
        }

        // El asunto depende del motivo: EmailNegocio lo pide desde acá.
        public string ObtenerAsunto()
        {
            switch (motivoPlantilla)
            {
                case MotivoNotificacionPaciente.Alta: return "Bienvenido/a a Clínica Médica";
                case MotivoNotificacionPaciente.Modificacion: return "Actualización de sus datos - Clínica Médica";
                case MotivoNotificacionPaciente.Baja: return "Baja de su registro - Clínica Médica";
                default: throw new ArgumentException("Motivo no válido.");
            }
        }

        private string QuitarBloque(string html, string nombre)
        {
            string inicio = "<!--INICIO_" + nombre + "-->";
            string fin = "<!--FIN_" + nombre + "-->";
            int i = html.IndexOf(inicio);
            int f = html.IndexOf(fin);
            if (i < 0 || f < 0) return html;
            return html.Remove(i, f + fin.Length - i);
        }

        // Quita los bloques que no corresponden al motivo.
        private void preProcesamiento()
        {
            if (motivoPlantilla == MotivoNotificacionPaciente.Baja)
            {
                plantillaCorreo = QuitarBloque(plantillaCorreo, "DATOS");
                plantillaCorreo = QuitarBloque(plantillaCorreo, "AVISO_DATOS");
            }
            else
            {
                plantillaCorreo = QuitarBloque(plantillaCorreo, "AVISO_BAJA");
            }
        }

        private void reemplazarVariables()
        {
            string motivo;
            string mensaje;
            switch (motivoPlantilla)
            {
                case MotivoNotificacionPaciente.Alta:
                    motivo = "Alta de paciente";
                    mensaje = "Usted recibe este correo porque fue registrado/a como paciente de Clínica Médica. "
                            + "A partir de ahora puede solicitar turnos con nuestros profesionales.";
                    break;
                case MotivoNotificacionPaciente.Modificacion:
                    motivo = "Modificación de datos";
                    mensaje = "Le informamos que se actualizaron sus datos como paciente de Clínica Médica.";
                    break;
                case MotivoNotificacionPaciente.Baja:
                    motivo = "Baja del sistema";
                    mensaje = "Le informamos que su registro como paciente de Clínica Médica fue dado de baja. "
                            + "Ya no podrá solicitar turnos con nuestros profesionales.";
                    break;
                default:
                    throw new ArgumentException("Motivo no válido.");
            }

            plantillaCorreo = plantillaCorreo.Replace("{{MOTIVO_NOTIFICACION}}", motivo);
            plantillaCorreo = plantillaCorreo.Replace("{{MENSAJE}}", mensaje);

            // Datos que cargó el usuario: siempre con HtmlEncode.
            plantillaCorreo = plantillaCorreo.Replace("{{NOMBRE}}", HttpUtility.HtmlEncode(pacientePlantilla.Nombre));
            plantillaCorreo = plantillaCorreo.Replace("{{APELLIDO}}", HttpUtility.HtmlEncode(pacientePlantilla.Apellido));
            plantillaCorreo = plantillaCorreo.Replace("{{DNI}}", HttpUtility.HtmlEncode(pacientePlantilla.Dni));
            plantillaCorreo = plantillaCorreo.Replace("{{EMAIL}}", HttpUtility.HtmlEncode(pacientePlantilla.Email));
            plantillaCorreo = plantillaCorreo.Replace("{{TELEFONO}}", ValorOpcional(pacientePlantilla.Telefono, "No informado"));
            plantillaCorreo = plantillaCorreo.Replace("{{DIRECCION}}", ValorOpcional(pacientePlantilla.Direccion, "No informada"));
            plantillaCorreo = plantillaCorreo.Replace("{{FECHA_NACIMIENTO}}",
                pacientePlantilla.FechaNacimiento.ToString("dd/MM/yyyy", Cultura));
        }

        private string ValorOpcional(string valor, string siVacio)
        {
            return string.IsNullOrWhiteSpace(valor) ? siVacio : HttpUtility.HtmlEncode(valor);
        }

        public string ProcesarPlantilla()
        {
            preProcesamiento();
            reemplazarVariables();
            return plantillaCorreo;
        }
    }
}