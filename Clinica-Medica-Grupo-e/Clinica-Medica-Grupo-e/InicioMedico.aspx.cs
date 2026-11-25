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
    public partial class InicioMedico : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        // Datos de la carga actual (se completan en CargarPagina).
        private Medico medico;
        private List<Turno> turnosHoy = new List<Turno>();

        // Filtro elegido en la agenda: "Todos", "Nuevos" o "Reprogramados".
        private string Filtro
        {
            get { return Session["InicioMedico_Filtro"] == null ? "Todos" : (string)Session["InicioMedico_Filtro"]; }
            set { Session["InicioMedico_Filtro"] = value; }
        }
        // Id del turno que se muestra como "Próximo turno" (lo usan sus botones).
        private int IdProximoTurno
        {
            get { return Session["InicioMedico_IdProximo"] == null ? 0 : (int)Session["InicioMedico_IdProximo"]; }
            set { Session["InicioMedico_IdProximo"] = value; }
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            OcultarSinDatos();

            if (!IsPostBack)
            {
                // La Session no se borra sola: cada visita arranca con el filtro "Todos".
                Session.Remove("InicioMedico_Filtro");
                Session.Remove("InicioMedico_IdProximo");
                CargarPagina();
            }
        }

        private int ObtenerIdMedico()
        {
            Usuario usuario = Session["Usuario"] as Usuario;
            if (usuario == null) return 0;

            Medico logueado = new MedicoNegocio().buscarPorIdUsuario(usuario.Id);
            return logueado != null ? logueado.Id : 0;
        }

        //private int ObtenerIdMedico()
        //{
        //    // TODO login: cuando esté el inicio de sesión, descomentar estas dos líneas y borrar el resto del método.
        //    // Medico logueado = Session["medicoLogueado"] as Medico;
        //    //if (logueado != null) return logueado.Id;

        //    int idMedico;
        //    if (int.TryParse(Request.QueryString["idMedico"], out idMedico))
        //        return idMedico;

        //    // Respaldo para probar sin login: el primer médico activo.
        //    List<Medico> activos = new MedicoNegocio().listar(true);
        //    return activos.Count > 0 ? activos[0].Id : 0;
        //}

        private void CargarPagina()
        {
            try
            {
                int idMedico = ObtenerIdMedico();
                medico = new MedicoNegocio().buscarPorId(idMedico);
                if (medico == null)
                {
                    MostrarError("No se encontró el médico con Id " + idMedico + ".");
                    return;
                }

                // Una sola consulta: todos los turnos del médico para hoy, ordenados por hora.
                turnosHoy = new TurnoNegocio().listarPorMedico(medico.Id, DateTime.Today, DateTime.Today);
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo leer la agenda desde la base de datos: " + ex.Message);
                return;
            }

            pnlError.Visible = false;
            phContenido.Visible = true;

            MostrarBienvenida();
            MostrarIndicadores();
            MostrarProximoTurno();
            MostrarAgenda();
            MostrarAtendidos();
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
            phContenido.Visible = false;
        }






        // Lo que la base de datos no guarda se oculta (queda en el .aspx para más adelante).
        private void OcultarSinDatos()
        {
            btnPausarAtencion.Visible = false;
            btnBusquedaHC.Visible = false;
            btnAbrirHC.Visible = false;
            btnAvisarRecepcion.Visible = false;
            spanKpiEnEspera.Visible = false;
            spanProximoLlegada.Visible = false;
        }


        // ----- Bienvenida -----
        private void MostrarBienvenida()
        {
            int hora = DateTime.Now.Hour;
            string saludo = hora < 12 ? "Buenos días" : (hora < 20 ? "Buenas tardes" : "Buenas noches");
            lblSaludoDoctor.Text = saludo + ", Dr/a. " + medico.Apellido;

            lblEstadoAtencion.Text = medico.Activo ? "Médico activo" : "Médico inactivo";

            // "martes 24 de noviembre de 2026" -> "Martes 24 de noviembre de 2026"
            string fecha = DateTime.Today.ToString("dddd d 'de' MMMM 'de' yyyy", Cultura);
            lblFechaLarga.Text = char.ToUpper(fecha[0], Cultura) + fecha.Substring(1);

            lblConsultorioTurno.Text = medico.TurnoTrabajo != null ? "Turno " + medico.TurnoTrabajo.Nombre : "Sin turno de trabajo";
            lblEspecialidad.Text = medico.EspecialidadesTexto;

            // Nombre y especialidad en el encabezado de la página maestra.
            MedicoMaster master = Master as MedicoMaster;
            if (master != null)
                master.MostrarMedico(medico.NombreCompleto, medico.EspecialidadesTexto);
        }

        private void MostrarIndicadores()
        {
            int cancelados = turnosHoy.Count(t => t.Estado == EstadoTurno.Cancelado);
            int programados = turnosHoy.Count - cancelados;
            int completados = turnosHoy.Count(t => t.Estado == EstadoTurno.Cerrado);
            int pendientes = turnosHoy.Count(t => t.EsPendiente);
            int reprogramados = turnosHoy.Count(t => t.Estado == EstadoTurno.Reprogramado);

            // Turnos programados
            lblKpiProgramados.Text = programados.ToString();
            lblHorarioAtencion.Text = medico.TurnoTrabajo != null
                ? medico.TurnoTrabajo.HoraEntrada.ToString("00") + ":00 a " + medico.TurnoTrabajo.HoraSalida.ToString("00") + ":00 hs"
                : "Sin horario";
            lblKpiCancelados.Text = cancelados + (cancelados == 1 ? " cancelado" : " cancelados");
            lblKpiCancelados.Visible = cancelados > 0;

            // Completados
            lblKpiCompletados.Text = completados.ToString();
            lblKpiCompletadosTotal.Text = "de " + programados;
            int porcentaje = programados > 0 ? completados * 100 / programados : 0;
            lblKpiPorcentaje.Text = porcentaje + "%";
            pnlBarraProgreso.Style["width"] = porcentaje + "%";

            // Pendientes
            lblKpiPendientes.Text = pendientes.ToString();
            lblKpiReprogramados.Text = reprogramados + (reprogramados == 1 ? " reprogramado" : " reprogramados");
            lblKpiReprogramados.Visible = reprogramados > 0;
        }

        private void MostrarProximoTurno()
        {
            Turno proximo = turnosHoy.FirstOrDefault(t => t.EsPendiente);
            if (proximo == null)
            {
                IdProximoTurno = 0;
                pnlProximoTurno.Visible = false;
                return;
            }

            IdProximoTurno = proximo.Id;
            pnlProximoTurno.Visible = true;

            Paciente p = proximo.Paciente;
            lblProximoTurnoHora.Text = proximo.HoraTexto;
            lblProximoPacienteIniciales.Text = Iniciales(p.Nombre, p.Apellido);
            lblProximoPacienteNombre.Text = Server.HtmlEncode(p.Nombre + " " + p.Apellido);
            lblProximoPacienteDni.Text = Formato.Dni(p.Dni);
            lblProximoPacienteEdad.Text = p.Edad + " años (" + p.FechaNacimiento.ToString("dd/MM/yyyy") + ")";
            lblProximoPacienteCobertura.Text = Server.HtmlEncode(TextoCobertura(proximo));
            lblProximoMotivo.Text = string.IsNullOrWhiteSpace(proximo.Observaciones)
                ? "Sin observaciones."
                : Server.HtmlEncode(proximo.Observaciones);
            lblProximoUltimaVisita.Text = Server.HtmlEncode(TextoUltimaVisita(p));
        }


        private static string Iniciales(string nombre, string apellido)
        {
            string i1 = string.IsNullOrEmpty(nombre) ? "" : nombre.Substring(0, 1);
            string i2 = string.IsNullOrEmpty(apellido) ? "" : apellido.Substring(0, 1);
            return (i1 + i2).ToUpper();
        }

        // "OSDE • Plan 210", "OSDE" o "Particular".
        private static string TextoCobertura(Turno t)
        {
            if (t.ObraSocial == null || string.IsNullOrEmpty(t.ObraSocial.Nombre))
                return "Particular";

            string texto = t.ObraSocial.Nombre;
            if (t.Plan != null && !string.IsNullOrEmpty(t.Plan.NombrePlan))
                texto += " • " + t.Plan.NombrePlan;
            return texto;
        }

        // Último turno Cerrado del paciente antes de hoy, con cualquier médico.
        private string TextoUltimaVisita(Paciente p)
        {
            try
            {
                FiltroTurnos filtro = new FiltroTurnos();
                filtro.Paciente = p.Dni;
                filtro.Estado = EstadoTurno.Cerrado;
                filtro.Hasta = DateTime.Today.AddDays(-1);

                // buscar() ordena por fecha y hora: el último de la lista es el más reciente.
                Turno ultimo = new TurnoNegocio().buscar(filtro).LastOrDefault();
                if (ultimo == null)
                    return "Primera consulta en la clínica";

                return "Última visita: " + ultimo.Fecha.ToString("d 'de' MMMM 'de' yyyy", Cultura)
                    + " • Dr/a. " + ultimo.Medico.Apellido + " (" + ultimo.Especialidad.Descripcion + ")";
            }
            catch
            {
                // Si esta consulta falla, el resto de la página se muestra igual.
                return "Última visita: sin datos";
            }
        }

        private void MostrarAgenda()
        {
            List<Turno> restantes = turnosHoy
                .Where(t => !t.EsResuelto)
                .ToList();

            int nuevos = restantes.Count(t => t.Estado == EstadoTurno.Nuevo);
            int reprogramados = restantes.Count(t => t.Estado == EstadoTurno.Reprogramado);

            // Filtros: el texto lleva la cantidad y el elegido se marca.
            btnFiltroTodos.Text = "Todos (" + restantes.Count + ")";
            btnFiltroNuevos.Text = "Nuevos (" + nuevos + ")";
            btnFiltroReprogramados.Text = "Reprogramados (" + reprogramados + ")";
            MarcarFiltro(btnFiltroTodos, Filtro == "Todos");
            MarcarFiltro(btnFiltroNuevos, Filtro == "Nuevos");
            MarcarFiltro(btnFiltroReprogramados, Filtro == "Reprogramados");

            // Resumen: cuántos pacientes quedan y en qué rango horario.
            List<Turno> pendientes = restantes
                .Where(t => t.EsPendiente)
                .ToList();
            lblResumenAgenda.Text = pendientes.Count == 0
                ? "No quedan pacientes por atender hoy."
                : pendientes.Count + (pendientes.Count == 1 ? " paciente citado" : " pacientes citados")
                  + " de " + pendientes.First().Hora.ToString("00") + ":00 a "
                  + (pendientes.Last().Hora + 1).ToString("00") + ":00 hs";

            // Aplicar el filtro elegido.
            if (Filtro == "Nuevos")
                restantes = restantes.Where(t => t.Estado == EstadoTurno.Nuevo).ToList();
            else if (Filtro == "Reprogramados")
                restantes = restantes.Where(t => t.Estado == EstadoTurno.Reprogramado).ToList();

            rptTurnosRestantes.DataSource = restantes.Select(t => new
            {
                IdTurno = t.Id,
                Hora = t.HoraTexto,
                PacienteNombre = t.Paciente.NombreCompleto,
                PacienteDni = Formato.Dni(t.Paciente.Dni),
                Cobertura = TextoCobertura(t),
                Motivo = string.IsNullOrWhiteSpace(t.Observaciones) ? "-" : t.Observaciones,
                EstadoTexto = TextoEstado(t.Estado),
                EstadoCss = CssEstado(t.Estado),
                FilaCss = CssFila(t)
            }).ToList();
            rptTurnosRestantes.DataBind();

            pnlSinTurnos.Visible = restantes.Count == 0;
        }

        private static string TextoEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Nuevo: return "Nuevo";
                case EstadoTurno.Reprogramado: return "Reprogramado";
                case EstadoTurno.Cancelado: return "Cancelado";
                case EstadoTurno.NoAsistio: return "No asistió";
                case EstadoTurno.Cerrado: return "Atendido";
                default: return estado.ToString();
            }
        }

        private static string CssEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "cl-badge-reprogramado";
                case EstadoTurno.Cancelado:
                case EstadoTurno.NoAsistio: return "cl-badge-cancelado";
                case EstadoTurno.Cerrado: return "cl-badge-cerrado";
                default: return "cl-badge-nuevo";
            }
        }

        // La fila del próximo turno se resalta; las reprogramadas y canceladas tienen su propio fondo.
        private string CssFila(Turno t)
        {
            if (t.Id == IdProximoTurno) return "cl-schedule-row-active";
            if (t.Estado == EstadoTurno.Reprogramado) return "cl-schedule-row-reprogramado";
            if (t.Estado == EstadoTurno.Cancelado) return "cl-schedule-row-cancelado";
            return "";
        }

        // Las mismas clases que tiene el .aspx: el filtro elegido va en blanco con sombra.
        private void MarcarFiltro(LinkButton boton, bool elegido)
        {
            boton.CssClass = elegido
                ? "btn btn-sm bg-white text-primary fw-semibold shadow-sm px-3 rounded-2"
                : "btn btn-sm btn-link text-secondary text-decoration-none fw-semibold px-3";
        }

        private void MostrarAtendidos()
        {
            List<Turno> resueltos = turnosHoy.Where(t => t.EsResuelto).ToList();

            lblCantidadAtendidos.Text = "Turnos ya atendidos hoy (" + resueltos.Count + ")";
            lblRangoAtendidos.Text = resueltos.Count == 0
                ? ""
                : "• " + resueltos.First().Hora.ToString("00") + ":00 a "
                  + (resueltos.Last().Hora + 1).ToString("00") + ":00 hs";

            rptTurnosAtendidos.DataSource = resueltos.Select(t => new
            {
                Hora = t.HoraTexto,
                PacienteNombre = t.Paciente.NombreCompleto,
                Cobertura = TextoCobertura(t),
                Observacion = Resumir(t.Observaciones, 60),
                EstadoTexto = TextoEstado(t.Estado),
                EstadoCss = CssEstado(t.Estado)
            }).ToList();
            rptTurnosAtendidos.DataBind();
        }

        // Corta un texto largo para que entre en una fila: "Control de rutina y revisión de..."
        private static string Resumir(string texto, int maximo)
        {
            if (string.IsNullOrWhiteSpace(texto))
                return "Sin observaciones";
            return texto.Length <= maximo ? texto : texto.Substring(0, maximo) + "...";
        }



        protected void btnPausarAtencion_Click(object sender, EventArgs e) { }
        protected void btnBusquedaHC_Click(object sender, EventArgs e) { }

        // ----- Próximo turno -----
        protected void btnLlamarAtender_Click(object sender, EventArgs e)
        {
            if (IdProximoTurno == 0)
                return;
            // TODO: AtencionTurno.aspx todavía no existe (diseño "atencionturno").
            Response.Redirect("~/AtencionTurno.aspx?id=" + IdProximoTurno);
        }

        protected void btnAbrirHC_Click(object sender, EventArgs e) { }
        protected void btnAvisarRecepcion_Click(object sender, EventArgs e) { }
        protected void btnReprogramarTurno_Click(object sender, EventArgs e)
        {
            if (IdProximoTurno == 0)
                return;
            // Misma convención que Turnos.aspx: ReprogramarTurno lee el Id de Session["idReprogTurno"].
            Session.Add("idReprogTurno", IdProximoTurno);
            Response.Redirect("~/ReprogramarTurno.aspx");
        }
        

        

        

        

        



        // ----- Agenda -----
        protected void btnFiltroTodos_Click(object sender, EventArgs e)
        {
            Filtro = "Todos";
            CargarPagina();
        }
        protected void btnFiltroNuevos_Click(object sender, EventArgs e)
        {
            Filtro = "Nuevos";
            CargarPagina();
        }
        protected void btnFiltroReprogramados_Click(object sender, EventArgs e)
        {
            Filtro = "Reprogramados";
            CargarPagina();
        }
        protected void btnActualizarLista_Click(object sender, EventArgs e)
        {
            CargarPagina();
        }

        protected void rptTurnosRestantes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "VerFicha")
            {
                // TODO: AtencionTurno.aspx todavía no existe.
                Response.Redirect("~/AtencionTurno.aspx?id=" + e.CommandArgument);
            }
        }
    }
}
