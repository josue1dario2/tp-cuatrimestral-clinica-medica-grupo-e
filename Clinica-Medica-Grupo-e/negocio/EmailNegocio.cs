using dominio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class EmailNegocio
    {
        private string dirEmail = "admin@clinicamedica.com";
        private string asuntoEmail;

        public EmailNegocio()
        {
        }

        public EmailNegocio(String asuntoEmail)
        {
            this.asuntoEmail = ObtenerAsunto(asuntoEmail);
        }

        private string ObtenerAsunto(string motivo)
        {
            switch (motivo)
            {
                case "Confirmacion":
                    return "Nuevo turno en Clinica Médica";

                case "Cancelacion":
                    return "Cancelación de turno";

                case "Recordatorio":
                    return "Recordatorio de turno";

                case "Reprogramacion":
                    return "Reprogramación de turno";

                default:
                    throw new ArgumentException("Motivo no válido.");
            }
        }

        public string EnviarCorreoPaciente(Paciente paciente, MotivoNotificacionPaciente motivo)
        {
            if (string.IsNullOrWhiteSpace(paciente.Email))
                return string.Empty;   // Sin correo, no hay a quién avisar

            PlantillaUsuarioNegocio plantilla = new PlantillaUsuarioNegocio(motivo, paciente);
            string cuerpo = plantilla.ProcesarPlantilla();

            EmailService email = new EmailService();
            email.armarCorreo(paciente.Email, plantilla.ObtenerAsunto(), cuerpo);
            email.enviarEmail();
            return paciente.Email;
        }

        public string EnviarCorreo(Turno turno, string asuntoEmail)
        {
            string resultado = string.Empty;
            EmailService email = new EmailService();
            try
            {
                PlantillasNegocio plNegocio = new PlantillasNegocio(asuntoEmail, turno);
                string cuerpo = plNegocio.ProcesarPlantilla();
                dirEmail = turno.Paciente.Email == null ? dirEmail : turno.Paciente.Email;
                if (cuerpo != null)
                {
                    email.armarCorreo(dirEmail, this.asuntoEmail, cuerpo);
                    email.enviarEmail();
                    resultado = dirEmail;

                }

            }
            catch (Exception ex)
            {

                throw ex;
            }

            return resultado;

        }


    }
}
