using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class MisTurnos : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        // Datos de la carga actual (se completan en CargarAgenda).
        private dominio.Medico medico;
        private List<Turno> turnosSemana = new List<Turno>();

        /// <summary>
        /// Día que se está mirando. Se guarda en ViewState para que sobreviva a los PostBack.
        /// </summary>
        private DateTime FechaSeleccionada
        {
            get { return ViewState["FechaSeleccionada"] == null ? DateTime.Today : (DateTime)ViewState["FechaSeleccionada"]; }
            set { ViewState["FechaSeleccionada"] = value.Date; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarAgenda();
        }

        // =====================================================================
        // Carga principal
        // =====================================================================

        private void CargarAgenda()
        {
            int idMedico;
            if (!int.TryParse(Request.QueryString["idMedico"], out idMedico))
            {
                if (Session["medicoLogueado"] is dominio.Medico medSesion)
                {
                    idMedico = medSesion.Id;
                }
                else
                {
                    try
                    {
                        List<dominio.Medico> lista = new MedicoNegocio().listar(true);
                        if (lista != null && lista.Count > 0)
                            idMedico = lista[0].Id;
                        else
                            idMedico = 1;
                    }
                    catch
                    {
                        idMedico = 1;
                    }
                }
            }

            try
            {
                medico = new MedicoNegocio().buscarPorId(idMedico);
                if (medico == null)
                {
                    MostrarError("No existe un médico con Id " + idMedico + ".");
                    return;
                }

                DateTime lunes = InicioDeSemana(FechaSeleccionada);
                turnosSemana = new TurnoNegocio().listarPorMedico(medico.Id, lunes, lunes.AddDays(6));
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo leer la agenda desde la base de datos: " + ex.Message);
                return;
            }

            pnlError.Visible = false;
            phContenido.Visible = true;

            MostrarDatosMedico();
            MostrarSemana();

            List<Turno> turnosDelDia = turnosSemana.Where(t => t.Fecha.Date == FechaSeleccionada).ToList();
            MostrarMetricas(turnosDelDia);
            ActualizarFiltroEstado(turnosDelDia);
            MostrarTabla(turnosDelDia);
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
            phContenido.Visible = false;
        }

        // =====================================================================
        // Encabezado
        // =====================================================================

        private void MostrarDatosMedico()
        {
            string especialidades = medico.Especialidades.Count > 0
                ? string.Join(", ", medico.Especialidades.Select(esp => esp.Descripcion))
                : "Sin especialidad asignada";
            string horario = medico.TurnoTrabajo.HoraEntrada.ToString("00") + ":00 a "
                + medico.TurnoTrabajo.HoraSalida.ToString("00") + ":00 hs";

            lblNombreMedico.Text = medico.NombreCompleto;
            lblDatosConsultorio.Text = "Especialidad: " + especialidades + " • Matrícula " + medico.Matricula;
            lblEstadoConsultorio.Text = medico.Activo ? "Médico activo" : "Médico inactivo";
            lblSubtituloHeader.Text = "Turno " + medico.TurnoTrabajo.Nombre + " • " + horario;
            lblHorarioAtencion.Text = "Horario de atención: " + horario;
            lblMetricaJornada.Text = "Jornada " + horario;
            lblModalMedico.Text = medico.NombreCompleto;

            Clinica_Medica_Grupo_e.Medico master = Master as Clinica_Medica_Grupo_e.Medico;
            if (master != null)
                master.MostrarMedico(medico.NombreCompleto, especialidades);
        }

        // =====================================================================
        // Semana
        // =====================================================================

        private static DateTime InicioDeSemana(DateTime fecha)
        {
            int diasDesdeLunes = ((int)fecha.DayOfWeek + 6) % 7;
            return fecha.Date.AddDays(-diasDesdeLunes);
        }

        private void MostrarSemana()
        {
            DateTime lunes = InicioDeSemana(FechaSeleccionada);
            DateTime domingo = lunes.AddDays(6);
            lblSemanaTitulo.Text = "Semana del " + lunes.ToString("dd/MM", Cultura) + " al " + domingo.ToString("dd/MM/yyyy", Cultura);

            var dias = new List<object>();
            for (int i = 0; i < 7; i++)
            {
                DateTime dia = lunes.AddDays(i);
                List<Turno> turnosDia = turnosSemana.Where(t => t.Fecha.Date == dia).ToList();
                int pendientes = turnosDia.Count(t => EsPendiente(t.Estado));
                int atendidos = turnosDia.Count(t => t.Estado == EstadoTurno.Cerrado);

                string cardCss = "";
                if (dia == FechaSeleccionada)
                    cardCss = "cl-week-today";
                else if (turnosDia.Count == 0)
                    cardCss = "cl-week-off";

                dias.Add(new
                {
                    Fecha = dia.ToString("yyyy-MM-dd"),
                    DiaNombre = Cultura.TextInfo.ToTitleCase(dia.ToString("dddd", Cultura)),
                    DiaNumero = dia.ToString("dd"),
                    Mes = Cultura.TextInfo.ToTitleCase(dia.ToString("MMM", Cultura).TrimEnd('.')),
                    TurnosTexto = turnosDia.Count == 0 ? "Sin turnos"
                                : turnosDia.Count + (turnosDia.Count == 1 ? " turno" : " turnos"),
                    Detalle = turnosDia.Count == 0 ? "Agenda libre"
                                : pendientes + " pend. • " + atendidos + " atend.",
                    EsHoy = dia == DateTime.Today,
                    CardCss = cardCss
                });
            }

            rptSemana.DataSource = dias;
            rptSemana.DataBind();

            string textoFecha = FechaSeleccionada.ToString("dddd d 'de' MMMM, yyyy", Cultura);
            textoFecha = char.ToUpper(textoFecha[0]) + textoFecha.Substring(1);
            lblFechaSeleccionada.Text = FechaSeleccionada == DateTime.Today ? "Hoy - " + textoFecha : textoFecha;
        }

        // =====================================================================
        // Métricas del día
        // =====================================================================

        private void MostrarMetricas(List<Turno> turnosDelDia)
        {
            int total = turnosDelDia.Count;
            int pendientes = turnosDelDia.Count(t => EsPendiente(t.Estado));
            int reprogramados = turnosDelDia.Count(t => t.Estado == EstadoTurno.Reprogramado);
            int atendidos = turnosDelDia.Count(t => t.Estado == EstadoTurno.Cerrado);
            int cancelados = turnosDelDia.Count(t => t.Estado == EstadoTurno.Cancelado);

            // El porcentaje se calcula sobre los turnos que se iban a atender (sin cancelados).
            int atendibles = total - cancelados;
            int porcentaje = atendibles > 0 ? (int)Math.Round(atendidos * 100.0 / atendibles) : 0;

            lblMetricaTotalTurnos.Text = total.ToString();
            lblMetricaPendientes.Text = pendientes.ToString();
            lblMetricaEnEspera.Text = reprogramados == 1 ? "1 reprogramado" : reprogramados + " reprogramados";
            lblMetricaAtendidos.Text = atendidos.ToString();
            lblMetricaPorcentaje.Text = porcentaje + "% de la jornada completada";
        }

        // =====================================================================
        // Tabla de turnos
        // =====================================================================

        private void ActualizarFiltroEstado(List<Turno> turnosDelDia)
        {
            ddlFiltroEstado.Items.FindByValue("todos").Text = "Todos los estados (" + turnosDelDia.Count + ")";
            ddlFiltroEstado.Items.FindByValue("nuevo").Text = "Nuevos / Pendientes (" + turnosDelDia.Count(t => EsPendiente(t.Estado)) + ")";
            ddlFiltroEstado.Items.FindByValue("cerrado").Text = "Atendidos / Cerrados (" + turnosDelDia.Count(t => t.Estado == EstadoTurno.Cerrado) + ")";
            ddlFiltroEstado.Items.FindByValue("reprogramado").Text = "Reprogramados (" + turnosDelDia.Count(t => t.Estado == EstadoTurno.Reprogramado) + ")";
            ddlFiltroEstado.Items.FindByValue("noasistio").Text = "No asistió (" + turnosDelDia.Count(t => t.Estado == EstadoTurno.NoAsistio) + ")";
            ddlFiltroEstado.Items.FindByValue("cancelado").Text = "Cancelados (" + turnosDelDia.Count(t => t.Estado == EstadoTurno.Cancelado) + ")";
        }

        private void MostrarTabla(List<Turno> turnosDelDia)
        {
            List<Turno> filtrados = AplicarFiltros(turnosDelDia);

            // El primer turno pendiente de hoy se resalta como "el próximo a atender".
            Turno proximo = FechaSeleccionada == DateTime.Today
                ? filtrados.FirstOrDefault(t => EsPendiente(t.Estado))
                : null;

            rptMisTurnos.DataSource = filtrados.Select(t => ArmarFila(t, t == proximo)).ToList();
            rptMisTurnos.DataBind();

            rptMisTurnos.Visible = filtrados.Count > 0;
            pnlSinTurnos.Visible = filtrados.Count == 0;

            lblResumenTabla.Text = "Mostrando " + filtrados.Count + " de " + turnosDelDia.Count
                + " turnos de " + medico.NombreCompleto + " para el " + FechaSeleccionada.ToString("dd/MM/yyyy");
            lblTurnosRestantes.Text = "Turnos restantes: " + turnosDelDia.Count(t => EsPendiente(t.Estado));
        }

        private List<Turno> AplicarFiltros(List<Turno> turnos)
        {
            IEnumerable<Turno> resultado = turnos;

            switch (ddlFiltroEstado.SelectedValue)
            {
                case "nuevo": resultado = resultado.Where(t => EsPendiente(t.Estado)); break;
                case "cerrado": resultado = resultado.Where(t => t.Estado == EstadoTurno.Cerrado); break;
                case "reprogramado": resultado = resultado.Where(t => t.Estado == EstadoTurno.Reprogramado); break;
                case "noasistio": resultado = resultado.Where(t => t.Estado == EstadoTurno.NoAsistio); break;
                case "cancelado": resultado = resultado.Where(t => t.Estado == EstadoTurno.Cancelado); break;
            }

            string busqueda = txtBuscarPaciente.Text.Trim().ToLower().Replace(".", "");
            if (busqueda != "")
            {
                resultado = resultado.Where(t =>
                    t.Paciente.Apellido.ToLower().Contains(busqueda) ||
                    t.Paciente.Nombre.ToLower().Contains(busqueda) ||
                    t.Paciente.Dni.Contains(busqueda));
            }

            return resultado.ToList();
        }

        /// <summary>
        /// Convierte un turno en los campos que espera el Repeater rptMisTurnos.
        /// </summary>
        private object ArmarFila(Turno turno, bool esProximo)
        {
            string estadoTexto, estadoCss, estadoIcono;
            string accionTexto, accionComando, accionCss, accionIcono;
            string filaCss = "";

            switch (turno.Estado)
            {
                case EstadoTurno.Reprogramado:
                    estadoTexto = "Reprogramado"; estadoCss = "cl-estado-reprogramado"; estadoIcono = "bi-arrow-repeat";
                    break;
                case EstadoTurno.Cancelado:
                    estadoTexto = "Cancelado"; estadoCss = "cl-estado-cancelado"; estadoIcono = "bi-x-circle";
                    filaCss = "cl-fila-atenuada";
                    break;
                case EstadoTurno.NoAsistio:
                    estadoTexto = "No asistió"; estadoCss = "cl-estado-noasistio"; estadoIcono = "bi-person-x";
                    filaCss = "cl-fila-atenuada";
                    break;
                case EstadoTurno.Cerrado:
                    estadoTexto = "Cerrado"; estadoCss = "cl-estado-cerrado"; estadoIcono = "bi-check-circle-fill";
                    break;
                default:
                    estadoTexto = "Nuevo"; estadoCss = "cl-estado-nuevo"; estadoIcono = "bi-circle-fill";
                    break;
            }

            if (EsPendiente(turno.Estado))
            {
                accionComando = "Atender";
                accionIcono = "bi-hospital";
                if (esProximo)
                {
                    accionTexto = "Atender ahora";
                    accionCss = "btn-cl-primary shadow-sm";
                    filaCss = "cl-fila-actual";
                }
                else
                {
                    accionTexto = "Atender";
                    accionCss = "btn-cl-secondary text-cl-primary";
                }
            }
            else if (turno.Estado == EstadoTurno.Cerrado)
            {
                accionTexto = "Ficha médica"; accionComando = "VerFicha";
                accionCss = "btn-cl-secondary"; accionIcono = "bi-file-earmark-medical";
            }
            else
            {
                accionTexto = "Ver motivo"; accionComando = "VerMotivo";
                accionCss = "btn-cl-secondary text-secondary"; accionIcono = "bi-info-circle";
            }

            return new
            {
                IdTurno = turno.Id,
                Hora = turno.HoraTexto,
                PacienteNombre = turno.Paciente.NombreCompleto,
                PacienteDetalle = turno.Paciente.Edad + " años • DNI " + FormatearDni(turno.Paciente.Dni),
                Motivo = string.IsNullOrEmpty(turno.Observaciones) ? "Sin observaciones" : turno.Observaciones,
                EstadoTexto = estadoTexto,
                EstadoCss = estadoCss,
                EstadoIcono = estadoIcono,
                EnSalaEspera = false,
                FilaCss = filaCss,
                AccionTexto = accionTexto,
                AccionComando = accionComando,
                AccionCss = accionCss,
                AccionIcono = accionIcono
            };
        }

        private static bool EsPendiente(EstadoTurno estado)
        {
            return estado == EstadoTurno.Nuevo || estado == EstadoTurno.Reprogramado;
        }

        /// <summary>
        /// "35111222" -> "35.111.222".
        /// </summary>
        private static string FormatearDni(string dni)
        {
            long numero;
            return long.TryParse(dni, out numero) ? numero.ToString("#,0", Cultura) : dni;
        }

        // =====================================================================
        // Eventos
        // =====================================================================

        protected void btnExportarAgenda_Click(object sender, EventArgs e) { }

        protected void rptSemana_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SeleccionarDia")
            {
                FechaSeleccionada = DateTime.ParseExact((string)e.CommandArgument, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                CargarAgenda();
            }
        }

        protected void btnDiaAnterior_Click(object sender, EventArgs e)
        {
            FechaSeleccionada = FechaSeleccionada.AddDays(-1);
            CargarAgenda();
        }

        protected void btnDiaSiguiente_Click(object sender, EventArgs e)
        {
            FechaSeleccionada = FechaSeleccionada.AddDays(1);
            CargarAgenda();
        }

        protected void btnIrAHoy_Click(object sender, EventArgs e)
        {
            FechaSeleccionada = DateTime.Today;
            CargarAgenda();
        }

        protected void ddlFiltroEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarAgenda();
        }

        protected void txtBuscarPaciente_TextChanged(object sender, EventArgs e)
        {
            CargarAgenda();
        }

        protected void rptMisTurnos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == AccionComando (Atender, VerFicha, VerMotivo), e.CommandArgument == IdTurno
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
