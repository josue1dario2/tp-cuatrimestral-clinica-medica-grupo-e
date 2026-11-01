using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class Medicos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cargarEspecialidades();
                cargarGrilla();
            }
        }

        private void cargarEspecialidades()
        {
            EspecialidadNegocio negocio = new EspecialidadNegocio();
            try
            {
                List<Especialidad> lista = negocio.listar();
                ddlFiltroEspecialidad.Items.Clear();
                ddlFiltroEspecialidad.Items.Add(new ListItem("Todas las especialidades", "0"));

                foreach (Especialidad esp in lista)
                {
                    ddlFiltroEspecialidad.Items.Add(new ListItem(esp.Descripcion, esp.Id.ToString()));
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void cargarGrilla()
        {
            MedicoNegocio negocio = new MedicoNegocio();
            try
            {
                List<Medico> lista = negocio.listarConDetalle();
                Session["listaMedicos"] = lista;
                aplicarFiltros();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void aplicarFiltros()
        {
            if (Session["listaMedicos"] != null)
            {
                List<Medico> lista = (List<Medico>)Session["listaMedicos"];

                if (ddlFiltroEspecialidad.SelectedValue != "0")
                {
                    int idEspecialidad = int.Parse(ddlFiltroEspecialidad.SelectedValue);
                    lista = lista.FindAll(m => m.Especialidades != null && m.Especialidades.Any(esp => esp.Id == idEspecialidad));
                }

                string filtro = txtFiltro.Text.Trim();
                if (!string.IsNullOrEmpty(filtro))
                {
                    lista = lista.FindAll(m => 
                        (!string.IsNullOrEmpty(m.NombreCompleto) && m.NombreCompleto.ToUpper().Contains(filtro.ToUpper())) ||
                        (!string.IsNullOrEmpty(m.Matricula) && m.Matricula.ToUpper().Contains(filtro.ToUpper()))
                    );
                }

                dgvMedicos.DataSource = lista;
                dgvMedicos.DataBind();
            }
        }

        protected void dgvMedicos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvMedicos.PageIndex = e.NewPageIndex;
            aplicarFiltros();
        }

        protected void dgvMedicos_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string id = dgvMedicos.SelectedDataKey.Value.ToString();
                Response.Redirect("FormularioMedico.aspx?id=" + id, false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void ddlFiltroEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvMedicos.PageIndex = 0;
            aplicarFiltros();
        }

        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            dgvMedicos.PageIndex = 0;
            aplicarFiltros();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = string.Empty;
            ddlFiltroEspecialidad.SelectedIndex = 0;
            dgvMedicos.PageIndex = 0;
            aplicarFiltros();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormularioMedico.aspx", false);
        }
    }
}
