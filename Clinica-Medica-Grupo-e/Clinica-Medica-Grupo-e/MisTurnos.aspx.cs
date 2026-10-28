using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class MisTurnos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO: cargar encabezado, semana, métricas y turnos del día.
                //       rptSemana.DataSource = ...;   rptSemana.DataBind();
                //       rptMisTurnos.DataSource = ...; rptMisTurnos.DataBind();
            }
        }

        // ----- Encabezado -----
        protected void btnExportarAgenda_Click(object sender, EventArgs e) { }

        // ----- Semana -----
        protected void rptSemana_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "SeleccionarDia", e.CommandArgument == Fecha (yyyy-MM-dd)
        }

        // ----- Fecha, filtro y búsqueda -----
        protected void btnDiaAnterior_Click(object sender, EventArgs e) { }
        protected void btnDiaSiguiente_Click(object sender, EventArgs e) { }
        protected void btnIrAHoy_Click(object sender, EventArgs e) { }
        protected void ddlFiltroEstado_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void txtBuscarPaciente_TextChanged(object sender, EventArgs e) { }

        // ----- Tabla de turnos -----
        protected void rptMisTurnos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == AccionComando (Atender, VerFicha, VerMotivo...), e.CommandArgument == IdTurno
            //
            // Para "Atender": cargar los datos del turno en el modal (hfIdTurnoModal, lblModalPaciente, ...) y abrirlo:
            //   ClientScript.RegisterStartupScript(GetType(), "modalAtencion",
            //       "document.addEventListener('DOMContentLoaded', abrirModalAtencion);", true);
        }

        // ----- Modal de atención -----
        protected void btnVerHCCompleta_Click(object sender, EventArgs e) { }
        protected void btnCargarECG_Click(object sender, EventArgs e) { }
        protected void btnRecetaDigital_Click(object sender, EventArgs e) { }
        protected void btnLlamarPantalla_Click(object sender, EventArgs e) { }
        protected void btnIniciarConsulta_Click(object sender, EventArgs e) { }
    }
}
