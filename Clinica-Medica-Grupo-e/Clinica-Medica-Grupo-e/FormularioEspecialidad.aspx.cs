using System;
using System.Collections.Generic;
using System.Web.UI;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class FormularioEspecialidad : Page
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
                    lblTitulo.Text = "Modificar Especialidad";
                    EspecialidadNegocio negocio = new EspecialidadNegocio();

                    try
                    {
                        Especialidad seleccionada = negocio.buscarPorId(int.Parse(id));
                        if (seleccionada != null)
                        {
                            txtId.Text = seleccionada.Id.ToString();
                            txtDescripcion.Text = seleccionada.Descripcion;
                        }
                        else
                        {
                            Response.Redirect("EspecialidadesLista.aspx", false);
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
                    lblTitulo.Text = "Nueva Especialidad";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
            {
                lblErrorValidacion.Text = "La descripción de la especialidad es obligatoria.";
                lblErrorValidacion.Visible = true;
                return;
            }

            EspecialidadNegocio negocio = new EspecialidadNegocio();
            Especialidad especialidad = new Especialidad();

            try
            {
                especialidad.Descripcion = txtDescripcion.Text.Trim();

                if (Request.QueryString["id"] != null)
                {
                    especialidad.Id = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(especialidad);
                }
                else
                {
                    negocio.agregar(especialidad);
                }

                Response.Redirect("EspecialidadesLista.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
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
                    int id = int.Parse(Request.QueryString["id"]);
                    EspecialidadNegocio negocio = new EspecialidadNegocio();
                    negocio.eliminar(id);
                    Response.Redirect("EspecialidadesLista.aspx", false);
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

