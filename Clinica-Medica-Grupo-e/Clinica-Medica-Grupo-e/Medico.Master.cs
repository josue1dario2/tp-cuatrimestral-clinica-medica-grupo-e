using System;
using System.Globalization;
using System.IO;
using System.Web.UI;

namespace Clinica_Medica_Grupo_e
{
    public partial class Medico : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CultureInfo cultura = new CultureInfo("es-AR");
            lblFechaActual.Text = DateTime.Today.ToString("dddd, d 'de' MMMM", cultura);

            // Mientras no haya login, el médico viaja en la URL (?idMedico=...).
            // Se agrega a los links del menú para no perderlo al navegar.
            string idMedico = Request.QueryString["idMedico"];
            if (!string.IsNullOrEmpty(idMedico))
            {
                string parametro = "?idMedico=" + Server.UrlEncode(idMedico);
                lnkNavInicio.NavigateUrl = "~/InicioMedico.aspx" + parametro;
                lnkNavMisTurnos.NavigateUrl = "~/MisTurnos.aspx" + parametro;
            }

            // Marca como activo el link de la página actual.
            string paginaActual = Path.GetFileName(Request.Path);
            if (string.Equals(paginaActual, "InicioMedico.aspx", StringComparison.OrdinalIgnoreCase))
                lnkNavInicio.CssClass = "cl-nav-link active";
            else if (string.Equals(paginaActual, "MisTurnos.aspx", StringComparison.OrdinalIgnoreCase))
                lnkNavMisTurnos.CssClass = "cl-nav-link active";
        }

        /// <summary>
        /// Muestra el médico en la barra superior. La llama cada página de contenido
        /// cuando ya sabe qué médico está usando el sistema.
        /// </summary>
        public void MostrarMedico(string nombre, string detalle)
        {
            lblNombreMedico.Text = nombre;
            lblEspecialidadMedico.Text = detalle;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // TODO: cerrar sesión y redirigir al login.
        }
    }
}
