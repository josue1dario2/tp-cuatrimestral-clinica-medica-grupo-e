using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class AtencionTurno : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        // Largos máximos de las columnas de ATENCIONES.
        private const int LargoMaximoEvolucion = 2000;
        private const int LargoMaximoPrescripcion = 1000;

        // ESTADO DE LA PÁGINA (se guarda en Session para que sobreviva a los PostBack).
        // Las claves empiezan con "AtencionTurno_" y se borran al entrar a la página (LimpiarEstado).
        // El turno a atender lo indican InicioMedico y MisTurnos con Session["idAtencionTurno"]
        // (misma convención que Session["idReprogTurno"] para ReprogramarTurno).

        private int IdTurno
        {
            get { return Session["AtencionTurno_IdTurno"] == null ? 0 : (int)Session["AtencionTurno_IdTurno"]; }
            set { Session["AtencionTurno_IdTurno"] = value; }
        }

        // Médico logueado: el turno tiene que ser suyo.
        private int IdMedico
        {
            get { return Session["AtencionTurno_IdMedico"] == null ? 0 : (int)Session["AtencionTurno_IdMedico"]; }
            set { Session["AtencionTurno_IdMedico"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Los mensajes son de una sola respuesta: se ocultan en cada carga.
            pnlMensajeExito.Visible = false;
            pnlMensajeAviso.Visible = false;
            pnlErrorAccion.Visible = false;
            lblErrorEvolucion.Visible = false;
            PrepararOpcionesResolucion();

            if (!IsPostBack)
            {
                // La Session no se borra sola: se descarta lo que haya quedado de una visita anterior.
                LimpiarEstado();

                object valorTurno = Session["idAtencionTurno"];
                if (!(valorTurno is int))
                {
                    MostrarError("No se indicó qué turno atender. Vuelva a Mis turnos y elija uno.");
                    return;
                }

                // Sin sesión, Medico.Master redirige al login (su Page_Load corre después que el de la página).
                int idMedico;
                try
                {
                    idMedico = ObtenerIdMedico();
                }
                catch (Exception ex)
                {
                    MostrarError("No se pudo leer el médico desde la base de datos: " + Server.HtmlEncode(ex.Message));
                    return;
                }

                if (idMedico == 0)
                {
                    MostrarError("Su usuario no tiene un médico asociado.");
                    return;
                }

                IdTurno = (int)valorTurno;
                IdMedico = idMedico;
                CargarPagina();
            }
        }

        private void LimpiarEstado()
        {
            Session.Remove("AtencionTurno_IdTurno");
            Session.Remove("AtencionTurno_IdMedico");
        }

        private int ObtenerIdMedico()
        {
            Usuario usuario = Session["Usuario"] as Usuario;
            if (usuario == null) return 0;

            Medico logueado = new MedicoNegocio().buscarPorIdUsuario(usuario.Id);
            return logueado != null ? logueado.Id : 0;
        }

        // El RadioButton dibuja el <input> sin clases: se le agregan las de Bootstrap.
        private void PrepararOpcionesResolucion()
        {
            rdoCerrado.InputAttributes["class"] = "form-check-input ms-0 mt-1";
            rdoNoAsistio.InputAttributes["class"] = "form-check-input ms-0 mt-1";
        }

        // ----- Carga -----

        private void CargarPagina()
        {
            Turno turno;
            Medico medico;
            Atencion atencion = null;
            List<Atencion> anteriores;

            try
            {
                turno = new TurnoNegocio().buscarPorId(IdTurno);
                if (turno == null)
                {
                    MostrarError("El turno seleccionado ya no existe.");
                    return;
                }

                if (turno.Medico.Id != IdMedico)
                {
                    MostrarError("El turno seleccionado no pertenece a su agenda.");
                    return;
                }

                medico = new MedicoNegocio().buscarPorId(IdMedico);

                AtencionNegocio negocio = new AtencionNegocio();
                if (turno.Estado == EstadoTurno.Cerrado)
                    atencion = negocio.buscarPorTurno(turno.Id);
                anteriores = negocio.listarAnteriores(turno.Paciente.Id, IdMedico, turno.Id);
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo leer el turno desde la base de datos: " + Server.HtmlEncode(ex.Message));
                return;
            }

            pnlError.Visible = false;
            phContenido.Visible = true;

            MostrarMedicoEnEncabezado(medico);
            MostrarCabecera(turno);
            MostrarPaciente(turno);
            MostrarTurno(turno);
            MostrarHistorial(turno, anteriores);
            MostrarAtencion(turno, atencion);
        }

        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
            phContenido.Visible = false;
        }

        // Error de un botón: se muestra arriba de los botones, sin perder lo que escribió el médico.
        private void MostrarErrorAccion(string mensaje)
        {
            lblErrorAccion.Text = mensaje;
            pnlErrorAccion.Visible = true;
        }

        // Un turno se atiende si está pendiente (Nuevo o Reprogramado) y su día ya llegó.
        private static bool PuedeAtenderse(Turno turno)
        {
            return turno.EsPendiente && turno.Fecha.Date <= DateTime.Today;
        }

        private void MostrarMedicoEnEncabezado(Medico medico)
        {
            MedicoMaster master = Master as MedicoMaster;
            if (master != null && medico != null)
                master.MostrarMedico(medico.NombreCompleto, medico.EspecialidadesTexto);
        }

        private void MostrarCabecera(Turno turno)
        {
            lblTurnoBreadcrumb.Text = "Atención del turno #" + turno.NumeroTurno;
            lblNumeroTurno.Text = turno.NumeroTurno.ToString();

            if (PuedeAtenderse(turno))
            {
                lblEstadoCabecera.Text = "En atención";
                lblEstadoCabecera.CssClass = "cl-estado cl-estado-nuevo text-uppercase";
            }
            else
            {
                lblEstadoCabecera.Text = TextoEstado(turno);
                lblEstadoCabecera.CssClass = "cl-estado " + CssEstado(turno.Estado) + " text-uppercase";
            }
        }

        private void MostrarPaciente(Turno turno)
        {
            Paciente p = turno.Paciente;

            lblAvatarIniciales.Text = Server.HtmlEncode(Iniciales(p.Nombre, p.Apellido));
            lblPacienteNombre.Text = Server.HtmlEncode(p.NombreCompleto);
            lblPacienteDni.Text = Server.HtmlEncode(Formato.Dni(p.Dni));
            lblPacienteEdad.Text = p.Edad + " años";
            lblPacienteNacimiento.Text = "(" + p.FechaNacimiento.ToString("dd/MM/yyyy") + ")";
            lblPacienteTelefono.Text = string.IsNullOrWhiteSpace(p.Telefono) ? "No informado" : Server.HtmlEncode(p.Telefono);
            lblPacienteEmail.Text = string.IsNullOrWhiteSpace(p.Email) ? "No informado" : Server.HtmlEncode(p.Email);
            lblPacienteEmail.ToolTip = p.Email;

            lblPacienteCobertura.Text = Server.HtmlEncode(TextoCobertura(turno));
            lblPacienteAfiliado.Text = string.IsNullOrWhiteSpace(turno.NumeroAfiliado)
                ? ""
                : "N° de afiliado: " + Server.HtmlEncode(turno.NumeroAfiliado);
        }

        private void MostrarTurno(Turno turno)
        {
            lblEstadoTurno.Text = TextoEstado(turno);
            lblEstadoTurno.CssClass = "cl-estado " + CssEstado(turno.Estado);

            // "martes 24 de noviembre de 2026" -> "Martes 24 de noviembre de 2026"
            string fecha = turno.Fecha.ToString("dddd d 'de' MMMM 'de' yyyy", Cultura);
            lblTurnoFecha.Text = char.ToUpper(fecha[0], Cultura) + fecha.Substring(1);

            // Cada turno dura una hora.
            lblTurnoHora.Text = turno.Hora.ToString("00") + ":00 a " + (turno.Hora + 1).ToString("00") + ":00 hs";
            lblTurnoEspecialidad.Text = Server.HtmlEncode(turno.Especialidad.Descripcion);
            lblTurnoMedico.Text = Server.HtmlEncode("Dr/a. " + turno.Medico.Nombre + " " + turno.Medico.Apellido);

            lblMotivoRecepcion.Text = string.IsNullOrWhiteSpace(turno.Observaciones)
                ? "Sin motivo informado."
                : Server.HtmlEncode(turno.Observaciones);
        }

        private void MostrarHistorial(Turno turno, List<Atencion> anteriores)
        {
            lblTituloHistorial.Text = Server.HtmlEncode("Consultas anteriores con Dr/a. " + turno.Medico.Apellido)
                + " (" + anteriores.Count + ")";

            string firma = "Dr/a. " + turno.Medico.Nombre + " " + turno.Medico.Apellido + " (Matrícula " + turno.Medico.Matricula + ")";

            rptConsultasAnteriores.DataSource = anteriores.Select(a => new
            {
                Fecha = a.Turno.Fecha.ToString("dd/MM/yyyy"),
                Motivo = string.IsNullOrWhiteSpace(a.Turno.Observaciones) ? "Consulta" : Resumir(a.Turno.Observaciones, 40),
                Evolucion = a.Evolucion,
                SignosTexto = TextoSignos(a),
                TieneSignos = TextoSignos(a) != "",
                Prescripcion = a.Prescripcion,
                TienePrescripcion = !string.IsNullOrWhiteSpace(a.Prescripcion),
                Firma = firma
            }).ToList();
            rptConsultasAnteriores.DataBind();

            pnlSinHistorial.Visible = anteriores.Count == 0;
        }

        // Turno atendible: formulario de edición. Cualquier otro caso: modo de solo lectura.
        private void MostrarAtencion(Turno turno, Atencion atencion)
        {
            bool editable = PuedeAtenderse(turno);
            phEdicion.Visible = editable;
            phLectura.Visible = !editable;

            if (editable)
            {
                // Los usa Scripts/atencion-turno.js para armar los mensajes (ASP.NET codifica los atributos).
                pnlFormularioAtencion.Attributes["data-paciente"] = turno.Paciente.Nombre + " " + turno.Paciente.Apellido;
                pnlFormularioAtencion.Attributes["data-numero"] = turno.NumeroTurno.ToString();
                return;
            }

            switch (turno.Estado)
            {
                case EstadoTurno.Cerrado:
                    lblLecturaMensaje.Text = atencion != null
                        ? "El turno fue atendido y cerrado."
                        : "El turno fue cerrado, pero no tiene una evolución registrada.";
                    break;
                case EstadoTurno.NoAsistio:
                    lblLecturaMensaje.Text = "El turno se registró como No asistió: no tiene evolución clínica.";
                    break;
                case EstadoTurno.Cancelado:
                    lblLecturaMensaje.Text = "El turno fue cancelado: no se puede atender.";
                    break;
                default:
                    // Pendiente de un día que todavía no llegó.
                    lblLecturaMensaje.Text = "El turno es del " + turno.Fecha.ToString("dd/MM/yyyy")
                        + ": se podrá atender ese día.";
                    break;
            }

            phAtencionRegistrada.Visible = atencion != null;
            if (atencion == null)
                return;

            lblLecturaTension.Text = string.IsNullOrWhiteSpace(atencion.TensionArterial) ? "-" : Server.HtmlEncode(atencion.TensionArterial) + " mmHg";
            lblLecturaFrecuencia.Text = atencion.FrecuenciaCardiaca.HasValue ? atencion.FrecuenciaCardiaca + " lpm" : "-";
            lblLecturaSaturacion.Text = atencion.SaturacionOxigeno.HasValue ? atencion.SaturacionOxigeno + " %" : "-";
            lblLecturaPeso.Text = atencion.Peso.HasValue ? atencion.Peso.Value.ToString("0.##", Cultura) + " kg" : "-";
            lblLecturaEvolucion.Text = Server.HtmlEncode(atencion.Evolucion);
            lblLecturaPrescripcion.Text = string.IsNullOrWhiteSpace(atencion.Prescripcion)
                ? "Sin indicaciones registradas."
                : Server.HtmlEncode(atencion.Prescripcion);
            lblLecturaFechaRegistro.Text = "Registrado el " + atencion.FechaRegistro.ToString("dd/MM/yyyy 'a las' HH:mm", Cultura) + " hs";
        }

        // ----- Guardar -----

        protected void btnConfirmarCierreTurno_Click(object sender, EventArgs e)
        {
            if (IdTurno == 0 || IdMedico == 0)
            {
                MostrarError("Se perdieron los datos de la página (la sesión pudo haber expirado). Vuelva a Mis turnos y elija el turno otra vez.");
                return;
            }

            AtencionNegocio negocio = new AtencionNegocio();
            int resultado;
            string mensajeOk;

            try
            {
                if (rdoNoAsistio.Checked)
                {
                    resultado = negocio.marcarNoAsistio(IdTurno, IdMedico);
                    mensajeOk = "El turno quedó registrado como No asistió.";
                }
                else
                {
                    Atencion atencion = LeerFormulario();
                    if (atencion == null)
                        return;   // LeerFormulario ya mostró los errores

                    resultado = negocio.cerrarTurno(atencion, IdMedico);
                    mensajeOk = "La consulta quedó registrada y el turno se cerró.";
                }
            }
            catch (Exception ex)
            {
                MostrarErrorAccion("No se pudo guardar: " + Server.HtmlEncode(ex.Message));
                return;
            }

            switch (resultado)
            {
                case AtencionNegocio.RESULTADO_OK:
                    // Se recarga desde la base: el turno pasa a modo de solo lectura.
                    CargarPagina();
                    lblMensajeExito.Text = mensajeOk;
                    pnlMensajeExito.Visible = true;
                    break;

                case AtencionNegocio.RESULTADO_TURNO_FUTURO:
                    MostrarErrorAccion("Este turno es de un día que todavía no llegó: se podrá atender ese día.");
                    break;

                default:
                    // Otro usuario lo canceló, lo reprogramó a otro médico o ya se resolvió.
                    CargarPagina();
                    lblMensajeAviso.Text = "No se guardó: el turno ya no está pendiente de atención. Se muestra su estado actual.";
                    pnlMensajeAviso.Visible = true;
                    break;
            }
        }

        // Valida los campos y arma la Atencion. Devuelve null (y muestra los errores) si algo no es válido.
        private Atencion LeerFormulario()
        {
            List<string> errores = new List<string>();
            Atencion atencion = new Atencion();
            atencion.Turno = new Turno();
            atencion.Turno.Id = IdTurno;

            // Evolución: obligatoria
            string evolucion = txtEvolucionClinica.Text.Trim();
            if (evolucion == "")
            {
                lblErrorEvolucion.Text = "Complete la evolución clínica antes de cerrar el turno.";
                lblErrorEvolucion.Visible = true;
                errores.Add("Falta la evolución clínica.");
            }
            else if (evolucion.Length > LargoMaximoEvolucion)
            {
                errores.Add("La evolución clínica no puede superar los " + LargoMaximoEvolucion + " caracteres (tiene " + evolucion.Length + ").");
            }
            atencion.Evolucion = evolucion;

            // Prescripción: opcional
            string prescripcion = txtPrescripcion.Text.Trim();
            if (prescripcion.Length > LargoMaximoPrescripcion)
                errores.Add("La prescripción no puede superar los " + LargoMaximoPrescripcion + " caracteres.");
            atencion.Prescripcion = prescripcion == "" ? null : prescripcion;

            // Signos vitales: opcionales, pero si se cargan tienen que ser válidos
            string tension = txtTensionArterial.Text.Replace(" ", "");
            if (tension != "")
            {
                if (Regex.IsMatch(tension, @"^\d{2,3}/\d{2,3}$"))
                    atencion.TensionArterial = tension;
                else
                    errores.Add("La tensión arterial debe tener el formato 120/80.");
            }

            atencion.FrecuenciaCardiaca = LeerEntero(txtFrecuenciaCardiaca.Text, 20, 250, "La frecuencia cardíaca", errores);
            atencion.SaturacionOxigeno = LeerEntero(txtSaturacionOxigeno.Text, 50, 100, "La saturación de oxígeno", errores);

            string peso = txtPesoCorporal.Text.Trim().Replace(',', '.');
            if (peso != "")
            {
                decimal valor;
                if (decimal.TryParse(peso, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out valor)
                    && valor >= 0.5m && valor <= 500m)
                    atencion.Peso = Math.Round(valor, 2);
                else
                    errores.Add("El peso debe ser un número entre 0,5 y 500 kg (por ejemplo 78,5).");
            }

            if (errores.Count > 0)
            {
                MostrarErrorAccion(string.Join("<br />", errores));
                return null;
            }

            return atencion;
        }

        // Número entero opcional dentro de un rango. Vacío -> null.
        private static int? LeerEntero(string texto, int minimo, int maximo, string campo, List<string> errores)
        {
            texto = texto.Trim();
            if (texto == "")
                return null;

            int valor;
            if (int.TryParse(texto, out valor) && valor >= minimo && valor <= maximo)
                return valor;

            errores.Add(campo + " debe ser un número entre " + minimo + " y " + maximo + ".");
            return null;
        }

        // ----- Textos -----

        private static string TextoEstado(Turno turno)
        {
            switch (turno.Estado)
            {
                case EstadoTurno.Cancelado: return "Cancelado";
                case EstadoTurno.NoAsistio: return "No asistió";
                case EstadoTurno.Cerrado: return "Atendido";
                case EstadoTurno.Reprogramado: return "Reprogramado";
                default: return "Nuevo";
            }
        }

        private static string CssEstado(EstadoTurno estado)
        {
            switch (estado)
            {
                case EstadoTurno.Reprogramado: return "cl-estado-reprogramado";
                case EstadoTurno.Cancelado: return "cl-estado-cancelado";
                case EstadoTurno.NoAsistio: return "cl-estado-noasistio";
                case EstadoTurno.Cerrado: return "cl-estado-cerrado";
                default: return "cl-estado-nuevo";
            }
        }

        // "TA 120/80 mmHg • FC 72 lpm • Sat. 98 % • Peso 78,5 kg" (solo lo que se cargó).
        private static string TextoSignos(Atencion a)
        {
            List<string> partes = new List<string>();
            if (!string.IsNullOrWhiteSpace(a.TensionArterial)) partes.Add("TA " + a.TensionArterial + " mmHg");
            if (a.FrecuenciaCardiaca.HasValue) partes.Add("FC " + a.FrecuenciaCardiaca + " lpm");
            if (a.SaturacionOxigeno.HasValue) partes.Add("Sat. " + a.SaturacionOxigeno + " %");
            if (a.Peso.HasValue) partes.Add("Peso " + a.Peso.Value.ToString("0.##", Cultura) + " kg");
            return string.Join(" • ", partes);
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

        private static string Iniciales(string nombre, string apellido)
        {
            string i1 = string.IsNullOrEmpty(nombre) ? "" : nombre.Substring(0, 1);
            string i2 = string.IsNullOrEmpty(apellido) ? "" : apellido.Substring(0, 1);
            return (i1 + i2).ToUpper();
        }

        private static string Resumir(string texto, int maximo)
        {
            return texto.Length <= maximo ? texto : texto.Substring(0, maximo) + "...";
        }

        // ----- Botones del diseño sin datos en el sistema (quedan ocultos en el .aspx) -----
        protected void btnVerHistoriaClinica_Click(object sender, EventArgs e) { }
        protected void btnImprimirCertificado_Click(object sender, EventArgs e) { }
        protected void btnGuardarBorrador_Click(object sender, EventArgs e) { }
    }
}
