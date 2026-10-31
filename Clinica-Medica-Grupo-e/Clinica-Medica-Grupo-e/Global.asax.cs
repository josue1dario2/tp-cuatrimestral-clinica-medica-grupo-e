using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI; 
namespace Clinica_Medica_Grupo_e
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Opcional: Aquí el profesor inicializa el mapeo de jQuery para validaciones web.
            // Si no usas validadores de control de ASP.NET, puedes dejarlo vacío.
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Exception exc = Server.GetLastError();
            // Session.Add("error", exc.ToString());
            // Server.Transfer("Error.aspx");
        }
    }
}