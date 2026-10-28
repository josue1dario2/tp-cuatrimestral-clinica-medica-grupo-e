using System;
using System.Web.UI;

namespace Clinica_Medica_Grupo_e
{
    public partial class AdminRecep : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // TODO: cargar usuario logueado (lblNombreUsuario, lblRolUsuario) y fecha (lblFechaHoy),
            //       ocultar phMenuAdministracion si el rol es Recepción
            //       y marcar como "active" el link del menú de la página actual.
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
