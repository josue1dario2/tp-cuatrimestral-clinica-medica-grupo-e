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
    public partial class ReprogramarTurno : Page
    {
        // Hasta cuántos días hacia adelante se puede elegir una fecha nueva.
        private const int DiasMaximos = 60;


        // ESTADO DE LA PÁGINA (se guarda en Session para que sobreviva a los PostBack).
        // Todas las claves empiezan con "Reprog_" y se borran al entrar a la página (LimpiarEstado).


        private int IdTurno
        {
            get { return Session["Reprog_IdTurno"] == null ? 0 : (int)Session["Reprog_IdTurno"]; }
            set { Session["Reprog_IdTurno"] = value; }
        }

        // Datos del turno tal como está hoy en la base (no cambian mientras se usa la página).
        private int IdMedicoActual
        {
            get { return Session["Reprog_IdMedicoActual"] == null ? 0 : (int)Session["Reprog_IdMedicoActual"]; }
            set { Session["Reprog_IdMedicoActual"] = value; }
        }

        private DateTime FechaActual
        {
            get { return Session["Reprog_FechaActual"] == null ? DateTime.Today : (DateTime)Session["Reprog_FechaActual"]; }
            set { Session["Reprog_FechaActual"] = value; }
        }

        // true si el turno está Nuevo o Reprogramado (ocupa un horario que se va a liberar).
        // false si está Cancelado o No asistió: se reusa con una fecha nueva.
        private bool TurnoVigente
        {
            get { return Session["Reprog_TurnoVigente"] != null && (bool)Session["Reprog_TurnoVigente"]; }
            set { Session["Reprog_TurnoVigente"] = value; }
        }

        private int IdEspecialidad
        {
            get { return Session["Reprog_IdEspecialidad"] == null ? 0 : (int)Session["Reprog_IdEspecialidad"]; }
            set { Session["Reprog_IdEspecialidad"] = value; }
        }

        private int HoraActual
        {
            get { return Session["Reprog_HoraActual"] == null ? 0 : (int)Session["Reprog_HoraActual"]; }
            set { Session["Reprog_HoraActual"] = value; }
        }

        // Turno de trabajo del médico elegido en ddlMedico.
        private int HoraEntrada
        {
            get { return Session["Reprog_HoraEntrada"] == null ? 0 : (int)Session["Reprog_HoraEntrada"]; }
            set { Session["Reprog_HoraEntrada"] = value; }
        }

        private int HoraSalida
        {
            get { return Session["Reprog_HoraSalida"] == null ? 0 : (int)Session["Reprog_HoraSalida"]; }
            set { Session["Reprog_HoraSalida"] = value; }
        }

        // Primer día del mes que muestra el calendario.
        private DateTime MesVisible
        {
            get { return Session["Reprog_MesVisible"] == null ? PrimerDiaDelMes(DateTime.Today) : (DateTime)Session["Reprog_MesVisible"]; }
            set { Session["Reprog_MesVisible"] = value; }
        }

        // Lo que eligió la recepcionista (null = todavía nada).
        private DateTime? FechaElegida
        {
            get { return Session["Reprog_FechaElegida"] as DateTime?; }
            set { Session["Reprog_FechaElegida"] = value; }
        }

        private int? HoraElegida
        {
            get { return Session["Reprog_HoraElegida"] as int?; }
            set { Session["Reprog_HoraElegida"] = value; }
        }

        private int IdMedicoElegido
        {
            get
            {
                int id;
                return int.TryParse(ddlMedico.SelectedValue, out id) ? id : 0;
            }
        }


        // CARGA INICIAL


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // La Session no se borra sola: se descarta lo que haya quedado de una visita anterior.
                LimpiarEstado();

                object valorTurno = Session["idReprogTurno"];
                if (!(valorTurno is int))
                {
                    MostrarNoDisponible("No se indicó qué turno reprogramar. Volvé al listado y elegí uno.");
                    return;
                }

                try
                {
                    CargarDatosTurno((int)valorTurno);
                }
                catch (Exception ex)
                {
                    MostrarNoDisponible("No se pudo cargar el turno: " + ex.Message);
                }
            }
        }

        private void CargarDatosTurno(int idTurno)
        {
            Turno turno = new TurnoNegocio().buscarPorId(idTurno);
            if (turno == null)
            {
                MostrarNoDisponible("El turno seleccionado ya no existe.");
                return;
            }

            // Se puede reprogramar en cualquier estado menos Cerrado (ya atendido), igual que storedReprogramarTurno
            // y que el botón de Turnos.aspx. Un turno Cancelado o No asistió se reusa con una fecha nueva.
            if (turno.Estado == EstadoTurno.Cerrado)
            {
                MostrarNoDisponible("El turno #" + turno.NumeroTurno + " ya fue atendido y no se puede reprogramar.");
                return;
            }

            // Lo que no cambia mientras se usa la página
            IdTurno = turno.Id;
            hfIdTurno.Value = turno.Id.ToString();
            IdMedicoActual = turno.Medico.Id;
            FechaActual = turno.Fecha.Date;
            HoraActual = turno.Hora;
            IdEspecialidad = turno.Especialidad.Id;
            TurnoVigente = turno.Estado == EstadoTurno.Nuevo || turno.Estado == EstadoTurno.Reprogramado;

            CargarControles(turno);
            CargarComboMedicos(turno.Especialidad.Id, turno.Medico.Id);

            // Calendario: arranca en el mes de hoy, sin nada elegido
            MesVisible = PrimerDiaDelMes(DateTime.Today);
            FechaElegida = null;
            HoraElegida = null;
            RefrescarSeleccion();
        }

        // Columna izquierda (datos del turno actual).
        private void CargarControles(Turno turno)
        {
            lblBreadcrumbNumero.Text = turno.NumeroTurno.ToString();
            lblNumeroTurno.Text = turno.NumeroTurno.ToString();
            lblNotifNumero.Text = turno.NumeroTurno.ToString();
            lblEstadoActual.Text = TextoEstado(turno.Estado);
            lblEstadoTurno.Text = TurnoVigente
                ? "Turno activo / Requiere cambio de fecha"
                : "Turno " + TextoEstado(turno.Estado).ToLower() + " / Se reusa con una fecha nueva";

            Paciente paciente = turno.Paciente;
            lblPacienteIniciales.Text = Iniciales(paciente.Nombre, paciente.Apellido);
            lblPacienteNombre.Text = Server.HtmlEncode(paciente.Nombre) + "<br>" + Server.HtmlEncode(paciente.Apellido);
            lblPacienteDni.Text = Formato.Dni(paciente.Dni);
            lblPacienteEdad.Text = paciente.Edad + " años";
            lblPacienteTelefono.Text = TextoOGuion(paciente.Telefono);
            lblPacienteEmail.Text = TextoOGuion(paciente.Email);
            lblNotifEmail.Text = TextoOGuion(paciente.Email);

            lblPacienteCobertura.Text = turno.ObraSocial == null ? "Particular"
                : turno.ObraSocial.Nombre + (turno.Plan == null ? "" : " " + turno.Plan.NombrePlan);
            lblPacienteCredencial.Text = string.IsNullOrWhiteSpace(turno.NumeroAfiliado) ? "" : "Cred: " + turno.NumeroAfiliado;

            lblMedicoActual.Text = "Dr(a). " + turno.Medico.Nombre + " " + turno.Medico.Apellido;
            lblMatriculaActual.Text = "MN " + turno.Medico.Matricula;
            lblEspecialidadActual.Text = turno.Especialidad.Descripcion;
            lblMismaEspecialidad.Text = "(Misma especialidad: " + turno.Especialidad.Descripcion + ")";
            lblPrestacion.Text = "Consulta de " + turno.Especialidad.Descripcion;

            lblFechaActual.Text = Formato.Fecha(turno.Fecha);
            lblHoraActual.Text = turno.HoraTexto;
            lblDuracionActual.Text = "60 minutos";
            lblMotivoOriginal.Text = TextoOGuion(turno.Observaciones);

            string actual = TextoFechaHora(turno.Fecha, turno.Hora);
            lblCupoALiberar.Text = actual;
            lblResumenAnterior.Text = actual;
            lblBarraAnterior.Text = actual;
            lblLeyendaActual.Text = TurnoVigente
                ? "Turno actual a liberar (" + turno.Fecha.ToString("dd/MM") + ")"
                : "Fecha anterior (" + turno.Fecha.ToString("dd/MM") + ")";
        }

        private void CargarComboMedicos(int idEspecialidad, int idMedicoActual)
        {
            List<Medico> medicos = new MedicoNegocio().listarActivosPorEspecialidad(idEspecialidad);

            ddlMedico.DataSource = medicos.Select(m => new
            {
                Id = m.Id,
                TextoCompleto = m.Nombre + " " + m.Apellido + " (" + m.Matricula + ")"
            }).ToList();
            ddlMedico.DataTextField = "TextoCompleto";
            ddlMedico.DataValueField = "Id";
            ddlMedico.DataBind();

            // Preseleccionar el médico actual (si sigue activo)
            ListItem item = ddlMedico.Items.FindByValue(idMedicoActual.ToString());
            if (item != null)
                ddlMedico.SelectedValue = item.Value;

            lblMedicosDisponibles.Text = medicos.Count + (medicos.Count == 1 ? " médico" : " médicos") + " con agenda abierta";

            CargarHorarioDelMedico(medicos);
        }

        // Guarda en Session el turno de trabajo del médico elegido en el combo.
        private void CargarHorarioDelMedico(List<Medico> medicos)
        {
            Medico medico = medicos.FirstOrDefault(m => m.Id == IdMedicoElegido);
            if (medico == null || medico.TurnoTrabajo == null)
            {
                HoraEntrada = 0;
                HoraSalida = 0;
                lblDetalleCalendario.Text = "";
                return;
            }

            HoraEntrada = medico.TurnoTrabajo.HoraEntrada;
            HoraSalida = medico.TurnoTrabajo.HoraSalida;
            lblDetalleCalendario.Text = "/ " + medico.TurnoTrabajo.Nombre
                + " (" + HoraEntrada.ToString("00") + ":00 a " + HoraSalida.ToString("00") + ":00)";
        }


        // CALENDARIO


        private void CargarCalendario()
        {
            DateTime primeroDelMes = MesVisible;
            DateTime ultimoDelMes = primeroDelMes.AddMonths(1).AddDays(-1);
            DateTime hoy = DateTime.Today;
            DateTime limite = hoy.AddDays(DiasMaximos);

            // La grilla empieza el lunes de la semana del día 1 y termina el domingo de la última semana.
            int diasHastaLunes = ((int)primeroDelMes.DayOfWeek + 6) % 7;
            DateTime inicio = primeroDelMes.AddDays(-diasHastaLunes);
            int diasHastaDomingo = (7 - (int)ultimoDelMes.DayOfWeek) % 7;
            DateTime fin = ultimoDelMes.AddDays(diasHastaDomingo);

            // Una sola consulta para todo el mes: cuántos turnos tiene el médico cada día.
            Dictionary<DateTime, int> ocupadosPorDia = ContarTurnosPorDia(primeroDelMes, ultimoDelMes);
            int capacidad = HoraSalida - HoraEntrada;

            var dias = new List<object>();
            for (DateTime dia = inicio; dia <= fin; dia = dia.AddDays(1))
            {
                bool esDelMes = dia.Month == primeroDelMes.Month;
                int ocupados = ocupadosPorDia.ContainsKey(dia) ? ocupadosPorDia[dia] : 0;
                bool hayLugar = HorasLibresDelDia(dia, ocupados, capacidad) > 0;
                bool sePuedeElegir = esDelMes && dia >= hoy && dia <= limite
                                     && dia.DayOfWeek != DayOfWeek.Sunday && hayLugar;

                string css = "cell-disabled";
                string punto = "d-none";
                string titulo = "";

                if (FechaElegida.HasValue && dia == FechaElegida.Value)
                {
                    css = "cell-selected"; punto = "dot-seleccionado"; titulo = "Día seleccionado";
                }
                else if (TurnoVigente && dia == FechaActual)
                {
                    css = "cell-current-release"; punto = "dot-actual"; titulo = "Turno actual agendado";
                }
                else if (dia == hoy && sePuedeElegir)
                {
                    css = "cell-today"; punto = "dot-hoy"; titulo = "Hoy";
                }
                else if (sePuedeElegir)
                {
                    css = "cell-active-available"; punto = "dot-libre"; titulo = "Con turnos disponibles";
                }
                else if (esDelMes && dia >= hoy && dia <= limite && dia.DayOfWeek != DayOfWeek.Sunday)
                {
                    titulo = "Sin horarios libres";
                }

                dias.Add(new
                {
                    Fecha = dia.ToString("yyyy-MM-dd"),
                    Numero = dia.Day,
                    Titulo = titulo,
                    Habilitado = sePuedeElegir,
                    Css = css,
                    PuntoCss = punto
                });
            }

            rptDias.DataSource = dias;
            rptDias.DataBind();

            string mes = primeroDelMes.ToString("MMMM yyyy", Formato.Cultura);
            lblMesCalendario.Text = char.ToUpper(mes[0]) + mes.Substring(1);

            // No navegar a meses sin días elegibles
            btnMesAnterior.Enabled = primeroDelMes > PrimerDiaDelMes(hoy);
            btnMesSiguiente.Enabled = primeroDelMes < PrimerDiaDelMes(limite);
        }

        // Turnos (no cancelados) del médico elegido por día, sin contar el que se está reprogramando.
        private Dictionary<DateTime, int> ContarTurnosPorDia(DateTime desde, DateTime hasta)
        {
            if (IdMedicoElegido == 0)
                return new Dictionary<DateTime, int>();

            return new TurnoNegocio().listarPorMedico(IdMedicoElegido, desde, hasta)
                .Where(t => t.Estado != EstadoTurno.Cancelado && t.Id != IdTurno)
                .GroupBy(t => t.Fecha.Date)
                .ToDictionary(g => g.Key, g => g.Count());
        }

        // Cuántas horas le quedan libres al médico ese día (hoy solo cuentan las horas que no pasaron).
        private int HorasLibresDelDia(DateTime dia, int ocupados, int capacidad)
        {
            if (dia == DateTime.Today)
            {
                int desde = Math.Max(HoraEntrada, DateTime.Now.Hour + 1);
                capacidad = Math.Max(HoraSalida - desde, 0);
            }
            return capacidad - ocupados;
        }


        // HORARIOS


        private void CargarHorarios()
        {
            var horarios = new List<object>();

            if (FechaElegida.HasValue && IdMedicoElegido > 0)
            {
                DateTime fecha = FechaElegida.Value;
                List<int> ocupadas = new TurnoNegocio().listarHorasOcupadas(IdMedicoElegido, fecha);

                // El turno que se reprograma no le ocupa el lugar a nadie...
                bool mismoMedicoYDia = IdMedicoElegido == IdMedicoActual && fecha == FechaActual;
                if (mismoMedicoYDia)
                    ocupadas.Remove(HoraActual);

                int desde = HoraEntrada;
                if (fecha == DateTime.Today)
                    desde = Math.Max(HoraEntrada, DateTime.Now.Hour + 1);

                for (int hora = desde; hora < HoraSalida; hora++)
                {
                    // ...pero si sigue vigente, tampoco se puede elegir (no cambiaría nada)
                    bool esLaActual = TurnoVigente && mismoMedicoYDia && hora == HoraActual;
                    bool ocupado = ocupadas.Contains(hora);
                    bool elegido = HoraElegida.HasValue && HoraElegida.Value == hora;

                    string css = "shadow-sm", indicadorCss = "slot-dot", indicador = "", titulo = "";
                    if (elegido)
                    {
                        css = "slot-selected"; indicadorCss = "material-symbols-outlined slot-icon"; indicador = "check";
                    }
                    else if (ocupado || esLaActual)
                    {
                        css = "time-slot-locked"; indicadorCss = "material-symbols-outlined slot-icon"; indicador = "lock";
                        titulo = esLaActual ? "Horario actual del turno" : "Cupo ocupado";
                    }

                    horarios.Add(new
                    {
                        Hora = hora,
                        Texto = hora.ToString("00") + ":00 hs",
                        Titulo = titulo,
                        Disponible = !ocupado && !esLaActual,
                        Css = css,
                        IndicadorCss = indicadorCss,
                        IndicadorTexto = indicador
                    });
                }

                lblFechaHorarios.Text = Formato.Fecha(fecha);
            }
            else
            {
                lblFechaHorarios.Text = "(elegí un día en el calendario)";
            }

            rptHorarios.DataSource = horarios;
            rptHorarios.DataBind();
        }


        // RESUMEN (lo que cambia al elegir día y hora)


        private void ActualizarResumen()
        {
            lblLeyendaSeleccionado.Text = FechaElegida.HasValue
                ? "Seleccionado (" + FechaElegida.Value.ToString("dd/MM") + ")"
                : "Seleccionado";

            if (FechaElegida.HasValue && HoraElegida.HasValue)
            {
                string nuevo = TextoFechaHora(FechaElegida.Value, HoraElegida.Value);
                lblResumenNuevo.Text = nuevo;
                lblBarraNuevo.Text = nuevo;

                DateTime anterior = FechaActual.AddHours(HoraActual);
                DateTime nueva = FechaElegida.Value.AddHours(HoraElegida.Value);
                int horas = (int)(nueva - anterior).TotalHours;
                lblDiferencia.Text = (horas >= 0 ? "+" : "") + horas + " hs";
                lblDiferencia.Visible = true;
            }
            else
            {
                lblResumenNuevo.Text = "Elegí día y horario";
                lblBarraNuevo.Text = "Elegí día y horario";
                lblDiferencia.Visible = false;
            }
        }

        // Vuelve a dibujar todo lo que depende de la selección.
        private void RefrescarSeleccion()
        {
            CargarCalendario();
            CargarHorarios();
            ActualizarResumen();
        }


        // EVENTOS


        protected void ddlMedico_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarError();
            try
            {
                CargarHorarioDelMedico(new MedicoNegocio().listarActivosPorEspecialidad(IdEspecialidad));

                // El día y la hora elegidos eran del otro médico: se descartan
                FechaElegida = null;
                HoraElegida = null;
                RefrescarSeleccion();
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo cargar la agenda del médico: " + ex.Message);
            }
        }

        protected void btnMesAnterior_Click(object sender, EventArgs e)
        {
            CambiarMes(MesVisible.AddMonths(-1));
        }

        protected void btnMesHoy_Click(object sender, EventArgs e)
        {
            CambiarMes(PrimerDiaDelMes(DateTime.Today));
        }

        protected void btnMesSiguiente_Click(object sender, EventArgs e)
        {
            CambiarMes(MesVisible.AddMonths(1));
        }

        private void CambiarMes(DateTime mes)
        {
            OcultarError();
            DateTime minimo = PrimerDiaDelMes(DateTime.Today);
            DateTime maximo = PrimerDiaDelMes(DateTime.Today.AddDays(DiasMaximos));
            if (mes < minimo) mes = minimo;
            if (mes > maximo) mes = maximo;

            MesVisible = mes;
            try
            {
                CargarCalendario();   // el día y la hora elegidos se mantienen
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo cargar el calendario: " + ex.Message);
            }
        }

        protected void rptDias_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SeleccionarDia")
                return;

            OcultarError();
            DateTime fecha;
            if (!DateTime.TryParseExact((string)e.CommandArgument, "yyyy-MM-dd",
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha))
                return;

            FechaElegida = fecha;
            HoraElegida = null;    // la hora elegida era de otro día
            try
            {
                RefrescarSeleccion();
            }
            catch (Exception ex)
            {
                MostrarError("No se pudieron cargar los horarios: " + ex.Message);
            }
        }

        protected void rptHorarios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SeleccionarHorario")
                return;

            OcultarError();
            int hora;
            if (!int.TryParse((string)e.CommandArgument, out hora))
                return;

            HoraElegida = hora;
            try
            {
                CargarHorarios();      // para marcar el horario elegido
                ActualizarResumen();
            }
            catch (Exception ex)
            {
                MostrarError("No se pudieron cargar los horarios: " + ex.Message);
            }
        }

        protected void btnGuardarCambios_Click(object sender, EventArgs e)
        {
            OcultarError();
            string motivo = txtMotivoReprogramacion.Text.Trim();

            // 1) Validaciones
            if (!FechaElegida.HasValue || !HoraElegida.HasValue)
            {
                MostrarError("Elegí un día en el calendario y un horario disponible.");
                return;
            }
            if (IdMedicoElegido == 0)
            {
                MostrarError("Elegí un médico.");
                return;
            }
            if (motivo.Length < 5 || motivo.Length > 300)
            {
                MostrarError("El motivo de la reprogramación es obligatorio (entre 5 y 300 caracteres).");
                return;
            }

            // 2) Reprogramar
            int resultado;
            try
            {
                resultado = new TurnoNegocio().reprogramar(IdTurno, IdMedicoElegido,
                    FechaElegida.Value, HoraElegida.Value, motivo);
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo reprogramar el turno: " + ex.Message);
                return;
            }

            // 3) Resultado (códigos de storedReprogramarTurno)
            switch (resultado)
            {
                case 1:
                    // El mensaje se arma antes de limpiar Session, porque LimpiarEstado borra la fecha y la hora elegidas.
                    Session["MensajeTurnos"] = "Se reprogramó el turno #" + lblNumeroTurno.Text + " para el "
                        + TextoFechaHora(FechaElegida.Value, HoraElegida.Value) + ".";
                    if (chkEnviarCorreo.Checked)
                    {
                        enviarEmail((int)Session["idReprogTurno"]);
                    }
                    
                    Session.Remove("idReprogTurno");
                    LimpiarEstado();
                    Response.Redirect("~/Turnos.aspx");
                    break;
                case -1:
                    MostrarError("Ese horario se acaba de ocupar. Elegí otro.");
                    HoraElegida = null;
                    RefrescarSeleccion();
                    break;
                case -2:
                    MostrarError("El médico elegido ya no está activo o no atiende esta especialidad.");
                    break;
                case -3:
                    MostrarError("La fecha u hora elegida no es válida (ya pasó o está fuera del horario del médico).");
                    break;
                case -4:
                    MostrarError("Elegiste el mismo médico, día y horario que ya tiene el turno.");
                    break;
                default:
                    MostrarNoDisponible("El turno ya no se puede reprogramar: cambió de estado mientras tanto.");
                    break;
            }
        }


        // MENSAJES


        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
        }

        private void OcultarError()
        {
            pnlError.Visible = false;
        }

        // Error sin vuelta atrás: se oculta el contenido y solo queda volver al listado.
        private void MostrarNoDisponible(string mensaje)
        {
            MostrarError(mensaje);
            pnlContenido.Visible = false;
        }


        // AYUDANTES


        // Borra de la Session todo lo que guarda esta página.
        private void LimpiarEstado()
        {
            string[] claves = { "IdTurno", "IdMedicoActual", "FechaActual", "HoraActual", "IdEspecialidad", "TurnoVigente",
                                "HoraEntrada", "HoraSalida", "MesVisible", "FechaElegida", "HoraElegida" };
            foreach (string clave in claves)
                Session.Remove("Reprog_" + clave);
        }

        private static string TextoEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "Reprogramado";
                case EstadoTurno.Cancelado: return "Cancelado";
                case EstadoTurno.NoAsistio: return "No asistió";
                case EstadoTurno.Cerrado: return "Cerrado";
                default: return "Agendado";
            }
        }

        private static DateTime PrimerDiaDelMes(DateTime fecha)
        {
            return new DateTime(fecha.Year, fecha.Month, 1);
        }

        // "Jue 29/05 11:00 hs"
        private static string TextoFechaHora(DateTime fecha, int hora)
        {
            string dia = fecha.ToString("ddd dd/MM", Formato.Cultura).Replace(".", "");
            return char.ToUpper(dia[0]) + dia.Substring(1) + " " + hora.ToString("00") + ":00 hs";
        }

        private static string Iniciales(string nombre, string apellido)
        {
            string i1 = string.IsNullOrEmpty(nombre) ? "" : nombre.Substring(0, 1);
            string i2 = string.IsNullOrEmpty(apellido) ? "" : apellido.Substring(0, 1);
            return (i1 + i2).ToUpper();
        }

        private static string TextoOGuion(string texto)
        {
            return string.IsNullOrWhiteSpace(texto) ? "-" : texto;
        }

        private void enviarEmail(int idTurno)
        {
            Turno turno = new TurnoNegocio().buscarPorId(idTurno);
            new EmailNegocio("Reprogramacion").EnviarCorreo(turno, "Reprogramacion");
        }

    }
}