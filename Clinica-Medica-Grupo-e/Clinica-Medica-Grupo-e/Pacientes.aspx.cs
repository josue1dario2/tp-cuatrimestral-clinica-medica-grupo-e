using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class Pacientes : Page
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
            PacienteNegocio negocio = new PacienteNegocio();
            try
            {
                List<Paciente> lista = negocio.listar();
                Session["listaPacientes"] = lista;
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
            if (Session["listaPacientes"] != null)
            {
                List<Paciente> lista = (List<Paciente>)Session["listaPacientes"];

                string filtro = txtFiltro.Text.Trim();
                if (!string.IsNullOrEmpty(filtro))
                {
                    lista = lista.FindAll(p =>
                        (!string.IsNullOrEmpty(p.NombreCompleto) && p.NombreCompleto.ToUpper().Contains(filtro.ToUpper())) ||
                        (!string.IsNullOrEmpty(p.Dni) && p.Dni.ToUpper().Contains(filtro.ToUpper())) ||
                        (!string.IsNullOrEmpty(p.Email) && p.Email.ToUpper().Contains(filtro.ToUpper()))
                    );
                }

                dgvPacientes.DataSource = lista;
                dgvPacientes.DataBind();
            }
        }

        protected void dgvPacientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvPacientes.PageIndex = e.NewPageIndex;
            aplicarFiltros();
        }

        protected void dgvPacientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string id = dgvPacientes.SelectedDataKey.Value.ToString();
                Response.Redirect("FormularioPaciente.aspx?id=" + id, false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            dgvPacientes.PageIndex = 0;
            aplicarFiltros();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            dgvPacientes.PageIndex = 0;
            aplicarFiltros();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = string.Empty;
            dgvPacientes.PageIndex = 0;
            aplicarFiltros();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormularioPaciente.aspx", false);
        }
    }
}
