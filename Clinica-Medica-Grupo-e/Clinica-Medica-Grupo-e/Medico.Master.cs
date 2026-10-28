using System;
using System.Web.UI;

namespace Clinica_Medica_Grupo_e
{
    public partial class Medico : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // TODO: cargar datos del médico logueado (lblNombreMedico, lblEspecialidadMedico),
            //       la fecha actual (lblFechaActual) y marcar como "active" el link del menú actual.
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // TODO: cerrar sesión y redirigir al login.
        }
    }
}
