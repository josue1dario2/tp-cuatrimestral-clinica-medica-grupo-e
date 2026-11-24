using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio; 
using negocio; 

namespace Clinica_Medica_Grupo_e 
{
    public partial class MedicoMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            
            if (Session["Usuario"] == null)
            {
                Session["MensajeLogin"] = "Debés iniciar sesión para acceder al sistema.";

                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Usuario usuario = (Usuario)Session["Usuario"];

           
            if (usuario.TipoUsuario != TipoUsuario.Medico)
            {
                Response.Redirect("~/InicioAdmin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }







            if (!IsPostBack && lblFechaActual != null)
            {
                CultureInfo cultura = new CultureInfo("es-AR");
                lblFechaActual.Text = DateTime.Today.ToString("dddd, d 'de' MMMM", cultura);
            }
        }

        public void MostrarMedico(string nombre, string especialidades)
        {
            if (lblNombreMedico != null)
                lblNombreMedico.Text = nombre;
            if (lblEspecialidadMedico != null)
                lblEspecialidadMedico.Text = especialidades;
        }

        // Cierre de Sesión
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("InicioMedico.aspx", false);
        }
    }
}