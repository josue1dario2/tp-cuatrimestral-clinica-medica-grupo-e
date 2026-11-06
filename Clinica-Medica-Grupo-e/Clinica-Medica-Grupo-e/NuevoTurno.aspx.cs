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
    public partial class NuevoTurno : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    InicializarFormulario();
                }
                catch (Exception ex)
                {
                    MostrarError("Error al inicializar el formulario de turnos: " + ex.Message);
                }
            }
        }

        private void InicializarFormulario()
        {
            OcultarAlertas();
            CargarPacientes();
            CargarObrasSociales();
            CargarEspecialidades();
            CargarMedicos();

            DateTime fechaSugerida = DateTime.Today.AddDays(1);
            if (fechaSugerida.DayOfWeek == DayOfWeek.Sunday)
                fechaSugerida = fechaSugerida.AddDays(1);

            txtFecha.Text = fechaSugerida.ToString("yyyy-MM-dd");

            CargarHorariosDisponibles();
            ActualizarResumen();
        }

        #region Carga de Combos

        private void CargarPacientes()
        {
            PacienteNegocio negocio = new PacienteNegocio();
            List<Paciente> lista = negocio.listar();

            ddlPaciente.Items.Clear();
            ddlPaciente.Items.Add(new ListItem("-- Seleccione un paciente --", "0"));

            foreach (var p in lista)
            {
                string texto = string.Format("{0}, {1} (DNI: {2})", p.Apellido, p.Nombre, p.Dni);
                ddlPaciente.Items.Add(new ListItem(texto, p.Id.ToString()));
            }

            if (Request.QueryString["idPaciente"] != null)
            {
                string idPac = Request.QueryString["idPaciente"];
                if (ddlPaciente.Items.FindByValue(idPac) != null)
                    ddlPaciente.SelectedValue = idPac;
            }
        }

        private void CargarObrasSociales()
        {
            ObraSocialNegocio negocio = new ObraSocialNegocio();
            List<ObraSocial> lista = negocio.listar();

            ddlObraSocial.Items.Clear();
            ddlObraSocial.Items.Add(new ListItem("-- Seleccione Obra Social / Prepaga --", "0"));

            foreach (var os in lista)
            {
                string texto = !string.IsNullOrEmpty(os.Sigla) && os.Sigla != os.Nombre
                    ? string.Format("{0} ({1})", os.Nombre, os.Sigla)
                    : os.Nombre;

                ddlObraSocial.Items.Add(new ListItem(texto, os.IdObraSocial.ToString()));
            }

            if (ddlObraSocial.Items.FindByValue("1") != null)
            {
                ddlObraSocial.SelectedValue = "1";
                CargarPlanesPorObraSocial(1);
            }
            else if (ddlObraSocial.Items.Count > 1)
            {
                ddlObraSocial.SelectedIndex = 1;
                int id = int.Parse(ddlObraSocial.SelectedValue);
                CargarPlanesPorObraSocial(id);
            }
        }

        private void CargarPlanesPorObraSocial(int idObraSocial)
        {
            ddlPlan.Items.Clear();

            if (idObraSocial <= 0)
            {
                ddlPlan.Items.Add(new ListItem("-- Seleccione una obra social primero --", "0"));
                lblCantidadPlanes.Text = "";
                return;
            }

            ObraSocialNegocio negocio = new ObraSocialNegocio();
            List<PlanObraSocial> listaPlanes = negocio.listarPlanesPorObraSocial(idObraSocial);

            if (listaPlanes.Count == 0)
            {
                ddlPlan.Items.Add(new ListItem("Plan Único / Estándar", "0"));
                lblCantidadPlanes.Text = "Sin planes específicos";
            }
            else
            {
                foreach (var plan in listaPlanes)
                {
                    ddlPlan.Items.Add(new ListItem(plan.NombrePlan, plan.IdPlan.ToString()));
                }

                lblCantidadPlanes.Text = string.Format("{0} plan{1} disponible{1}", listaPlanes.Count, listaPlanes.Count > 1 ? "es" : "");
                ddlPlan.SelectedIndex = 0;
            }

            if (idObraSocial == 1)
            {
                txtNumeroAfiliado.Text = "";
                txtNumeroAfiliado.Enabled = false;
                txtNumeroAfiliado.Attributes["placeholder"] = "No requerido (Particular)";
            }
            else
            {
                txtNumeroAfiliado.Enabled = true;
                txtNumeroAfiliado.Attributes["placeholder"] = "Ej: 01-12345678-00";
            }
        }

        private void CargarEspecialidades()
        {
            EspecialidadNegocio negocio = new EspecialidadNegocio();
            List<Especialidad> lista = negocio.listar();

            ddlEspecialidad.Items.Clear();
            ddlEspecialidad.Items.Add(new ListItem("-- Todas las especialidades (Sin filtrar) --", "0"));

            foreach (var esp in lista)
            {
                ddlEspecialidad.Items.Add(new ListItem(esp.Descripcion, esp.Id.ToString()));
            }
        }

        private void CargarMedicos()
        {
            MedicoNegocio negocio = new MedicoNegocio();
            List<Medico> lista = negocio.listarConDetalle().Where(m => m.Activo).ToList();

            int idEspecialidad = 0;
            int.TryParse(ddlEspecialidad.SelectedValue, out idEspecialidad);

            if (idEspecialidad > 0)
            {
                lista = lista.Where(m => m.Especialidades != null && m.Especialidades.Any(e => e.Id == idEspecialidad)).ToList();
            }

            string previousSelectedMedico = ddlMedico.SelectedValue;

            ddlMedico.Items.Clear();
            string textoInicial = idEspecialidad > 0
                ? string.Format("-- Seleccione Médico ({0} disponible{1}) --", lista.Count, lista.Count != 1 ? "s" : "")
                : string.Format("-- Seleccione Médico (Todos los profesionales - {0}) --", lista.Count);

            ddlMedico.Items.Add(new ListItem(textoInicial, "0"));

            foreach (var m in lista)
            {
                string infoTurno = m.TurnoTrabajo != null
                    ? string.Format(" [Turno {0}: {1:00}:00 - {2:00}:00]", m.TurnoTrabajo.Nombre, m.TurnoTrabajo.HoraEntrada, m.TurnoTrabajo.HoraSalida)
                    : "";

                string especialidadesTexto = (m.Especialidades != null && m.Especialidades.Count > 0)
                    ? " (" + string.Join(", ", m.Especialidades.Select(e => e.Descripcion)) + ")"
                    : "";

                string texto = string.Format("Dr. {0}, {1}{2}{3}", m.Apellido, m.Nombre, especialidadesTexto, infoTurno);
                ddlMedico.Items.Add(new ListItem(texto, m.Id.ToString()));
            }

            if (!string.IsNullOrEmpty(previousSelectedMedico) && ddlMedico.Items.FindByValue(previousSelectedMedico) != null)
            {
                ddlMedico.SelectedValue = previousSelectedMedico;
            }
            else
            {
                ddlMedico.SelectedIndex = 0;
            }

            ActualizarInfoTurnoTrabajo();
        }

        private void CargarHorariosDisponibles()
        {
            ddlHora.Items.Clear();

            int idMedico = 0;
            int.TryParse(ddlMedico.SelectedValue, out idMedico);

            DateTime fecha;
            if (!DateTime.TryParse(txtFecha.Text, out fecha))
            {
                ddlHora.Items.Add(new ListItem("-- Ingrese una fecha válida --", "0"));
                lblEstadoHorario.Text = "Fecha inválida.";
                return;
            }

            if (idMedico <= 0)
            {
                ddlHora.Items.Add(new ListItem("-- Seleccione un médico primero --", "0"));
                lblEstadoHorario.Text = "Seleccione médico para ver horarios.";
                return;
            }

            MedicoNegocio medNegocio = new MedicoNegocio();
            List<Medico> medicos = medNegocio.listarConDetalle();
            Medico medico = medicos.FirstOrDefault(m => m.Id == idMedico);

            int horaInicio = 8;
            int horaFin = 14;

            if (medico != null && medico.TurnoTrabajo != null)
            {
                horaInicio = medico.TurnoTrabajo.HoraEntrada;
                horaFin = medico.TurnoTrabajo.HoraSalida;
            }

            TurnoNegocio turnoNegocio = new TurnoNegocio();
            List<int> horasOcupadas = turnoNegocio.listarHorasOcupadas(idMedico, fecha);

            int disponibles = 0;
            ddlHora.Items.Add(new ListItem("-- Seleccione Horario --", "0"));

            for (int h = horaInicio; h < horaFin; h++)
            {
                string textoHora = string.Format("{0:00}:00 hs", h);
                bool ocupado = horasOcupadas.Contains(h);

                if (ocupado)
                {
                    ListItem itemOcupado = new ListItem(textoHora + " (Ocupado)", h.ToString());
                    itemOcupado.Attributes.Add("disabled", "disabled");
                    ddlHora.Items.Add(itemOcupado);
                }
                else
                {
                    ddlHora.Items.Add(new ListItem(textoHora + " - Disponible", h.ToString()));
                    disponibles++;
                }
            }

            lblEstadoHorario.Text = disponibles > 0
                ? string.Format("{0} horario{1} disponible{1} para el día seleccionado.", disponibles, disponibles > 1 ? "s" : "")
                : "No hay horarios libres para este médico en la fecha elegida.";
        }

        private void ActualizarInfoTurnoTrabajo()
        {
            int idMedico = 0;
            int.TryParse(ddlMedico.SelectedValue, out idMedico);

            if (idMedico > 0)
            {
                MedicoNegocio medNegocio = new MedicoNegocio();
                Medico medico = medNegocio.listarConDetalle().FirstOrDefault(m => m.Id == idMedico);
                if (medico != null && medico.TurnoTrabajo != null)
                {
                    lblTurnoTrabajoInfo.Visible = true;
                    lblTurnoTrabajoInfo.Text = string.Format("Horario laboral: Turno {0} ({1:00}:00 a {2:00}:00 hs)",
                        medico.TurnoTrabajo.Nombre, medico.TurnoTrabajo.HoraEntrada, medico.TurnoTrabajo.HoraSalida);
                    return;
                }
            }

            lblTurnoTrabajoInfo.Visible = false;
        }

        private void ActualizarResumen()
        {
            if (ddlPaciente.SelectedIndex > 0)
                lblResumenPaciente.Text = ddlPaciente.SelectedItem.Text.Split('(')[0].Trim();
            else
                lblResumenPaciente.Text = "No seleccionado";

            if (ddlObraSocial.SelectedIndex > 0)
            {
                string cob = ddlObraSocial.SelectedItem.Text;
                if (ddlPlan.SelectedIndex >= 0 && ddlPlan.SelectedItem != null && ddlPlan.SelectedValue != "0")
                    cob += " (" + ddlPlan.SelectedItem.Text + ")";
                lblResumenCobertura.Text = cob;
            }
            else
            {
                lblResumenCobertura.Text = "No seleccionada";
            }

            if (ddlMedico.SelectedIndex > 0)
                lblResumenMedico.Text = ddlMedico.SelectedItem.Text.Split('[')[0].Trim();
            else
                lblResumenMedico.Text = "No seleccionado";

            DateTime fecha;
            if (DateTime.TryParse(txtFecha.Text, out fecha))
            {
                string hora = (ddlHora.SelectedIndex > 0 && ddlHora.SelectedValue != "0")
                    ? ddlHora.SelectedItem.Text.Split('-')[0].Trim()
                    : "Horario a definir";

                lblResumenFechaHora.Text = string.Format("{0:dd/MM/yyyy} - {1}", fecha, hora);
            }
            else
            {
                lblResumenFechaHora.Text = "Fecha a definir";
            }
        }

        #endregion

        #region Eventos de Cambio (SelectedIndexChanged)

        protected void ddlObraSocial_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            int idObraSocial = 0;
            int.TryParse(ddlObraSocial.SelectedValue, out idObraSocial);

            CargarPlanesPorObraSocial(idObraSocial);
            ActualizarResumen();
        }

        protected void ddlPlan_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            ActualizarResumen();
        }

        protected void ddlPaciente_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            ActualizarResumen();
        }

        protected void ddlEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            CargarMedicos();
            CargarHorariosDisponibles();
            ActualizarResumen();
        }

        protected void ddlMedico_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            int idMedico = 0;
            int.TryParse(ddlMedico.SelectedValue, out idMedico);

            if (idMedico > 0 && ddlEspecialidad.SelectedValue == "0")
            {
                MedicoNegocio medNegocio = new MedicoNegocio();
                Medico medico = medNegocio.listarConDetalle().FirstOrDefault(m => m.Id == idMedico);
                if (medico != null && medico.Especialidades != null && medico.Especialidades.Count > 0)
                {
                    string idEspPrimaria = medico.Especialidades.First().Id.ToString();
                    if (ddlEspecialidad.Items.FindByValue(idEspPrimaria) != null)
                    {
                        ddlEspecialidad.SelectedValue = idEspPrimaria;
                    }
                }
            }

            ActualizarInfoTurnoTrabajo();
            CargarHorariosDisponibles();
            ActualizarResumen();
        }

        protected void txtFecha_TextChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            DateTime fecha;
            if (DateTime.TryParse(txtFecha.Text, out fecha))
            {
                if (fecha.Date < DateTime.Today)
                {
                    MostrarError("La fecha del turno no puede ser anterior al día de hoy.");
                }
            }

            CargarHorariosDisponibles();
            ActualizarResumen();
        }

        protected void ddlHora_SelectedIndexChanged(object sender, EventArgs e)
        {
            OcultarAlertas();
            ActualizarResumen();
        }

        #endregion

        #region Confirmación del Turno

        protected void btnConfirmarTurno_Click(object sender, EventArgs e)
        {
            OcultarAlertas();

            try
            {
                int idPaciente = 0;
                int.TryParse(ddlPaciente.SelectedValue, out idPaciente);
                if (idPaciente <= 0)
                {
                    MostrarError("Por favor seleccione un paciente titular.");
                    ddlPaciente.Focus();
                    return;
                }

                int idObraSocial = 0;
                int.TryParse(ddlObraSocial.SelectedValue, out idObraSocial);
                if (idObraSocial <= 0)
                {
                    MostrarError("Por favor seleccione la obra social o prepaga (elija 'Particular' si no posee cobertura).");
                    ddlObraSocial.Focus();
                    return;
                }

                int idPlan = 0;
                int.TryParse(ddlPlan.SelectedValue, out idPlan);

                int idMedico = 0;
                int.TryParse(ddlMedico.SelectedValue, out idMedico);
                if (idMedico <= 0)
                {
                    MostrarError("Por favor seleccione el profesional médico.");
                    ddlMedico.Focus();
                    return;
                }

                int idEspecialidad = 0;
                int.TryParse(ddlEspecialidad.SelectedValue, out idEspecialidad);

                if (idEspecialidad <= 0)
                {
                    MedicoNegocio medNegocio = new MedicoNegocio();
                    Medico m = medNegocio.listarConDetalle().FirstOrDefault(x => x.Id == idMedico);
                    if (m != null && m.Especialidades != null && m.Especialidades.Count > 0)
                    {
                        idEspecialidad = m.Especialidades.First().Id;
                    }
                }

                if (idEspecialidad <= 0)
                {
                    MostrarError("Por favor seleccione una especialidad médica.");
                    ddlEspecialidad.Focus();
                    return;
                }

                DateTime fecha;
                if (!DateTime.TryParse(txtFecha.Text, out fecha))
                {
                    MostrarError("Por favor ingrese una fecha válida para la cita.");
                    txtFecha.Focus();
                    return;
                }

                if (fecha.Date < DateTime.Today)
                {
                    MostrarError("La fecha de la cita no puede ser anterior al día de hoy.");
                    txtFecha.Focus();
                    return;
                }

                int hora = 0;
                int.TryParse(ddlHora.SelectedValue, out hora);
                if (hora <= 0)
                {
                    MostrarError("Por favor seleccione un horario disponible de atención.");
                    ddlHora.Focus();
                    return;
                }

                TurnoNegocio turnoNegocio = new TurnoNegocio();

                if (turnoNegocio.existeTurno(idMedico, fecha, hora))
                {
                    MostrarError(string.Format("El horario de las {0:00}:00 hs para el médico seleccionado ya ha sido reservado. Por favor seleccione otro horario.", hora));
                    CargarHorariosDisponibles();
                    return;
                }

                Turno nuevoTurno = new Turno();
                nuevoTurno.Fecha = fecha.Date;
                nuevoTurno.Hora = hora;
                nuevoTurno.Observaciones = txtObservaciones.Text.Trim();
                nuevoTurno.Estado = EstadoTurno.Nuevo;

                nuevoTurno.Paciente = new Paciente { Id = idPaciente };
                nuevoTurno.Medico = new Medico { Id = idMedico };
                nuevoTurno.Especialidad = new Especialidad { Id = idEspecialidad };
                nuevoTurno.ObraSocial = new ObraSocial { IdObraSocial = idObraSocial };
                nuevoTurno.Plan = new PlanObraSocial { IdPlan = idPlan };
                nuevoTurno.NumeroAfiliado = txtNumeroAfiliado.Text.Trim();

                int idTurnoGenerado = turnoNegocio.agregar(nuevoTurno);

                if (idTurnoGenerado > 0)
                {
                    Response.Redirect(string.Format("~/TurnoConfirmado.aspx?id={0}", idTurnoGenerado), false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    MostrarError("No se pudo generar el turno. Por favor intente nuevamente.");
                }
            }
            catch (Exception ex)
            {
                MostrarError("Ocurrió un error al agendar el turno: " + ex.Message);
            }
        }

        #endregion

        #region Helpers de Mensajes

        private void MostrarError(string mensaje)
        {
            lblMensajeError.Text = "<div class='d-flex align-items-center gap-2'><span class='material-symbols-outlined'>error</span><span>" + mensaje + "</span></div>";
            lblMensajeError.Visible = true;
            lblMensajeExito.Visible = false;
        }

        private void OcultarAlertas()
        {
            lblMensajeError.Visible = false;
            lblMensajeExito.Visible = false;
        }

        #endregion
    }
}
