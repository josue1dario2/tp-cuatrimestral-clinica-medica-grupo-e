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
            lblFechaHoy.Text = "Hoy, " + DateTime.Today.ToString("d 'de' MMMM yyyy", new CultureInfo("es-AR"));
            MarcarLinkActivo();

            // TODO: cargar usuario logueado (lblNombreUsuario, lblRolUsuario)
            //       y ocultar phMenuAdministracion si el rol es Recepción.
        }

        /// <summary>
        /// Marca como "active" el link del menú que corresponde a la página actual.
        /// </summary>
        private void MarcarLinkActivo()
        {
            string paginaActual = Path.GetFileName(Request.Path);
            HyperLink[] links =
            {
                lnkNavInicio, lnkNavTurnos, lnkNavNuevoTurno, lnkNavPacientes, lnkNavMedicos,
                lnkNavEspecialidades, lnkNavTurnosTrabajo, lnkNavUsuarios, lnkNavEstadisticas
            };

            foreach (HyperLink link in links)
            {
                string paginaLink = Path.GetFileName(link.NavigateUrl);
                if (string.Equals(paginaLink, paginaActual, StringComparison.OrdinalIgnoreCase))
                    link.CssClass = "nav-item-custom active";
            }
        }

        protected void btnBuscarGlobal_Click(object sender, EventArgs e)
        {
            // TODO: buscar turno / paciente por DNI con txtBuscarGlobal.Text.
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            // TODO: cerrar sesión y redirigir al login.
        }
    }
}
