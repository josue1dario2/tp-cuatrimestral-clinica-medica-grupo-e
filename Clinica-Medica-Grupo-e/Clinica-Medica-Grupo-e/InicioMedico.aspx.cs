using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class InicioMedico : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO: cargar saludo, indicadores, próximo turno y agenda del día.
                //       rptTurnosRestantes.DataSource = ...; rptTurnosRestantes.DataBind();
                //       rptTurnosAtendidos.DataSource = ...; rptTurnosAtendidos.DataBind();
            }
        }

        // ----- Bienvenida -----
        protected void btnPausarAtencion_Click(object sender, EventArgs e) { }
        protected void btnBusquedaHC_Click(object sender, EventArgs e) { }

        // ----- Próximo turno -----
        protected void btnLlamarAtender_Click(object sender, EventArgs e) { }
        protected void btnAbrirHC_Click(object sender, EventArgs e) { }
        protected void btnAvisarRecepcion_Click(object sender, EventArgs e) { }
        protected void btnReprogramarTurno_Click(object sender, EventArgs e) { }

        // ----- Agenda -----
        protected void btnFiltroTodos_Click(object sender, EventArgs e) { }
        protected void btnFiltroEspera_Click(object sender, EventArgs e) { }
        protected void btnFiltroConfirmados_Click(object sender, EventArgs e) { }
        protected void btnActualizarLista_Click(object sender, EventArgs e) { }

        protected void rptTurnosRestantes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "VerFicha", e.CommandArgument == IdTurno
        }
    }
}
