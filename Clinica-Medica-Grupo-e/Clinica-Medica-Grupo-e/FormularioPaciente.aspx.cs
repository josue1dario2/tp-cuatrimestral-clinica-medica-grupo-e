using System;
using System.Web.UI;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class FormularioPaciente : Page
    {
        public bool ConfirmaEliminacion
        {
            get { return ViewState["ConfirmaEliminacion"] != null && (bool)ViewState["ConfirmaEliminacion"]; }
            set { ViewState["ConfirmaEliminacion"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            lblErrorValidacion.Visible = false;

            if (!IsPostBack)
            {
                ConfirmaEliminacion = false;

                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    lblTitulo.Text = "Modificar Paciente";
                    PacienteNegocio negocio = new PacienteNegocio();

                    try
                    {
                        Paciente seleccionado = negocio.buscarPorId(int.Parse(id));
                        if (seleccionado != null)
                        {
                            txtNombre.Text = seleccionado.Nombre;
                            txtApellido.Text = seleccionado.Apellido;
                            txtDni.Text = seleccionado.Dni;
                            txtFechaNacimiento.Text = seleccionado.FechaNacimiento.ToString("yyyy-MM-dd");
                            txtEmail.Text = seleccionado.Email ?? string.Empty;
                            txtTelefono.Text = seleccionado.Telefono ?? string.Empty;
                            txtDireccion.Text = seleccionado.Direccion ?? string.Empty;
                        }
                        else
                        {
                            Response.Redirect("Pacientes.aspx", false);
                        }
                    }
                    catch (Exception ex)
                    {
                        Session.Add("error", ex.ToString());
                        Response.Redirect("Error.aspx", false);
                    }
                }
                else
                {
                    lblTitulo.Text = "Nuevo Paciente";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                mostrarError("El nombre del paciente es obligatorio.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtApellido.Text))
            {
                mostrarError("El apellido del paciente es obligatorio.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDni.Text))
            {
                mostrarError("El DNI del paciente es obligatorio.");
                return;
            }

            DateTime fechaNac;
            if (string.IsNullOrWhiteSpace(txtFechaNacimiento.Text) || !DateTime.TryParse(txtFechaNacimiento.Text, out fechaNac))
            {
                mostrarError("La fecha de nacimiento es obligatoria y debe tener un formato válido.");
                return;
            }

            if (fechaNac.Date > DateTime.Today)
            {
                mostrarError("La fecha de nacimiento no puede ser una fecha futura.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtEmail.Text) || !txtEmail.Text.Contains("@") || !txtEmail.Text.Contains("."))
            {
                mostrarError("El correo electrónico es obligatorio y debe tener un formato válido.");
                return;
            }

            PacienteNegocio negocio = new PacienteNegocio();
            Paciente paciente = new Paciente();

            try
            {
                paciente.Nombre = txtNombre.Text.Trim();
                paciente.Apellido = txtApellido.Text.Trim();
                paciente.Dni = txtDni.Text.Trim();
                paciente.FechaNacimiento = fechaNac;
                paciente.Email = txtEmail.Text.Trim();
                paciente.Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text) ? null : txtTelefono.Text.Trim();
                paciente.Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim();

                if (Request.QueryString["id"] != null)
                {
                    paciente.Id = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(paciente);
                }
                else
                {
                    negocio.agregar(paciente);
                }

                Response.Redirect("Pacientes.aspx", false);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("duplicada") || ex.Message.Contains("UNIQUE") || ex.Message.Contains("DNI") || ex.Message.Contains("Dni"))
                {
                    mostrarError("El DNI \"" + txtDni.Text.Trim() + "\" ya se encuentra registrado en el sistema. Ingrese un DNI diferente.");
                    return;
                }

                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void mostrarError(string mensaje)
        {
            lblErrorValidacion.Text = "<i class='bi bi-exclamation-triangle-fill me-2'></i>" + mensaje;
            lblErrorValidacion.Visible = true;
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            ConfirmaEliminacion = true;
        }

        protected void chkConfirmarEliminar_CheckedChanged(object sender, EventArgs e)
        {
            btnConfirmarEliminar.Enabled = chkConfirmarEliminar.Checked;
        }

        protected void btnConfirmarEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                if (chkConfirmarEliminar.Checked && Request.QueryString["id"] != null)
                {
                    PacienteNegocio negocio = new PacienteNegocio();
                    negocio.eliminar(int.Parse(Request.QueryString["id"]));
                    Response.Redirect("Pacientes.aspx", false);
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}

