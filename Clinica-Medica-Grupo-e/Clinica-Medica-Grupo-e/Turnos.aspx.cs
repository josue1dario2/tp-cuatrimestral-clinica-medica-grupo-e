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
    public partial class Turnos : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        /// <summary>
        /// Página actual de la tabla (empieza en 1). Se guarda en ViewState.
        /// </summary>
        private int PaginaActual
        {
            get { return ViewState["PaginaActual"] == null ? 1 : (int)ViewState["PaginaActual"]; }
            set { ViewState["PaginaActual"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    CargarCombos();
                    CargarMetricasDeHoy();
                }
                catch (Exception ex)
                {
                    MostrarError("No se pudo conectar con la base de datos: " + ex.Message);
                    return;
                }

                FiltrosPorDefecto();
                Buscar();
            }
        }

        // =====================================================================
        // Carga inicial
        // =====================================================================

        private void CargarCombos()
        {
            ddlMedico.DataSource = new MedicoNegocio().listar(false)
                .Select(m => new { m.Id, Texto = m.NombreCompleto + (m.Activo ? "" : " (inactivo)") })
                .ToList();
            ddlMedico.DataValueField = "Id";
            ddlMedico.DataTextField = "Texto";
            ddlMedico.DataBind();

            ddlEspecialidad.DataSource = new EspecialidadNegocio().listar();
            ddlEspecialidad.DataValueField = "Id";
            ddlEspecialidad.DataTextField = "Descripcion";
            ddlEspecialidad.DataBind();
        }

        /// <summary>
        /// Por defecto se muestran los turnos desde hoy en adelante.
        /// </summary>
        private void FiltrosPorDefecto()
        {
            txtFechaDesde.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaHasta.Text = "";
            ddlMedico.SelectedValue = "0";
            ddlEspecialidad.SelectedValue = "0";
            txtPaciente.Text = "";
            ddlEstado.SelectedValue = "";
            txtNumeroTurno.Text = "";
        }

        // =====================================================================
        // Métricas (siempre del día de hoy, sin importar los filtros)
        // =====================================================================

        private void CargarMetricasDeHoy()
        {
            FiltroTurnos filtroHoy = new FiltroTurnos();
            filtroHoy.Desde = DateTime.Today;
            filtroHoy.Hasta = DateTime.Today;
            List<Turno> hoy = new TurnoNegocio().buscar(filtroHoy);

            int total = hoy.Count;
            int enEspera = hoy.Count(t => t.Estado == EstadoTurno.Nuevo || t.Estado == EstadoTurno.Reprogramado);
            int atendidos = hoy.Count(t => t.Estado == EstadoTurno.Cerrado);
            int reprogramados = hoy.Count(t => t.Estado == EstadoTurno.Reprogramado);
            int cancelados = hoy.Count(t => t.Estado == EstadoTurno.Cancelado);
            int medicos = hoy.Select(t => t.Medico.Id).Distinct().Count();
            int especialidades = hoy.Select(t => t.Especialidad.Id).Distinct().Count();

            lblMetricaTotal.Text = total.ToString();
            lblMetricaCupo.Text = medicos == 1 ? "1 médico" : medicos + " médicos";
            lblMetricaEspecialidades.Text = especialidades == 1 ? "1 especialidad con turnos" : especialidades + " especialidades con turnos";
            lblMetricaEspera.Text = enEspera.ToString();
            lblMetricaEsperaPorcentaje.Text = Porcentaje(enEspera, total);
            lblMetricaAtendidos.Text = atendidos.ToString();
            lblMetricaAtendidosPorcentaje.Text = Porcentaje(atendidos, total);
            lblMetricaReprogCancel.Text = (reprogramados + cancelados).ToString();
            lblMetricaReprogramados.Text = reprogramados + " R";
            lblMetricaCancelados.Text = cancelados + " C";
        }

        private static string Porcentaje(int parte, int total)
        {
            return total == 0 ? "0%" : (parte * 100.0 / total).ToString("0.#", Cultura) + "%";
        }

        // =====================================================================
        // Búsqueda avanzada
        // =====================================================================

        /// <summary>
        /// Lee los filtros de la pantalla. Devuelve null (y muestra el motivo) si alguno es inválido.
        /// </summary>
        private FiltroTurnos LeerFiltros()
        {
            FiltroTurnos filtro = new FiltroTurnos();

            DateTime fecha;
            if (txtFechaDesde.Text != "")
            {
                if (!DateTime.TryParseExact(txtFechaDesde.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha))
                {
                    MostrarError("La fecha \"desde\" no es válida.");
                    return null;
                }
                filtro.Desde = fecha;
            }
            if (txtFechaHasta.Text != "")
            {
                if (!DateTime.TryParseExact(txtFechaHasta.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha))
                {
                    MostrarError("La fecha \"hasta\" no es válida.");
                    return null;
                }
                filtro.Hasta = fecha;
            }
            if (filtro.Desde.HasValue && filtro.Hasta.HasValue && filtro.Desde > filtro.Hasta)
            {
                MostrarError("La fecha \"desde\" no puede ser posterior a la fecha \"hasta\".");
                return null;
            }

            filtro.IdMedico = int.Parse(ddlMedico.SelectedValue);
            filtro.IdEspecialidad = int.Parse(ddlEspecialidad.SelectedValue);
            filtro.Paciente = txtPaciente.Text.Trim();

            switch (ddlEstado.SelectedValue)
            {
                case "nuevo": filtro.Estado = EstadoTurno.Nuevo; break;
                case "reprogramado": filtro.Estado = EstadoTurno.Reprogramado; break;
                case "cerrado": filtro.Estado = EstadoTurno.Cerrado; break;
                case "noasistio": filtro.Estado = EstadoTurno.NoAsistio; break;
                case "cancelado": filtro.Estado = EstadoTurno.Cancelado; break;
            }

            // Acepta "1001", "#1001" o "T-1001": se toman solo los dígitos.
            string numero = new string(txtNumeroTurno.Text.Where(char.IsDigit).ToArray());
            if (txtNumeroTurno.Text.Trim() != "")
            {
                int numeroTurno;
                if (!int.TryParse(numero, out numeroTurno))
                {
                    MostrarError("El número de turno debe ser numérico (ejemplo: 1001).");
                    return null;
                }
                filtro.NumeroTurno = numeroTurno;
            }

            return filtro;
        }

        /// <summary>
        /// Ejecuta la búsqueda con los filtros actuales y muestra la página actual.
        /// </summary>
        private void Buscar()
        {
            pnlError.Visible = false;

            FiltroTurnos filtro = LeerFiltros();
            if (filtro == null)
            {
                MostrarResultados(new List<Turno>());
                return;
            }

            List<Turno> turnos;
            try
            {
                turnos = new TurnoNegocio().buscar(filtro);
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo realizar la búsqueda: " + ex.Message);
                turnos = new List<Turno>();
            }

            MostrarResultados(turnos);
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
        }

        // =====================================================================
        // Tabla y paginación
        // =====================================================================

        private void MostrarResultados(List<Turno> turnos)
        {
            int porPagina = int.Parse(ddlPorPagina.SelectedValue);
            int totalPaginas = Math.Max(1, (int)Math.Ceiling(turnos.Count / (double)porPagina));
            if (PaginaActual > totalPaginas) PaginaActual = totalPaginas;
            if (PaginaActual < 1) PaginaActual = 1;

            List<Turno> pagina = turnos.Skip((PaginaActual - 1) * porPagina).Take(porPagina).ToList();

            rptTurnos.DataSource = pagina.Select(ArmarFila).ToList();
            rptTurnos.DataBind();
            rptTurnos.Visible = pagina.Count > 0;
            pnlSinTurnos.Visible = pagina.Count == 0;

            int primero = turnos.Count == 0 ? 0 : (PaginaActual - 1) * porPagina + 1;
            int ultimo = (PaginaActual - 1) * porPagina + pagina.Count;
            lblRangoMostrado.Text = primero + " - " + ultimo;
            lblTotalRegistros.Text = turnos.Count.ToString();

            MostrarPaginador(totalPaginas);
        }

        /// <summary>
        /// Muestra hasta 7 botones de página alrededor de la actual (siempre incluye la primera y la última).
        /// </summary>
        private void MostrarPaginador(int totalPaginas)
        {
            List<int> numeros = new List<int>();
            for (int i = 1; i <= totalPaginas; i++)
            {
                bool cerca = Math.Abs(i - PaginaActual) <= 2;
                if (totalPaginas <= 7 || i == 1 || i == totalPaginas || cerca)
                    numeros.Add(i);
            }

            rptPaginas.DataSource = numeros.Select(n => new { Numero = n, Css = n == PaginaActual ? "active" : "" }).ToList();
            rptPaginas.DataBind();

            btnPaginaAnterior.Enabled = PaginaActual > 1;
            btnPaginaSiguiente.Enabled = PaginaActual < totalPaginas;
        }

        /// <summary>
        /// Convierte un turno en los campos que espera el Repeater rptTurnos.
        /// </summary>
        private object ArmarFila(Turno turno)
        {
            string filaCss = "";
            bool puedeReprogramar = false;
            bool puedeCancelar = false;

            switch (turno.Estado)
            {
                case EstadoTurno.Nuevo:
                case EstadoTurno.Reprogramado:
                    puedeReprogramar = true;
                    puedeCancelar = true;
                    break;
                case EstadoTurno.NoAsistio:
                    filaCss = "row-inactivo";
                    puedeReprogramar = true;
                    break;
                case EstadoTurno.Cerrado:
                    filaCss = "row-inactivo";
                    break;
                case EstadoTurno.Cancelado:
                    filaCss = "row-cancelado";
                    puedeReprogramar = true;
                    break;
            }

            return new
            {
                IdTurno = turno.Id,
                NumeroTurno = "#" + turno.NumeroTurno,
                FechaHora = turno.Fecha.ToString("dd/MM/yyyy") + " • " + turno.HoraTexto,
                Subtexto = turno.Estado == EstadoTurno.Cancelado ? "Cupo liberado" : "Turno " + turno.Medico.TurnoTrabajo.Nombre,
                PacienteNombre = turno.Paciente.NombreCompleto,
                PacienteDni = FormatearDni(turno.Paciente.Dni),
                Contacto = string.IsNullOrEmpty(turno.Paciente.Telefono) ? turno.Paciente.Email : turno.Paciente.Telefono,
                MedicoNombre = turno.Medico.NombreCompleto,
                MedicoMatricula = turno.Medico.Matricula,
                Especialidad = turno.Especialidad.Descripcion,
                EstadoTexto = TextoEstado(turno.Estado),
                EstadoCss = CssEstado(turno.Estado),
                EstadoIcono = IconoEstado(turno.Estado),
                FilaCss = filaCss,
                PuedeReprogramar = puedeReprogramar,
                PuedeCancelar = puedeCancelar
            };
        }

        private static string TextoEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "Reprogramado";
                case EstadoTurno.Cancelado: return "Cancelado";
                case EstadoTurno.NoAsistio: return "No asistió";
                case EstadoTurno.Cerrado: return "Cerrado";
                default: return "Nuevo";
            }
        }

        private static string CssEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "badge-estado-reprogramado";
                case EstadoTurno.Cancelado: return "badge-estado-cancelado";
                case EstadoTurno.NoAsistio: return "badge-estado-no-asistio";
                case EstadoTurno.Cerrado: return "badge-estado-cerrado";
                default: return "badge-estado-nuevo";
            }
        }

        private static string IconoEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "history";
                case EstadoTurno.Cancelado: return "cancel";
                case EstadoTurno.NoAsistio: return "person_off";
                case EstadoTurno.Cerrado: return "check_circle";
                default: return "fiber_new";
            }
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
        // Modal de detalle
        // =====================================================================

        private void MostrarDetalle(int idTurno)
        {
            Turno turno = new TurnoNegocio().buscarPorId(idTurno);
            if (turno == null)
            {
                MostrarError("El turno seleccionado ya no existe.");
                return;
            }

            lblDetalleNumero.Text = turno.NumeroTurno.ToString();
            lblDetalleEstado.Text = TextoEstado(turno.Estado);
            lblDetalleEstado.CssClass = "badge-estado " + CssEstado(turno.Estado);

            lblDetallePaciente.Text = turno.Paciente.NombreCompleto;
            lblDetalleDni.Text = FormatearDni(turno.Paciente.Dni);
            lblDetalleTelefono.Text = string.IsNullOrEmpty(turno.Paciente.Telefono) ? "No registrado" : turno.Paciente.Telefono;
            lblDetalleEmail.Text = turno.Paciente.Email;
            lblDetalleDireccion.Text = string.IsNullOrEmpty(turno.Paciente.Direccion) ? "No registrada" : turno.Paciente.Direccion;

            lblDetalleMedico.Text = turno.Medico.NombreCompleto;
            lblDetalleMatricula.Text = turno.Medico.Matricula;
            lblDetalleEspecialidad.Text = turno.Especialidad.Descripcion;
            lblDetalleTurnoTrabajo.Text = turno.Medico.TurnoTrabajo.ToString();
            lblDetalleFechaHora.Text = turno.Fecha.ToString("dd/MM/yyyy") + " • " + turno.HoraTexto;
            lblDetalleMotivo.Text = string.IsNullOrEmpty(turno.Observaciones) ? "Sin observaciones" : turno.Observaciones;

            ClientScript.RegisterStartupScript(GetType(), "abrirModal",
                "document.addEventListener('DOMContentLoaded', function () { abrirModal('modalDetalle'); });", true);
        }

        // =====================================================================
        // Eventos
        // =====================================================================

        protected void btnBuscarTurnos_Click(object sender, EventArgs e)
        {
            PaginaActual = 1;
            Buscar();
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            FiltrosPorDefecto();
            PaginaActual = 1;
            Buscar();
        }

        protected void rptTurnos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idTurno = int.Parse((string)e.CommandArgument);

            switch (e.CommandName)
            {
                case "VerDetalle":
                    try
                    {
                        MostrarDetalle(idTurno);
                    }
                    catch (Exception ex)
                    {
                        MostrarError("No se pudo cargar el detalle del turno: " + ex.Message);
                    }
                    break;

                case "Reprogramar":
                    // TODO: redirigir a la pantalla de reprogramación (ej: ReprogramarTurno.aspx?id=...).
                    break;

                case "Cancelar":
                    // TODO: cargar hfIdTurnoCancelar y los lblCancelar..., y abrir 'modalCancelar'.
                    break;
            }
        }

        protected void btnConfirmarCancelacion_Click(object sender, EventArgs e)
        {
            // TODO: validar el motivo, cancelar el turno hfIdTurnoCancelar.Value y notificar si chkNotificarPaciente.Checked.
        }

        protected void ddlPorPagina_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            Buscar();
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            PaginaActual--;
            Buscar();
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            PaginaActual++;
            Buscar();
        }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "IrAPagina")
            {
                PaginaActual = int.Parse((string)e.CommandArgument);
                Buscar();
            }
        }
    }
}
