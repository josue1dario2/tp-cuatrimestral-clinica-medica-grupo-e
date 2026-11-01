using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI; 
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Auto-inicialización: Si las tablas o procedimientos no existen en la BD local, se crean automáticamente
            InicializadorBD.AsegurarEstructura();
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Exception exc = Server.GetLastError();
            // Session.Add("error", exc.ToString());
            // Server.Transfer("Error.aspx");
        }
    }
}