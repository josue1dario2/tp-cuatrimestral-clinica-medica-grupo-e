using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class Turnos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO: cargar métricas, combos (ddlMedico, ddlEspecialidad) y la primera página de turnos.
                //       rptTurnos.DataSource = ...;  rptTurnos.DataBind();
                //       rptPaginas.DataSource = ...; rptPaginas.DataBind();
            }
        }

        // ----- Filtros -----
        protected void btnLimpiarFiltros_Click(object sender, EventArgs e) { }
        protected void btnBuscarTurnos_Click(object sender, EventArgs e) { }

        // ----- Tabla -----
        protected void rptTurnos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName: VerDetalle | Reprogramar | Cancelar
            // e.CommandArgument: IdTurno
            //
            // VerDetalle: cargar lblDetalle... y rptHistorial, y abrir el modal:
            //   ClientScript.RegisterStartupScript(GetType(), "abrirModal",
            //       "document.addEventListener('DOMContentLoaded', function () { abrirModal('modalDetalle'); });", true);
            //
            // Cancelar: guardar el id en hfIdTurnoCancelar, cargar lblCancelar... y abrir 'modalCancelar' igual que arriba.
            //
            // Reprogramar: redirigir a la pantalla de reprogramación (ej: ReprogramarTurno.aspx?id=...).
        }

        // ----- Modal cancelar -----
        protected void btnConfirmarCancelacion_Click(object sender, EventArgs e)
        {
            // TODO: validar que txtMotivoCancelacion no esté vacío, cancelar el turno hfIdTurnoCancelar.Value
            //       y notificar si chkNotificarPaciente.Checked.
        }

        // ----- Paginación -----
        protected void ddlPorPagina_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void btnPaginaAnterior_Click(object sender, EventArgs e) { }
        protected void btnPaginaSiguiente_Click(object sender, EventArgs e) { }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "IrAPagina", e.CommandArgument == número de página
        }
    }
}
