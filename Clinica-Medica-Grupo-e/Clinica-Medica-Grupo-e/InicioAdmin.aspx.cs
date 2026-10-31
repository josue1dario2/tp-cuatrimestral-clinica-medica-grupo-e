using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class InicioAdmin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO: cargar bienvenida, indicadores y turnos del día.
                //       ddlProfesional.DataSource = ...; ddlProfesional.DataTextField / DataValueField; ddlProfesional.DataBind();
                //       rptTurnosHoy.DataSource = ...;   rptTurnosHoy.DataBind();
                //       rptPaginas.DataSource = ...;     rptPaginas.DataBind();
            }
        }

        // ----- Bienvenida y accesos rápidos -----
        protected void btnCambiarFecha_Click(object sender, EventArgs e) { }
        protected void btnRecepcionCheckin_Click(object sender, EventArgs e) { }

        // ----- Filtros -----
        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void ddlProfesional_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void btnRefrescar_Click(object sender, EventArgs e) { }

        // ----- Tabla -----
        protected void rptTurnosHoy_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName: CheckIn | VerFicha | Reprogramar | VerCambio | LiberarCupo | Cancelar
            // e.CommandArgument: IdTurno
        }

        // ----- Paginación -----
        protected void ddlFilasPorPagina_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void btnPaginaAnterior_Click(object sender, EventArgs e) { }
        protected void btnPaginaSiguiente_Click(object sender, EventArgs e) { }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "IrAPagina", e.CommandArgument == número de página
        }
    }
}
