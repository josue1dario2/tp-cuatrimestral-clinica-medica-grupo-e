using dominio;
using dominio;
using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace negocio
{
    internal class PlantillaUsuarioNegocio
    {
        private string urlPlantilla = "~/Plantillas/NotificacionTurno.html";
        private string motivoPlantilla;
        private string plantillaCorreo;
        private Turno turnoPlantilla;

        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");
        public PlantillaUsuarioNegocio(string motivo, Turno turno)
        {
            this.motivoPlantilla = motivo;
            this.turnoPlantilla = turno;
            this.plantillaCorreo = File.ReadAllText(HttpContext.Current.Server.MapPath(urlPlantilla));
            //this.plantillaCorreo = File.ReadAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Plantillas", nombrePlantilla));

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
        private string preProcesamiento()
        {
            plantillaCorreo = QuitarBloque(plantillaCorreo, "ANTERIOR");
            //}
            //else if (motivoPlantilla == "Reprogramacion")
            //{
            //    plantillaCorreo = QuitarBloque(plantillaCorreo, "Fecha");
            //}
            return plantillaCorreo;
        }

        private void reemplazarVariables()
        {
            string color;
            switch (motivoPlantilla)
            {
                case "Administrador": color = "#C62828"; break;
                case "Recepcionista": color = "#B45309"; break;
                case "Médico": color = "#1D4ED8"; break;
                default: color = "#0E7C86"; break;   // turno nuevo
            }
            plantillaCorreo = plantillaCorreo.Replace("{{COLOR}}", color);

            plantillaCorreo = plantillaCorreo.Replace("{{MOTIVO_CORREO}}", motivoPlantilla);
            plantillaCorreo = plantillaCorreo.Replace("{{TITULO}}", "Notificación automática");
            plantillaCorreo = plantillaCorreo.Replace("{{MENSAJE}}", "Mensaje importante sobre su turno");
            plantillaCorreo = plantillaCorreo.Replace("{{NUMERO_TURNO}}", HttpUtility.HtmlEncode(turnoPlantilla.NumeroTurno));
            plantillaCorreo = plantillaCorreo.Replace("{{PACIENTE_NOMBRE}}", HttpUtility.HtmlEncode(turnoPlantilla.Paciente.Nombre));
            plantillaCorreo = plantillaCorreo.Replace("{{PACIENTE_APELLIDO}}", HttpUtility.HtmlEncode(turnoPlantilla.Paciente.Apellido));
            plantillaCorreo = plantillaCorreo.Replace("{{PACIENTE_DNI}}", HttpUtility.HtmlEncode(turnoPlantilla.Paciente.Dni));
            plantillaCorreo = plantillaCorreo.Replace("{{MEDICO_NOMBRE}}", HttpUtility.HtmlEncode(turnoPlantilla.Medico.Nombre));
            plantillaCorreo = plantillaCorreo.Replace("{{MEDICO_APELLIDO}}", HttpUtility.HtmlEncode(turnoPlantilla.Medico.Apellido));
            plantillaCorreo = plantillaCorreo.Replace("{{MEDICO_ESPECIALIDAD}}", HttpUtility.HtmlEncode(turnoPlantilla.Especialidad.Descripcion));
            plantillaCorreo = plantillaCorreo.Replace("{{MEDICO_MATRICULA}}", HttpUtility.HtmlEncode(turnoPlantilla.Medico.Matricula));



            string fecha = turnoPlantilla.Fecha.ToString("dddd d 'de' MMMM 'de' yyyy", Cultura);
            fecha = char.ToUpper(fecha[0]) + fecha.Substring(1);
            plantillaCorreo = plantillaCorreo.Replace("{{FECHA}}", fecha);
            plantillaCorreo = plantillaCorreo.Replace("{{HORA}}", HttpUtility.HtmlEncode(turnoPlantilla.HoraTexto));
            plantillaCorreo = plantillaCorreo.Replace("{{MOTIVO}}", HttpUtility.HtmlEncode(turnoPlantilla.Observaciones));

        }

        public string ProcesarPlantilla()
        {
            preProcesamiento();
            reemplazarVariables();
            return plantillaCorreo;
        }
    }
}
