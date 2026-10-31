using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class EspecialidadesLista : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cargarGrilla();
            }
        }

        private void cargarGrilla()
        {
            EspecialidadNegocio negocio = new EspecialidadNegocio();
            try
            {
                List<Especialidad> lista = negocio.listar();
                dgvEspecialidades.DataSource = lista;
                dgvEspecialidades.DataBind();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void dgvEspecialidades_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvEspecialidades.PageIndex = e.NewPageIndex;
            cargarGrilla();
        }

        protected void dgvEspecialidades_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string id = dgvEspecialidades.SelectedDataKey.Value.ToString();
                Response.Redirect("FormularioEspecialidad.aspx?id=" + id, false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormularioEspecialidad.aspx", false);
        }
    }
}

