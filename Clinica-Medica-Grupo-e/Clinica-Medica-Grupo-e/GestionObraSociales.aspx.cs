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
    public partial class GestionObraSociales : System.Web.UI.Page
    {

        private ObraSocialNegocio negocioObraSocial= new ObraSocialNegocio();


        private void CargarObrasSociales()
        {
            {
                ObraSocialNegocio obraSocial = new ObraSocialNegocio();

                dgvObrasSociales.DataSource = obraSocial.ListarSP("");
                dgvObrasSociales.DataBind();
            }
        }

        private void LimpiarFormulario()
        {
            hfIdObraSocial.Value = "";

            txtNombreObraSocial.Text = "";
            txtSiglaObraSocial.Text = "";

            lblTituloFormulario.Text = "Nueva obra social";

            pnlMensaje.Visible = false;
        }

        private void MostrarMensaje(string mensaje, bool correcto)
        {
            pnlMensaje.Visible = true;

            lblMensaje.Text = mensaje;

            if (correcto)
            {
                pnlMensaje.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensaje.Style["background-color"] = "#d1f2d9";
                pnlMensaje.Style["color"] = "#005320";
            }
            else
            {
                pnlMensaje.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensaje.Style["background-color"] = "#f8d7da";
                pnlMensaje.Style["color"] = "#842029";
            }

            updFormulario.Update();
        }

        private void AbrirFormulario()
        {
            string script = "var offcanvas = bootstrap.Offcanvas.getOrCreateInstance(document.getElementById('drawerObraSocial')); offcanvas.show();";

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "AbrirFormulario",
                script,
                true
            );
        }

        private void CerrarFormulario()
        {
            string script = "var offcanvas = bootstrap.Offcanvas.getOrCreateInstance(document.getElementById('drawerObraSocial')); offcanvas.hide();";

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "CerrarFormulario",
                script,
                true
            );
        }
    


        private void AplicarFiltrosdgv()
        {
            string texto = txtBuscarObraSocial.Text.Trim();

            ObraSocialNegocio negocio = new ObraSocialNegocio();

            List<ObraSocial> lista = negocio.ListarSP(texto);

            if (ddlFiltroEstado.SelectedValue == "1")
            {
                lista = lista.Where(x => x.Activo).ToList();
            }
            else if (ddlFiltroEstado.SelectedValue == "0")
            {
                lista = lista.Where(x => !x.Activo).ToList();
            }

            dgvObrasSociales.DataSource = lista;
            dgvObrasSociales.DataBind();

            updObrasSociales.Update();
        }




        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarObrasSociales();
            }
        }

        protected void txtBuscarObraSocial_TextChanged(object sender, EventArgs e)
        {
            dgvObrasSociales.PageIndex = 0;
            AplicarFiltrosdgv();
        }

        protected void ddlFiltroEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvObrasSociales.PageIndex = 0;
            AplicarFiltrosdgv();
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtBuscarObraSocial.Text = "";
            ddlFiltroEstado.SelectedValue = "";

            dgvObrasSociales.PageIndex = 0;

            AplicarFiltrosdgv();
        }

        protected void dgvObrasSociales_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvObrasSociales.PageIndex = e.NewPageIndex;
            CargarObrasSociales();
        }

        protected void chkEstado_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            GridViewRow fila = (GridViewRow)chk.NamingContainer;

            int id = (int)dgvObrasSociales.DataKeys[fila.RowIndex].Value;

            ObraSocialNegocio negocio = new ObraSocialNegocio();

            negocio.ModificarEstadoSP(id);

            AplicarFiltrosdgv();
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;

            GridViewRow fila = (GridViewRow)boton.NamingContainer;

            int id = (int)dgvObrasSociales.DataKeys[fila.RowIndex].Value;

            ObraSocialNegocio negocio = new ObraSocialNegocio();

            ObraSocial aux = negocio.BuscarPorIDSP(id);

            if (aux != null)
            {
                hfIdObraSocial.Value = aux.IdObraSocial.ToString();

                txtNombreObraSocial.Text = aux.Nombre;
                txtSiglaObraSocial.Text = aux.Sigla ?? "";

                lblTituloFormulario.Text = "Editar obra social";

                pnlMensaje.Visible = false;

                updFormulario.Update();

                AbrirFormulario();
            }
        }

        protected void btnDetalles_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;

            GridViewRow fila = (GridViewRow)boton.NamingContainer;

            int id = (int)dgvObrasSociales.DataKeys[fila.RowIndex].Value;

            Response.Redirect("PlanesObraSocial.aspx?idObraSocial=" + id);
        }

        protected void btnGuardarObraSocial_Click(object sender, EventArgs e)
        {
            string nombre = txtNombreObraSocial.Text.Trim();
            string sigla = txtSiglaObraSocial.Text.Trim();

            if (string.IsNullOrWhiteSpace(nombre))
            {
                MostrarMensaje("El nombre de la obra social es obligatorio.", false);
                AbrirFormulario();
                return;
            }

            try
            {
                ObraSocial obraSocial = new ObraSocial();

                obraSocial.Nombre = nombre;
                obraSocial.Sigla = string.IsNullOrWhiteSpace(sigla) ? null : sigla;

                ObraSocialNegocio negocio = new ObraSocialNegocio();

                if (string.IsNullOrWhiteSpace(hfIdObraSocial.Value))
                {
                    negocio.RegistrarSP(obraSocial);
                    MostrarMensaje("Obra social registrada correctamente.", true);
                }
                else
                {
                    obraSocial.IdObraSocial = int.Parse(hfIdObraSocial.Value);

                    negocio.ModificarSP(obraSocial);
                    MostrarMensaje("Obra social modificada correctamente.", true);
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
    }
}