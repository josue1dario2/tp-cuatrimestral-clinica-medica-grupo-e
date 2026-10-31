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
    public partial class Medico : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["medicoLogueado"] != null)
            {
                dominio.Medico medico = (dominio.Medico)Session["medicoLogueado"];

                if (!IsPostBack && lblNombreMedico != null)
                {
                    lblNombreMedico.Text = medico.Apellido + ", " + medico.Nombre;
                }
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