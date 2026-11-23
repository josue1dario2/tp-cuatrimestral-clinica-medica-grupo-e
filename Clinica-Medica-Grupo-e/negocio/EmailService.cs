using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using System.Web.ModelBinding;

namespace negocio
{
    public class EmailService
    {
        private MailMessage email;
        private SmtpClient server;

        public EmailService()
        {
            server = new SmtpClient();
            server.Credentials = new NetworkCredential("f5807a39944f8c", "462e755284e1b0");
            server.EnableSsl = true;
            server.Port = 2525;
            server.Host = "sandbox.smtp.mailtrap.io";
        }

        public void armarCorreo(string emailDestino, string asunto, string cuerpo)
        {
            try
            {
                email = new MailMessage();
                email.From = new MailAddress("noresponder@clinicamedica.com");
                email.To.Add(emailDestino);
                email.Subject = asunto;
                email.IsBodyHtml = true;
                email.Body = cuerpo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            

        }

        public void enviarEmail()
        {
            try
            {
                server.Send(email);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}
