using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace Clinica_Medica_Grupo_e
{
    public partial class PlanesObraSocial : System.Web.UI.Page
    {


        private int IdObraSocial
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["idObraSocial"], out id);
                return id;
            }
        }

        private void CargarObraSocial()
        {
            ObraSocialNegocio negocio = new ObraSocialNegocio();

            ObraSocial obraSocial = negocio.BuscarPorIDSP(IdObraSocial);

            if (obraSocial == null)
            {
                Response.Redirect("GestionObraSociales.aspx");
                return;
            }

            lblNombreObraSocial.Text = obraSocial.Nombre;
            lblObraSocialFormulario.Text = obraSocial.Nombre;
        }

        private void AplicarFiltrosdgv()
        {
            string texto = txtBuscarPlan.Text.Trim();

            PlanObraSocialNegocio negocio = new PlanObraSocialNegocio();

            List<PlanObraSocial> lista =
                negocio.ListarSP(texto, IdObraSocial, null);

            if (ddlFiltroEstadoPlan.SelectedValue == "1")
            {
                lista = lista.Where(x => x.Activo).ToList();
            }
            else if (ddlFiltroEstadoPlan.SelectedValue == "0")
            {
                lista = lista.Where(x => !x.Activo).ToList();
            }

            dgvPlanes.DataSource = lista;
            dgvPlanes.DataBind();

            updPlanes.Update();
        }

        private void LimpiarFormulario()
        {
            hfIdPlan.Value = "";
            txtNombrePlan.Text = "";

            lblTituloFormulario.Text = "Nuevo plan";
            pnlMensaje.Visible = false;
        }

        private void MostrarMensaje(string mensaje, bool correcto)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;

            pnlMensaje.CssClass = "p-2 rounded-2 mb-3";

            if (correcto)
            {
                pnlMensaje.Style["background-color"] = "#d1f2d9";
                pnlMensaje.Style["color"] = "#005320";
            }
            else
            {
                pnlMensaje.Style["background-color"] = "#f8d7da";
                pnlMensaje.Style["color"] = "#842029";
            }

            updFormulario.Update();
        }

        private void AbrirFormulario()
        {
            string script =
                "var offcanvas = bootstrap.Offcanvas.getOrCreateInstance(document.getElementById('drawerPlan')); offcanvas.show();";

            ScriptManager.RegisterStartupScript(
                this, GetType(), "AbrirFormularioPlan", script, true);
        }

        private void CerrarFormulario()
        {
            string script =
                "var offcanvas = bootstrap.Offcanvas.getOrCreateInstance(document.getElementById('drawerPlan')); offcanvas.hide();";

            ScriptManager.RegisterStartupScript(
                this, GetType(), "CerrarFormularioPlan", script, true);
        }




        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (IdObraSocial <= 0)
                {
                    Response.Redirect("GestionObraSociales.aspx");
                    return;
                }

                CargarObraSocial();
                AplicarFiltrosdgv();
            }
        }

        protected void btnNuevoPlan_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();

            lblTituloFormulario.Text = "Nuevo plan";

            updFormulario.Update();

            AbrirFormulario();
        }

        protected void txtBuscarPlan_TextChanged(object sender, EventArgs e)
        {
            dgvPlanes.PageIndex = 0;
            AplicarFiltrosdgv();
        }

        protected void ddlFiltroEstadoPlan_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvPlanes.PageIndex = 0;
            AplicarFiltrosdgv();
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtBuscarPlan.Text = "";
            ddlFiltroEstadoPlan.SelectedValue = "";

            dgvPlanes.PageIndex = 0;

            AplicarFiltrosdgv();
        }

        protected void dgvPlanes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvPlanes.PageIndex = e.NewPageIndex;

            AplicarFiltrosdgv();
        }

        protected void btnEditarPlan_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;

            GridViewRow fila = (GridViewRow)boton.NamingContainer;

            int id = (int)dgvPlanes.DataKeys[fila.RowIndex].Value;

            PlanObraSocialNegocio negocio = new PlanObraSocialNegocio();

            PlanObraSocial aux = negocio.BuscarPorIDSP(id);

            if (aux != null)
            {
                hfIdPlan.Value = aux.IdPlan.ToString();

                txtNombrePlan.Text = aux.NombrePlan;

                lblTituloFormulario.Text = "Editar plan";

                pnlMensaje.Visible = false;

                updFormulario.Update();

                AbrirFormulario();
            }
        }

        protected void btnGuardarPlan_Click(object sender, EventArgs e)
        {
            string nombre = txtNombrePlan.Text.Trim();

            if (string.IsNullOrWhiteSpace(nombre))
            {
                MostrarMensaje("El nombre del plan es obligatorio.", false);
                AbrirFormulario();
                return;
            }

            try
            {
                PlanObraSocial plan = new PlanObraSocial();

                plan.NombrePlan = nombre;
                plan.IdObraSocial = IdObraSocial;

                PlanObraSocialNegocio negocio = new PlanObraSocialNegocio();

                if (string.IsNullOrWhiteSpace(hfIdPlan.Value))
                {
                    negocio.RegistrarSP(plan);

                    MostrarMensaje("Plan registrado correctamente.", true);
                }
                else
                {
                    plan.IdPlan = int.Parse(hfIdPlan.Value);

                    negocio.ModificarSP(plan);

                    MostrarMensaje("Plan modificado correctamente.", true);
                }

                LimpiarFormulario();

                AplicarFiltrosdgv();

                CerrarFormulario();
            }
            catch (Exception ex)
            {
                MostrarMensaje(ex.Message, false);
                AbrirFormulario();
            }
        }

        protected void chkEstadoPlan_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            GridViewRow fila = (GridViewRow)chk.NamingContainer;

            int id = (int)dgvPlanes.DataKeys[fila.RowIndex].Value;

            PlanObraSocialNegocio negocio = new PlanObraSocialNegocio();

            negocio.ModificarEstadoSP(id);

            AplicarFiltrosdgv();
        }
    }
}