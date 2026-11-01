using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;
using Medico = dominio.Medico;

namespace Clinica_Medica_Grupo_e
{
    public partial class FormularioMedico : Page
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
                cargarDesplegables();

                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    lblTitulo.Text = "Modificar Médico";
                    MedicoNegocio negocio = new MedicoNegocio();

                    try
                    {
                        Medico seleccionado = negocio.buscarPorId(int.Parse(id));
                        if (seleccionado != null)
                        {
                            txtNombre.Text = seleccionado.Nombre;
                            txtApellido.Text = seleccionado.Apellido;
                            txtMatricula.Text = seleccionado.Matricula;
                            txtEmail.Text = seleccionado.Email ?? string.Empty;
                            txtTelefono.Text = seleccionado.Telefono ?? string.Empty;

                            if (seleccionado.TurnoTrabajo != null && ddlTurnoTrabajo.Items.FindByValue(seleccionado.TurnoTrabajo.Id.ToString()) != null)
                            {
                                ddlTurnoTrabajo.SelectedValue = seleccionado.TurnoTrabajo.Id.ToString();
                            }

                            if (seleccionado.EspecialidadPrincipalId > 0 && ddlEspecialidad.Items.FindByValue(seleccionado.EspecialidadPrincipalId.ToString()) != null)
                            {
                                ddlEspecialidad.SelectedValue = seleccionado.EspecialidadPrincipalId.ToString();
                            }
                        }
                        else
                        {
                            Response.Redirect("Medicos.aspx", false);
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
                    lblTitulo.Text = "Nuevo Médico";
                }
            }
        }

        private void cargarDesplegables()
        {
            try
            {
                // Especialidades
                EspecialidadNegocio espNegocio = new EspecialidadNegocio();
                List<Especialidad> listaEsp = espNegocio.listar();
                ddlEspecialidad.Items.Clear();
                ddlEspecialidad.Items.Add(new ListItem("-- Seleccione Especialidad --", "0"));
                foreach (Especialidad esp in listaEsp)
                {
                    ddlEspecialidad.Items.Add(new ListItem(esp.Descripcion, esp.Id.ToString()));
                }

                // Turnos de trabajo
                TurnoTrabajoNegocio turnoNegocio = new TurnoTrabajoNegocio();
                List<TurnoTrabajo> listaTurnos = turnoNegocio.listar();
                ddlTurnoTrabajo.Items.Clear();
                ddlTurnoTrabajo.Items.Add(new ListItem("-- Seleccione Turno --", "0"));
                foreach (TurnoTrabajo tt in listaTurnos)
                {
                    ddlTurnoTrabajo.Items.Add(new ListItem(tt.Nombre + " (" + tt.HoraEntrada + " a " + tt.HoraSalida + " hs)", tt.Id.ToString()));
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                mostrarError("El nombre del médico es obligatorio.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtApellido.Text))
            {
                mostrarError("El apellido del médico es obligatorio.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtMatricula.Text))
            {
                mostrarError("La matrícula del médico es obligatoria.");
                return;
            }

            if (ddlEspecialidad.SelectedValue == "0")
            {
                mostrarError("Debe seleccionar una especialidad.");
                return;
            }

            if (ddlTurnoTrabajo.SelectedValue == "0")
            {
                mostrarError("Debe seleccionar un turno de trabajo.");
                return;
            }

            MedicoNegocio negocio = new MedicoNegocio();
            Medico medico = new Medico();

            try
            {
                medico.Nombre = txtNombre.Text.Trim();
                medico.Apellido = txtApellido.Text.Trim();
                medico.Matricula = txtMatricula.Text.Trim();
                medico.Email = string.IsNullOrWhiteSpace(txtEmail.Text) ? null : txtEmail.Text.Trim();
                medico.Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text) ? null : txtTelefono.Text.Trim();
                medico.TurnoTrabajo = new TurnoTrabajo { Id = int.Parse(ddlTurnoTrabajo.SelectedValue) };

                int idEspecialidad = int.Parse(ddlEspecialidad.SelectedValue);

                if (Request.QueryString["id"] != null)
                {
                    medico.Id = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(medico, idEspecialidad);
                }
                else
                {
                    negocio.agregar(medico, idEspecialidad);
                }

                Response.Redirect("Medicos.aspx", false);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("duplicada") || ex.Message.Contains("UNIQUE") || ex.Message.Contains("matrícula") || ex.Message.Contains("Matricula"))
                {
                    mostrarError("La matrícula \"" + txtMatricula.Text.Trim() + "\" ya se encuentra registrada en el sistema. Ingrese una matrícula diferente.");
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
                    MedicoNegocio negocio = new MedicoNegocio();
                    negocio.eliminar(int.Parse(Request.QueryString["id"]));
                    Response.Redirect("Medicos.aspx", false);
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

