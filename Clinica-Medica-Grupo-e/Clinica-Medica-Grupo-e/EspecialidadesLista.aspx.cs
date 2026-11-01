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
                Session["listaEspecialidades"] = lista;
                aplicarFiltro();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void aplicarFiltro()
        {
            if (Session["listaEspecialidades"] != null)
            {
                List<Especialidad> lista = (List<Especialidad>)Session["listaEspecialidades"];
                string filtro = txtFiltro.Text.Trim();

                if (!string.IsNullOrEmpty(filtro))
                {
                    lista = lista.FindAll(x => x.Descripcion.ToUpper().Contains(filtro.ToUpper()));
                }

                dgvEspecialidades.DataSource = lista;
                dgvEspecialidades.DataBind();
            }
        }

        protected void dgvEspecialidades_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvEspecialidades.PageIndex = e.NewPageIndex;
            aplicarFiltro();
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

        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            dgvEspecialidades.PageIndex = 0;
            aplicarFiltro();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = string.Empty;
            dgvEspecialidades.PageIndex = 0;
            aplicarFiltro();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormularioEspecialidad.aspx", false);
        }
    }
}
