using System;
using System.Globalization;
using System.Web.UI;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class CancelarTurno : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblBreadcrumbNumero.Text = "";

                // Se llega desde Turnos.aspx con CancelarTurno.aspx?id=5
                int idTurno;
                if (!int.TryParse(Request.QueryString["id"], out idTurno))
                {
                    MostrarNoDisponible("No se indicó qué turno cancelar. Volvé al listado y elegí uno.");
                    return;
                }

                try
                {
                    CargarTurno(idTurno);
                }
                catch (Exception ex)
                {
                    MostrarNoDisponible("No se pudo cargar el turno: " + ex.Message);
                }
            }
        }


        // Carga de datos


        // Busca el turno y completa los datos de la tarjeta.
        private void CargarTurno(int idTurno)
        {
            Turno turno = new TurnoNegocio().buscarPorId(idTurno);
            if (turno == null)
            {
                MostrarNoDisponible("El turno seleccionado ya no existe.");
                return;
            }

            lblBreadcrumbNumero.Text = "#" + turno.NumeroTurno;

            // Solo se cancelan turnos Nuevos o Reprogramados (igual que PuedeCancelar en Turnos.aspx.cs).
            if (turno.Estado != EstadoTurno.Nuevo && turno.Estado != EstadoTurno.Reprogramado)
            {
                MostrarNoDisponible("El turno #" + turno.NumeroTurno + " está " + TextoEstado(turno.Estado).ToLower()
                    + " y ya no se puede cancelar.");
                return;
            }

            hfIdTurno.Value = turno.Id.ToString();

            lblCodigo.Text = "#" + turno.NumeroTurno;
            lblEstado.Text = TextoEstado(turno.Estado);
            lblEstado.CssClass = "badge-estado " + CssEstado(turno.Estado);

            lblPaciente.Text = turno.Paciente.NombreCompleto;
            lblPacienteDetalle.Text = "DNI " + FormatearDni(turno.Paciente.Dni) + " • " + TextoCobertura(turno);

            lblMedico.Text = turno.Medico.NombreCompleto;
            lblMedicoDetalle.Text = turno.Especialidad.Descripcion;

            string fecha = turno.Fecha.ToString("dddd d 'de' MMMM 'de' yyyy", Cultura);
            lblFecha.Text = char.ToUpper(fecha[0]) + fecha.Substring(1) + " - " + turno.HoraTexto;
        }


        // Eventos


        protected void btnConfirmarCancelacion_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            string motivo = txtMotivoCancelacion.Text.Trim();

            // 1) Validaciones
            if (motivo.Length < 5)
            {
                MostrarError("Escribí el motivo de la cancelación (al menos 5 caracteres).");
                return;
            }
            if (motivo.Length > 300)
            {
                MostrarError("El motivo no puede superar los 300 caracteres (tiene " + motivo.Length + ").");
                return;
            }

            int idTurno;
            if (!int.TryParse(hfIdTurno.Value, out idTurno))
            {
                MostrarNoDisponible("No se encontró el turno a cancelar. Volvé al listado y elegilo de nuevo.");
                return;
            }

            // 2) Cancelar
            bool cancelado;
            try
            {
                cancelado = new TurnoNegocio().cancelar(idTurno, motivo);
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo cancelar el turno: " + ex.Message);
                return;
            }

            if (!cancelado)
            {
                MostrarNoDisponible("El turno " + lblCodigo.Text + " ya no se puede cancelar: cambió de estado mientras tanto.");
                return;
            }

            if (chkNotificarPaciente.Checked)
            {
                // TODO: enviar el email de aviso al paciente.
            }

            // 3) Volver al listado. Turnos.aspx lee este mensaje de la sesión y lo muestra en verde.
            Session["MensajeTurnos"] = "Se canceló el turno " + lblCodigo.Text + " de " + lblPaciente.Text
                + ". El horario quedó libre en la agenda.";
            Response.Redirect("~/Turnos.aspx");
        }


        // Mensajes


        // Error que permite corregir y volver a intentar (el formulario sigue visible).
        private void MostrarError(string mensaje)
        {
            lblError.Text = mensaje;
            pnlError.Visible = true;
        }

        // Error sin vuelta atrás: se oculta el formulario y solo queda volver al listado.
        private void MostrarNoDisponible(string mensaje)
        {
            MostrarError(mensaje);
            pnlFormulario.Visible = false;
        }


        // Ayudantes de formato (los mismos que usa Turnos.aspx.cs)


        // "OSDE 310", "Galeno" o "Particular".
        private static string TextoCobertura(Turno turno)
        {
            if (turno.ObraSocial == null)
                return "Particular";
            if (turno.Plan == null)
                return turno.ObraSocial.Nombre;
            return turno.ObraSocial.Nombre + " " + turno.Plan.NombrePlan;
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

        // "35111222" -> "35.111.222".
        private static string FormatearDni(string dni)
        {
            long numero;
            return long.TryParse(dni, out numero) ? numero.ToString("#,0", Cultura) : dni;
        }
    }
}
