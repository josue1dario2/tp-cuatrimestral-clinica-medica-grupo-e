using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio; 
using negocio; 

namespace vista 
{
    public partial class Medico : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Control de Seguridad Centralizado (Idéntico a Master.Master.cs del profesor)
            // Asumiendo que las páginas públicas son Login y Error.
            if (!(Page is Login || Page is Error))
            {
                // Validación de sesión activa (reemplaza a tu inseguro QueryString)
                if (Session["medicoLogueado"] == null)
                {
                    Response.Redirect("Login.aspx", false);
                }
                else
                {
                    // 2. Carga de datos del médico desde la memoria segura del servidor
                    dominio.Medico medico = (dominio.Medico)Session["medicoLogueado"];

                    // Solo actualizamos la UI si no es un PostBack para ahorrar procesamiento
                    if (!IsPostBack)
                    {
                        lblNombreMedico.Text = medico.Apellido + ", " + medico.Nombre;

                        // Si guardas la especialidad principal en la entidad, asígnala aquí:
                        // lblEspecialidadMedico.Text = medico.Especialidades[0].Descripcion;
                    }
                }
            }

            // 3. Renderizado de fecha y controles estáticos
            if (!IsPostBack)
            {
                CultureInfo cultura = new CultureInfo("es-AR");
                lblFechaActual.Text = DateTime.Today.ToString("dddd, d 'de' MMMM", cultura);
            }
        }

        // 4. Implementación obligatoria del Cierre de Sesión
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); // Limpia toda la memoria de sesión del servidor
            Response.Redirect("Login.aspx", false); // Expulsa al login
        }
    }
}