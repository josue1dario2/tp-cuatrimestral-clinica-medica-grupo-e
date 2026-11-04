using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class TurnosTrabajo : Page
    {
        // Pestaña elegida: "Activos", "Inactivos" o "Todos". Se guarda en el ViewState para que no se pierda en cada PostBack.
        private string FiltroEstado
        {
            get { return ViewState["FiltroEstado"] as string ?? "Activos"; }
            set { ViewState["FiltroEstado"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarHoras();
                CargarTurnos();

                // Fuera del alcance de este ABM: siguen siendo de ejemplo.
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

        
        // LISTADO (con búsqueda y pestañas de estado)
        

        private void CargarTurnos()
        {
            List<TurnoTrabajo> todos;
            try
            {
                TurnoTrabajoNegocio negocio = new TurnoTrabajoNegocio();
                todos = negocio.listarParaGestion();
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudieron cargar los turnos de trabajo: " + ex.Message, true);
                todos = new List<TurnoTrabajo>();
            }

            // Cantidades de las pestañas (sobre todos los turnos, sin la búsqueda).
            btnTabActivos.Text = "Activos (" + todos.Count(t => t.Activo) + ")";
            btnTabInactivos.Text = "Inactivos (" + todos.Count(t => !t.Activo) + ")";

            // 1) Filtro por estado.
            IEnumerable<TurnoTrabajo> filtrados = todos;
            if (FiltroEstado == "Activos")
                filtrados = filtrados.Where(t => t.Activo);
            else if (FiltroEstado == "Inactivos")
                filtrados = filtrados.Where(t => !t.Activo);

            // 2) Búsqueda por nombre u horario ("tarde", "14", "14:00").
            string busqueda = txtBuscar.Text.Trim().ToLower();
            if (busqueda != "")
            {
                filtrados = filtrados.Where(t =>
                    t.Nombre.ToLower().Contains(busqueda) ||
                    HoraTexto(t.HoraEntrada).Contains(busqueda) ||
                    HoraTexto(t.HoraSalida).Contains(busqueda));
            }

            List<TurnoTrabajo> lista = filtrados.ToList();

            rptTurnosTrabajo.DataSource = lista.Select(t => ArmarFila(t)).ToList();
            rptTurnosTrabajo.DataBind();
            rptTurnosTrabajo.Visible = lista.Count > 0;
            pnlSinTurnos.Visible = lista.Count == 0;

            lblRangoMostrado.Text = lista.Count == 0 ? "0" : "1 - " + lista.Count;
            lblTotalRegistros.Text = lista.Count.ToString();

            MarcarPestana();
        }

        // Convierte un TurnoTrabajo en los campos que espera el Repeater rptTurnosTrabajo.
        private object ArmarFila(TurnoTrabajo turno)
        {
            string accion = turno.Activo ? "Dar de baja" : "Reactivar";
            string nombreJs = HttpUtility.JavaScriptStringEncode(turno.Nombre);

            return new
            {
                IdTurnoTrabajo = turno.Id,
                Nombre = turno.Nombre,
                Detalle = turno.CantidadHoras + " horas de atención",
                ColorCss = "tt-color-" + ((turno.Id - 1) % 5 + 1) + (turno.Activo ? "" : " tt-fila-inactiva"),
                Entrada = HoraTexto(turno.HoraEntrada) + " hs",
                Salida = HoraTexto(turno.HoraSalida) + " hs",
                CantidadBloques = turno.CantidadHoras,
                Bloques = new int[Math.Max(turno.CantidadHoras, 0)],
                Medicos = new string[0],
                MedicosTexto = turno.CantidadMedicos == 0 ? "Sin médicos"
                             : turno.CantidadMedicos + " méd.",
                EstadoTexto = turno.Activo ? "Activo" : "Inactivo",
                EstadoCss = turno.Activo ? "tt-badge-activo" : "tt-badge-activo tt-badge-inactivo",
                AccionEstadoTexto = accion,
                AccionEstadoIcono = turno.Activo ? "block" : "restart_alt",
                ConfirmarScript = "return confirm('¿" + accion + " el turno «" + nombreJs + "»?');"
            };
        }

        private static string HoraTexto(int hora)
        {
            return hora.ToString("00") + ":00";
        }

        // Pasa la clase tt-tab-activa a la pestaña elegida.
        private void MarcarPestana()
        {
            btnTabActivos.CssClass = FiltroEstado == "Activos" ? "tt-tab tt-tab-activa" : "tt-tab";
            btnTabInactivos.CssClass = FiltroEstado == "Inactivos" ? "tt-tab tt-tab-activa" : "tt-tab";
            btnTabTodos.CssClass = FiltroEstado == "Todos" ? "tt-tab tt-tab-activa" : "tt-tab";
        }

        protected void FiltroEstado_Command(object sender, CommandEventArgs e)
        {
            FiltroEstado = e.CommandArgument.ToString();
            OcultarMensajes();
            CargarTurnos();
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            OcultarMensajes();
            CargarTurnos();
        }

        
        // ACCIONES DE CADA FILA: modificar (cargar en el formulario) y baja / reactivación
        

        protected void rptTurnosTrabajo_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            OcultarMensajes();

            switch (e.CommandName)
            {
                case "Editar":
                    CargarEnFormulario(id);
                    break;

                case "CambiarEstado":
                    CambiarEstado(id);
                    break;

                case "VerMedicos":
                    // Fuera del alcance de este ABM.
                    break;

                case "Duplicar":
                    // Fuera del alcance de este ABM.
                    break;
            }
        }

        private void CargarEnFormulario(int id)
        {
            try
            {
                TurnoTrabajoNegocio negocio = new TurnoTrabajoNegocio();
                TurnoTrabajo turno = negocio.buscarPorId(id);
                if (turno == null)
                {
                    MostrarMensaje("El turno de trabajo ya no existe.", true);
                    CargarTurnos();
                    return;
                }

                hfIdTurnoTrabajo.Value = turno.Id.ToString();
                txtNombre.Text = turno.Nombre;
                ddlHoraEntrada.SelectedValue = turno.HoraEntrada.ToString();
                ddlHoraSalida.SelectedValue = turno.HoraSalida.ToString();
                lblFormTitulo.Text = "Editar turno de trabajo";
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudo cargar el turno de trabajo: " + ex.Message, true);
            }
        }

        private void CambiarEstado(int id)
        {
            try
            {
                TurnoTrabajoNegocio negocio = new TurnoTrabajoNegocio();
                TurnoTrabajo turno = negocio.buscarPorId(id);
                if (turno == null)
                {
                    MostrarMensaje("El turno de trabajo ya no existe.", true);
                }
                else if (turno.Activo)
                {
                    // Regla: no se da de baja un turno que tiene médicos activos asignados.
                    if (turno.CantidadMedicos > 0)
                    {
                        MostrarMensaje("No se puede dar de baja «" + turno.Nombre + "»: tiene " + turno.CantidadMedicos
                            + " médico(s) activo(s) asignado(s). Primero asigneles otro turno de trabajo.", true);
                    }
                    else
                    {
                        negocio.eliminar(id);
                        MostrarMensaje("Se dio de baja el turno «" + turno.Nombre + "».", false);
                    }
                }
                else
                {
                    negocio.reactivar(id);
                    MostrarMensaje("Se reactivó el turno «" + turno.Nombre + "».", false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudo cambiar el estado: " + ex.Message, true);
            }

            CargarTurnos();
        }

        
        // ALTA Y MODIFICACIÓN (formulario de la derecha)
        

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            OcultarMensajes();

            string nombre = txtNombre.Text.Trim();
            int entrada = int.Parse(ddlHoraEntrada.SelectedValue);
            int salida = int.Parse(ddlHoraSalida.SelectedValue);
            bool esAlta = string.IsNullOrEmpty(hfIdTurnoTrabajo.Value);

            // ----- Validaciones -----
            if (nombre == "")
            {
                MostrarErrorFormulario("Falta el nombre", "Escribí un nombre para el turno de trabajo.");
                return;
            }
            if (salida <= entrada)
            {
                MostrarErrorFormulario("Validación de inconsistencia horaria",
                    "La hora de salida debe ser posterior a la de entrada.");
                return;
            }

            // ----- Guardar -----
            try
            {
                TurnoTrabajo turno = new TurnoTrabajo();
                turno.Nombre = nombre;
                turno.HoraEntrada = entrada;
                turno.HoraSalida = salida;

                TurnoTrabajoNegocio negocio = new TurnoTrabajoNegocio();
                if (esAlta)
                {
                    negocio.agregar(turno);
                    MostrarMensaje("Se agregó el turno «" + nombre + "».", false);
                }
                else
                {
                    turno.Id = int.Parse(hfIdTurnoTrabajo.Value);
                    negocio.modificar(turno);
                    MostrarMensaje("Se guardaron los cambios del turno «" + nombre + "».", false);
                }

                LimpiarFormulario();
            }
            catch (Exception ex)
            {
                MostrarErrorFormulario("No se pudo guardar", ex.Message);
            }

            CargarTurnos();
        }

        private void LimpiarFormulario()
        {
            hfIdTurnoTrabajo.Value = "";
            txtNombre.Text = "";
            ddlHoraEntrada.SelectedValue = "14";
            ddlHoraSalida.SelectedValue = "20";
            lblFormTitulo.Text = "Nuevo turno de trabajo";
        }

        protected void ddlHora_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Fuera del alcance de este ABM: recalcular la vista previa de bloques.
        }

        
        // MENSAJES
        

        // Mensaje arriba de la tabla (verde si salió bien, rojo si hubo un error).
        private void MostrarMensaje(string texto, bool esError)
        {
            lblMensaje.Text = texto;
            pnlMensaje.CssClass = esError
                ? "alert alert-danger d-flex align-items-center gap-2 py-2 mb-3"
                : "alert alert-success d-flex align-items-center gap-2 py-2 mb-3";
            pnlMensaje.Visible = true;
        }

        // Error dentro del formulario de la derecha.
        private void MostrarErrorFormulario(string titulo, string texto)
        {
            lblErrorTitulo.Text = titulo;
            lblErrorHorario.Text = texto;
            pnlErrorHorario.Visible = true;
        }

        private void OcultarMensajes()
        {
            pnlMensaje.Visible = false;
            pnlErrorHorario.Visible = false;
        }

        
        // Fuera del alcance de este ABM (quedan como estaban)
        
        protected void btnExportar_Click(object sender, EventArgs e)
        {
            // TODO: exportar la grilla de turnos de trabajo.
        }

        protected void ddlPorPagina_SelectedIndexChanged(object sender, EventArgs e)
        {
            // TODO: paginación.
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            // TODO: paginación.
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            // TODO: paginación.
        }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // TODO: paginación.
        }

        // TEMPORAL: una sola página (todavía no hay paginación).
        private void CargarPaginasDeEjemplo()
        {
            rptPaginas.DataSource = new[] { new { Numero = 1, Css = "active" } };
            rptPaginas.DataBind();
        }

        // TEMPORAL: vista previa fija de 14:00 a 20:00 (todavía no se recalcula).
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
