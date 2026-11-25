using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    
    public partial class InicioAdmin : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        // Largo del anillo de "Pacientes atendidos" (stroke-dasharray del <circle> en el .aspx).
        private const double LargoAnilloAtendidos = 88;

        // ESTADO DE LA PÁGINA (Session con prefijo "InicioAdmin_", se borra en el primer !IsPostBack).

        // Día que se está viendo (por defecto, hoy).
        private DateTime Fecha
        {
            get { return Session["InicioAdmin_Fecha"] == null ? DateTime.Today : (DateTime)Session["InicioAdmin_Fecha"]; }
            set { Session["InicioAdmin_Fecha"] = value; }
        }

        private int PaginaActual
        {
            get { return Session["InicioAdmin_Pagina"] == null ? 1 : (int)Session["InicioAdmin_Pagina"]; }
            set { Session["InicioAdmin_Pagina"] = value; }
        }

        // Texto de búsqueda aplicado (se aplica con Enter o con el botón Refrescar).
        private string Busqueda
        {
            get { return Session["InicioAdmin_Busqueda"] as string ?? ""; }
            set { Session["InicioAdmin_Busqueda"] = value; }
        }

        private bool EsHoy
        {
            get { return Fecha.Date == DateTime.Today; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LimpiarEstado();
                MostrarSaludo();
                CargarProfesionales();
                CargarPagina();
            }
        }

        private void LimpiarEstado()
        {
            Session.Remove("InicioAdmin_Fecha");
            Session.Remove("InicioAdmin_Pagina");
            Session.Remove("InicioAdmin_Busqueda");
        }

        // "Buenos días, María" según la hora y el usuario logueado.
        private void MostrarSaludo()
        {
            int hora = DateTime.Now.Hour;
            string saludo = hora < 12 ? "Buenos días" : hora < 20 ? "Buenas tardes" : "Buenas noches";

            Usuario usuario = Session["Usuario"] as Usuario;
            string nombre = usuario == null ? "" : (usuario.Nombre ?? usuario.NombreUsuario ?? "").Trim();
            lblSaludo.Text = Server.HtmlEncode(nombre == "" ? saludo : saludo + ", " + nombre);
        }

        // Médicos activos para el filtro (la opción "Todos los profesionales" está en el .aspx).
        private void CargarProfesionales()
        {
            try
            {
                List<Medico> medicos = new MedicoNegocio().listarConDetalle()
                    .Where(m => m.Activo)
                    .OrderBy(m => m.Apellido)
                    .ThenBy(m => m.Nombre)
                    .ToList();

                foreach (Medico m in medicos)
                    ddlProfesional.Items.Add(new ListItem(m.Apellido + ", " + m.Nombre, m.Id.ToString()));
            }
            catch (Exception ex)
            {
                MostrarError("No se pudieron cargar los profesionales: " + ex.Message);
            }
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = Server.HtmlEncode(mensaje);
            pnlError.Visible = true;
        }

        // ----- Carga -----

        private void CargarPagina()
        {
            pnlError.Visible = false;
            MostrarFecha();

            List<Turno> turnosDia;
            List<Turno> turnosDiaAnterior;
            try
            {
                TurnoNegocio negocio = new TurnoNegocio();
                turnosDia = negocio.buscar(new FiltroTurnos { Desde = Fecha, Hasta = Fecha });
                turnosDiaAnterior = negocio.buscar(new FiltroTurnos { Desde = Fecha.AddDays(-1), Hasta = Fecha.AddDays(-1) });
            }
            catch (Exception ex)
            {
                MostrarError("No se pudieron leer los turnos: " + ex.Message);
                turnosDia = new List<Turno>();
                turnosDiaAnterior = new List<Turno>();
            }

            MostrarIndicadores(turnosDia, turnosDiaAnterior);
            MostrarTabla(turnosDia);
        }

        private void MostrarFecha()
        {
            string fecha = Fecha.ToString("dddd d 'de' MMMM 'de' yyyy", Cultura);
            lblFechaLarga.Text = char.ToUpper(fecha[0], Cultura) + fecha.Substring(1);
            txtFecha.Text = Fecha.ToString("yyyy-MM-dd");

            // Los títulos dicen "hoy" solo si se está viendo el día actual.
            string dia = "del " + Fecha.ToString("dd/MM");
            lblKpiTurnosTitulo.Text = EsHoy ? "Turnos de hoy" : "Turnos " + dia;
            lblKpiCanceladosTitulo.Text = EsHoy ? "Cancelados hoy" : "Cancelados " + dia;
            lblTituloTabla.Text = lblKpiTurnosTitulo.Text;
            btnFechaHoy.Visible = !EsHoy;
        }

        // ----- Indicadores -----

        private void MostrarIndicadores(List<Turno> turnos, List<Turno> diaAnterior)
        {
            int total = turnos.Count;
            int pendientes = turnos.Count(t => t.EsPendiente);
            int cancelados = turnos.Count(t => t.Estado == EstadoTurno.Cancelado);
            int atendidos = turnos.Count(t => t.Estado == EstadoTurno.Cerrado);

            // Turnos del día y diferencia con el día anterior
            lblKpiTurnosHoy.Text = total.ToString("N0", Cultura);
            int diferencia = total - diaAnterior.Count;
            string referencia = EsHoy ? "ayer" : "el día anterior";
            if (diferencia == 0)
            {
                lblKpiVariacion.Text = "Igual que " + referencia;
                lblKpiVariacionIcono.Text = "trending_flat";
                divKpiVariacion.Attributes["class"] = "kpi-foot d-flex align-items-center gap-1 text-secondary";
            }
            else
            {
                lblKpiVariacion.Text = (diferencia > 0 ? "+" : "") + diferencia.ToString("N0", Cultura) + " respecto a " + referencia;
                lblKpiVariacionIcono.Text = diferencia > 0 ? "trending_up" : "trending_down";
                divKpiVariacion.Attributes["class"] = "kpi-foot d-flex align-items-center gap-1 "
                    + (diferencia > 0 ? "text-cl-success" : "text-danger");
            }

            // Pendientes: Nuevo o Reprogramado. La barra muestra qué parte del día falta atender.
            lblKpiPendientes.Text = pendientes.ToString("N0", Cultura);
            pnlBarraPendientes.Style["width"] = PorcentajeCss(pendientes, total);

            // Cancelados
            lblKpiCancelados.Text = cancelados.ToString("N0", Cultura);
            lblKpiCanceladosAviso.Text = "Sobre " + total.ToString("N0", Cultura) + (total == 1 ? " turno del día" : " turnos del día");
            lblKpiCanceladosPorcentaje.Text = Porcentaje(cancelados, total);

            // Atendidos (Cerrado)
            lblKpiAtendidos.Text = atendidos.ToString("N0", Cultura);
            lblKpiAtendidosPorcentaje.Text = Porcentaje(atendidos, total) + " del total diario";
            double fraccion = total == 0 ? 0 : (double)atendidos / total;
            cirKpiAtendidos.Attributes["stroke-dashoffset"] =
                (LargoAnilloAtendidos - LargoAnilloAtendidos * fraccion).ToString("0.#", CultureInfo.InvariantCulture);
        }

        // ----- Tabla -----

        private void MostrarTabla(List<Turno> turnosDia)
        {
            List<Turno> filtrados = Filtrar(turnosDia);

            int filasPorPagina;
            if (!int.TryParse(ddlFilasPorPagina.SelectedValue, out filasPorPagina) || filasPorPagina <= 0)
                filasPorPagina = 8;

            int totalPaginas = Math.Max(1, (int)Math.Ceiling(filtrados.Count / (double)filasPorPagina));
            if (PaginaActual > totalPaginas) PaginaActual = totalPaginas;
            if (PaginaActual < 1) PaginaActual = 1;

            List<Turno> pagina = filtrados
                .Skip((PaginaActual - 1) * filasPorPagina)
                .Take(filasPorPagina)
                .ToList();

            // El "próximo turno" (fila resaltada) solo tiene sentido si se está viendo el día de hoy.
            int idProximo = 0;
            if (EsHoy)
            {
                Turno proximo = turnosDia
                    .Where(t => t.EsPendiente && t.Hora >= DateTime.Now.Hour)
                    .OrderBy(t => t.Hora)
                    .FirstOrDefault();
                if (proximo != null) idProximo = proximo.Id;
            }

            rptTurnosHoy.DataSource = pagina.Select(t => ArmarFila(t, t.Id == idProximo)).ToList();
            rptTurnosHoy.DataBind();
            rptTurnosHoy.Visible = pagina.Count > 0;
            pnlSinTurnos.Visible = pagina.Count == 0;

            lblCantidadMostrada.Text = pagina.Count.ToString();
            lblCantidadTotal.Text = filtrados.Count.ToString();

            int desde = filtrados.Count == 0 ? 0 : (PaginaActual - 1) * filasPorPagina + 1;
            int hasta = Math.Min(PaginaActual * filasPorPagina, filtrados.Count);
            lblResumenPaginacion.Text = "Mostrando " + desde + " - " + hasta + " de " + filtrados.Count
                + (filtrados.Count == 1 ? " turno" : " turnos");
            lblPaginaActual.Text = PaginaActual.ToString();
            lblTotalPaginas.Text = totalPaginas.ToString();

            btnPaginaAnterior.Enabled = PaginaActual > 1;
            btnPaginaSiguiente.Enabled = PaginaActual < totalPaginas;
            btnPaginaAnterior.CssClass = PaginaActual > 1 ? "btn-page" : "btn-page text-secondary";
            btnPaginaSiguiente.CssClass = PaginaActual < totalPaginas ? "btn-page" : "btn-page text-secondary";

            rptPaginas.DataSource = Enumerable.Range(1, totalPaginas)
                .Select(n => new { Numero = n, Css = n == PaginaActual ? "active" : "" })
                .ToList();
            rptPaginas.DataBind();
        }

        // Filtros de la tabla: estado, profesional y búsqueda por DNI o apellido/nombre.
        private List<Turno> Filtrar(List<Turno> turnos)
        {
            IEnumerable<Turno> resultado = turnos;

            EstadoTurno? estado = EstadoElegido();
            if (estado.HasValue)
                resultado = resultado.Where(t => t.Estado == estado.Value);

            int idMedico;
            if (int.TryParse(ddlProfesional.SelectedValue, out idMedico) && idMedico > 0)
                resultado = resultado.Where(t => t.Medico.Id == idMedico);

            string texto = Busqueda.Trim();
            if (texto != "")
            {
                string dni = texto.Replace(".", "");
                CompareInfo comparar = Cultura.CompareInfo;
                CompareOptions opciones = CompareOptions.IgnoreCase | CompareOptions.IgnoreNonSpace;

                resultado = resultado.Where(t =>
                    (t.Paciente.Dni ?? "").Replace(".", "").Contains(dni)
                    || comparar.IndexOf(t.Paciente.Apellido ?? "", texto, opciones) >= 0
                    || comparar.IndexOf(t.Paciente.Nombre ?? "", texto, opciones) >= 0
                    || comparar.IndexOf((t.Paciente.Apellido ?? "") + ", " + (t.Paciente.Nombre ?? ""), texto, opciones) >= 0);
            }

            return resultado.OrderBy(t => t.Hora).ThenBy(t => t.Medico.Apellido).ToList();
        }

        private EstadoTurno? EstadoElegido()
        {
            switch (ddlEstado.SelectedValue)
            {
                case "nuevo": return EstadoTurno.Nuevo;
                case "cerrado": return EstadoTurno.Cerrado;
                case "reprogramado": return EstadoTurno.Reprogramado;
                case "noasistio": return EstadoTurno.NoAsistio;
                case "cancelado": return EstadoTurno.Cancelado;
                default: return null;
            }
        }

        // Una fila de la tabla (los campos que usa el ItemTemplate de rptTurnosHoy).
        private object ArmarFila(Turno t, bool esProximo)
        {
            bool cancelado = t.Estado == EstadoTurno.Cancelado;
            bool pendiente = t.EsPendiente;

            return new
            {
                IdTurno = t.Id,
                Hora = t.Hora.ToString("00") + ":00",
                PacienteIniciales = Iniciales(t.Paciente.Nombre, t.Paciente.Apellido),
                PacienteNombre = t.Paciente.Apellido + ", " + t.Paciente.Nombre,
                PacienteDetalle = "DNI " + Formato.Dni(t.Paciente.Dni) + " • " + TextoCobertura(t),
                MedicoNombre = "Dr/a. " + Inicial(t.Medico.Nombre) + ". " + t.Medico.Apellido,
                Especialidad = t.Especialidad.Descripcion,
                EstadoTexto = TextoEstado(t.Estado),
                EstadoCss = CssEstado(t.Estado),
                FilaCss = esProximo ? "row-highlight" : cancelado ? "row-cancelado" : "",
                AvatarCss = esProximo ? "avatar-circle-primary" : cancelado ? "avatar-circle-danger" : "",
                // Botón principal: turno pendiente -> Reprogramar; resuelto o cancelado -> Ver detalle.
                AccionTexto = pendiente ? "Reprogramar" : "Ver detalle",
                AccionComando = pendiente ? "Reprogramar" : "VerFicha",
                AccionCss = esProximo ? "btn-action-primary" : "btn-action-outline",
                // Menú ⋮: storedReprogramarTurno acepta todo menos Cerrado; CancelarTurno solo turnos pendientes.
                PuedeReprogramar = t.Estado != EstadoTurno.Cerrado,
                PuedeCancelar = pendiente
            };
        }

        protected void rptTurnosHoy_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idTurno;
            if (!int.TryParse(e.CommandArgument.ToString(), out idTurno))
                return;

            // Mismos caminos que Turnos.aspx.
            switch (e.CommandName)
            {
                case "VerFicha":
                    Response.Redirect("~/TurnoConfirmado.aspx?id=" + idTurno, false);
                    break;
                case "Reprogramar":
                    Session["idReprogTurno"] = idTurno;
                    Response.Redirect("~/ReprogramarTurno.aspx", false);
                    break;
                case "Cancelar":
                    Response.Redirect("~/CancelarTurno.aspx?id=" + idTurno, false);
                    break;
            }
        }

        // ----- Fecha -----

        // Muestra u oculta el campo para elegir otro día.
        protected void btnCambiarFecha_Click(object sender, EventArgs e)
        {
            pnlCambiarFecha.Visible = !pnlCambiarFecha.Visible;
            txtFecha.Text = Fecha.ToString("yyyy-MM-dd");
        }

        protected void btnVerFecha_Click(object sender, EventArgs e)
        {
            DateTime fecha;
            // TextMode="Date" envía la fecha como yyyy-MM-dd.
            if (!DateTime.TryParseExact(txtFecha.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha))
            {
                MostrarError("Elija una fecha válida.");
                return;
            }

            Fecha = fecha;
            PaginaActual = 1;
            pnlCambiarFecha.Visible = false;
            CargarPagina();
        }

        protected void btnFechaHoy_Click(object sender, EventArgs e)
        {
            Fecha = DateTime.Today;
            PaginaActual = 1;
            pnlCambiarFecha.Visible = false;
            CargarPagina();
        }

        // Sin datos en el sistema (no hay ingreso a sala): la tarjeta queda oculta en el .aspx.
        protected void btnRecepcionCheckin_Click(object sender, EventArgs e) { }

        // ----- Filtros -----

        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarPagina();
        }

        protected void ddlProfesional_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarPagina();
        }

        // Botón refrescar (y Enter en el buscador): aplica la búsqueda y vuelve a leer los turnos.
        protected void btnRefrescar_Click(object sender, EventArgs e)
        {
            Busqueda = txtBuscarTabla.Text;
            PaginaActual = 1;
            CargarPagina();
        }

        // ----- Paginación -----

        protected void ddlFilasPorPagina_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarPagina();
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            PaginaActual = PaginaActual - 1;
            CargarPagina();
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            PaginaActual = PaginaActual + 1;
            CargarPagina();
        }

        protected void rptPaginas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int numero;
            if (e.CommandName == "IrAPagina" && int.TryParse(e.CommandArgument.ToString(), out numero))
            {
                PaginaActual = numero;
                CargarPagina();
            }
        }

        // ----- Textos -----

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

        // "OSDE 310", "OSDE" o "Particular".
        private static string TextoCobertura(Turno t)
        {
            if (t.ObraSocial == null || string.IsNullOrEmpty(t.ObraSocial.Nombre))
                return "Particular";
            if (t.Plan != null && !string.IsNullOrEmpty(t.Plan.NombrePlan) && t.Plan.NombrePlan != t.ObraSocial.Nombre)
                return t.ObraSocial.Nombre + " " + t.Plan.NombrePlan;
            return t.ObraSocial.Nombre;
        }

        private static string Porcentaje(int cantidad, int total)
        {
            if (total == 0) return "0%";
            return (cantidad * 100.0 / total).ToString("0.#", Cultura) + "%";
        }

        // Para estilos CSS el decimal va con punto.
        private static string PorcentajeCss(int cantidad, int total)
        {
            double valor = total == 0 ? 0 : cantidad * 100.0 / total;
            return valor.ToString("0.#", CultureInfo.InvariantCulture) + "%";
        }

        private static string Iniciales(string nombre, string apellido)
        {
            return (Inicial(nombre) + Inicial(apellido)).ToUpper();
        }

        private static string Inicial(string texto)
        {
            return string.IsNullOrEmpty(texto) ? "" : texto.Substring(0, 1).ToUpper();
        }
    }
}
