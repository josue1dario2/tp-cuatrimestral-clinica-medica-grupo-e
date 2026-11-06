using System;
using System.Globalization;
using System.Web.UI;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class TurnoConfirmado : Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idTurno = 0;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out idTurno))
                {
                    CargarTurno(idTurno);
                }
            }
        }

        private void CargarTurno(int idTurno)
        {
            try
            {
                TurnoNegocio negocio = new TurnoNegocio();
                Turno turno = negocio.buscarPorId(idTurno);

                if (turno != null)
                {
                    hfIdTurno.Value = turno.Id.ToString();
                    lblTransaccion.Text = "TX-" + turno.NumeroTurno.ToString() + "-OK";
                    lblCodigoTurno.Text = "#" + turno.NumeroTurno.ToString();
                    lblEstado.Text = turno.Estado.ToString().ToUpper();

                    // Paciente
                    if (turno.Paciente != null)
                    {
                        lblPacienteNombre.Text = turno.Paciente.Apellido + ", " + turno.Paciente.Nombre;
                        lblPacienteDni.Text = turno.Paciente.Dni;
                        lblPacienteTelefono.Text = !string.IsNullOrEmpty(turno.Paciente.Telefono) ? turno.Paciente.Telefono : "No informado";

                        if (!string.IsNullOrEmpty(turno.Paciente.Email))
                        {
                            pnlEmailEnviado.Visible = true;
                            pnlSinEmail.Visible = false;
                            lblEmailConfirmacion.Text = turno.Paciente.Email;
                        }
                        else
                        {
                            pnlEmailEnviado.Visible = false;
                            pnlSinEmail.Visible = true;
                        }
                    }

                    // Cobertura y Plan
                    if (turno.ObraSocial != null && !string.IsNullOrEmpty(turno.ObraSocial.Nombre))
                    {
                        string cob = turno.ObraSocial.Nombre;
                        if (turno.Plan != null && !string.IsNullOrEmpty(turno.Plan.NombrePlan) && turno.Plan.NombrePlan != turno.ObraSocial.Nombre)
                            cob += " - " + turno.Plan.NombrePlan;
                        lblCobertura.Text = cob;
                    }
                    else
                    {
                        lblCobertura.Text = "Particular";
                    }

                    lblNroAfiliado.Text = !string.IsNullOrEmpty(turno.NumeroAfiliado) ? turno.NumeroAfiliado : "No aplica / Particular";

                    // Médico y Especialidad
                    if (turno.Medico != null)
                    {
                        lblMedicoNombre.Text = "Dr. " + turno.Medico.Apellido + ", " + turno.Medico.Nombre;
                        lblMatricula.Text = turno.Medico.Matricula;
                        if (turno.Medico.TurnoTrabajo != null)
                            lblConsultorio.Text = "Turno " + turno.Medico.TurnoTrabajo.Nombre;
                    }

                    if (turno.Especialidad != null)
                        lblEspecialidad.Text = turno.Especialidad.Descripcion;

                    lblFecha.Text = turno.Fecha.ToString("dddd dd 'de' MMMM, yyyy", Cultura);
                    lblHora.Text = turno.HoraTexto;
                    lblDuracion.Text = "60 min";
                    lblPrestacion.Text = "Consulta médica programada (" + (turno.Especialidad != null ? turno.Especialidad.Descripcion : "General") + ")";

                    lblMotivo.Text = !string.IsNullOrWhiteSpace(turno.Observaciones) ? turno.Observaciones : "Consulta médica general.";
                }
            }
            catch (Exception)
            {
                // En caso de error, se dejan los valores por defecto del HTML
            }
        }

        protected void btnEnviarWhatsApp_Click(object sender, EventArgs e)
        {
        }

        protected void btnDescargarPdf_Click(object sender, EventArgs e)
        {
        }

        protected void btnGuardarEmail_Click(object sender, EventArgs e)
        {
        }
    }
}
