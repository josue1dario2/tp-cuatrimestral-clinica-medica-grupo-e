using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class TurnosTrabajo : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarHoras();

                // TODO (etapa de lógica): cargar los KPI y rptTurnosTrabajo con TurnoTrabajoNegocio.listar()
                //       (los médicos de cada turno salen de MEDICOS.IdTurnoTrabajo).

                // TEMPORAL: datos de ejemplo para ver la tabla, la paginación y la vista previa con el diseño.
                // Borrar estas tres líneas (y los métodos de abajo) cuando se conecte la base.
                CargarTurnosDeEjemplo();
                CargarPaginasDeEjemplo();
                CargarVistaPreviaDeEjemplo();
            }
        }

        // Llena las dos listas de horas: Value = número que se guarda en la base (8), Text = "08:00".
        private void CargarHoras()
        {
            for (int h = 0; h <= 23; h++)
            {
                string texto = h.ToString("00") + ":00";
                ddlHoraEntrada.Items.Add(new ListItem(texto, h.ToString()));
                ddlHoraSalida.Items.Add(new ListItem(texto, h.ToString()));
            }
            ddlHoraEntrada.SelectedValue = "14";
            ddlHoraSalida.SelectedValue = "20";
        }

        // =====================================================================
        // Eventos (vacíos en esta etapa)
        // =====================================================================

        protected void btnExportar_Click(object sender, EventArgs e)
        {
            // TODO: exportar la grilla de turnos de trabajo.
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            // TODO: filtrar por txtBuscar.Text (nombre u horario).
        }

        protected void FiltroEstado_Command(object sender, CommandEventArgs e)
        {
            // TODO: e.CommandArgument es "Activos", "Inactivos" o "Todos".
            //       Necesita una columna Activo en TURNOS_TRABAJO. Pasar la clase tt-tab-activa a la pestaña elegida.
        }

        protected void rptTurnosTrabajo_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandArgument tiene el Id del turno de trabajo.
            switch (e.CommandName)
            {
                case "Editar":
                    // TODO: cargar txtNombre y las horas, hfIdTurnoTrabajo.Value = id
                    //       y lblFormTitulo.Text = "Editar turno de trabajo".
                    break;
                case "VerMedicos":
                    // TODO: Response.Redirect("~/Medicos.aspx?turnoTrabajo=" + e.CommandArgument, false);
                    break;
                case "Duplicar":
                    // TODO: cargar el formulario con los datos del turno, sin Id (para guardarlo como uno nuevo).
                    break;
            }
        }

        protected void ddlHora_SelectedIndexChanged(object sender, EventArgs e)
        {
            // TODO: recalcular la vista previa (rptPreviewBloques, lblPreviewCantidad, lblPreviewDuracion)
            //       y mostrar pnlErrorHorario si la salida no es posterior a la entrada.
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // TODO: validar; si hfIdTurnoTrabajo está vacío es un alta, si no, una modificación.
        }

        protected void ddlPorPagina_SelectedIndexChanged(object sender, EventArgs e)
        {
            // TODO: volver a la página 1 con la nueva cantidad de filas.
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            // TODO: ir a la página anterior.
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            // TODO: ir a la página siguiente.
        }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // TODO: ir a la página e.CommandArgument.
        }

        // =====================================================================
        // TEMPORAL: datos de ejemplo (solo para ver el diseño)
        // =====================================================================

        private void CargarTurnosDeEjemplo()
        {
            var filas = new List<object>
            {
                Fila(1, "Turno Mañana", "Lunes a Sábado • Consultorios 1 al 8", 8, 14, new[] { "MS", "LP", "RG" }, "+8 méd."),
                Fila(2, "Turno Tarde", "Lunes a Viernes • Consultorios 1 al 10", 14, 20, new[] { "AC", "JF" }, "+10 méd."),
                Fila(3, "Turno Noche / Guardia", "Todos los días • Guardia Médica Activa", 20, 2, new[] { "GB", "MS" }, "3 méd."),
                Fila(4, "Turno Sábado Matutino", "Sábados • Especialidades y Estudios", 8, 13, new[] { "DV" }, "4 méd."),
                Fila(5, "Turno Mediodía / Intermedio", "Lunes a Viernes • Consultorio Rápido", 11, 15, new[] { "LR" }, "2 méd.")
            };
            rptTurnosTrabajo.DataSource = filas;
            rptTurnosTrabajo.DataBind();
        }

        private static object Fila(int id, string nombre, string detalle, int entrada, int salida, string[] medicos, string medicosTexto)
        {
            // Si cruza la medianoche (ej. 20 a 2) se suman 24 horas.
            int cantidad = salida > entrada ? salida - entrada : salida + 24 - entrada;

            return new
            {
                IdTurnoTrabajo = id,
                Nombre = nombre,
                Detalle = detalle,
                ColorCss = "tt-color-" + ((id - 1) % 5 + 1),
                Entrada = entrada.ToString("00") + ":00 hs",
                Salida = salida.ToString("00") + ":00 hs",
                CantidadBloques = cantidad,
                Bloques = new int[cantidad],
                Medicos = medicos,
                MedicosTexto = medicosTexto,
                EstadoTexto = "Activo"
            };
        }

        private void CargarPaginasDeEjemplo()
        {
            rptPaginas.DataSource = new[] { new { Numero = 1, Css = "active" } };
            rptPaginas.DataBind();
        }

        private void CargarVistaPreviaDeEjemplo()
        {
            var bloques = new List<object>();
            for (int h = 14, n = 1; h < 20; h++, n++)
                bloques.Add(new { Rango = h.ToString("00") + ":00 - " + (h + 1).ToString("00") + ":00", Numero = n });
            rptPreviewBloques.DataSource = bloques;
            rptPreviewBloques.DataBind();
        }
    }
}
