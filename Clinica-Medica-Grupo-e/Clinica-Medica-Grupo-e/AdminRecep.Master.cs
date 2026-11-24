using dominio;
using negocio;
using System;
using System.Globalization;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class AdminRecep : MasterPage
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

            
            if (usuario.TipoUsuario != TipoUsuario.Admin &&
                usuario.TipoUsuario != TipoUsuario.Recepcionista)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

           
            lblFechaHoy.Text = "Hoy, " + DateTime.Today.ToString("d 'de' MMMM yyyy", new CultureInfo("es-AR"));

            lblNombreUsuario.Text = usuario.NombreUsuario;
            lblRolUsuario.Text = usuario.TipoUsuario.ToString();

            
            phMenuAdministracion.Visible = usuario.TipoUsuario == TipoUsuario.Admin;

            MarcarLinkActivo();
        }

        
        /// Marca como "active" el link del menú que corresponde a la página actual.
        
        private void MarcarLinkActivo()
        {
            string paginaActual = Path.GetFileName(Request.Path);
            if (string.IsNullOrEmpty(paginaActual))
                return;

            HyperLink[] links =
            {
                lnkNavInicio, lnkNavTurnos, lnkNavNuevoTurno, lnkNavPacientes, lnkNavMedicos,
                lnkNavEspecialidades, lnkNavTurnosTrabajo, lnkNavUsuarios, lnkNavEstadisticas,lnkNavObrasSociales
            };

            foreach (HyperLink link in links)
            {
                link.CssClass = "nav-item-custom";
            }

            if (paginaActual.IndexOf("Especialidad", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                lnkNavEspecialidades.CssClass = "nav-item-custom active";
                return;
            }

            if (paginaActual.IndexOf("Medico", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                lnkNavMedicos.CssClass = "nav-item-custom active";
                return;
            }

            if (paginaActual.IndexOf("Paciente", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                lnkNavPacientes.CssClass = "nav-item-custom active";
                return;
            }

            foreach (HyperLink link in links)
            {
                string paginaLink = Path.GetFileName(link.NavigateUrl);
                if (string.Equals(paginaLink, paginaActual, StringComparison.OrdinalIgnoreCase))
                {
                    link.CssClass = "nav-item-custom active";
                    break;
                }
            }
        }

        protected void btnBuscarGlobal_Click(object sender, EventArgs e)
        {
            // TODO: buscar turno / paciente por DNI con txtBuscarGlobal.Text.
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            if (Session["Usuario"] != null)
            {
                Usuario usuario = (Usuario)Session["Usuario"];

                UsuarioNegocio negocio = new UsuarioNegocio();

                negocio.ActualizarUltimaConexion(usuario.Id);
            }

            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Login.aspx");
        }
    }
}
