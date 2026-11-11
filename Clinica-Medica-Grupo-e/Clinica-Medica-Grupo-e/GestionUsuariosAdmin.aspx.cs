using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Data.SqlClient;

namespace Clinica_Medica_Grupo_e
{
    public partial class GestionUsuariosAdmin : System.Web.UI.Page
    {

        private void CargarUsuarios()
        {
            UsuarioNegocio usuario = new UsuarioNegocio();

            dgvUsuarios.DataSource = usuario.ListarUsuarios();
            dgvUsuarios.DataBind();
        }

        private void AplicarFiltrosdgv()
        {
            string texto = txtBuscarUsuario.Text.Trim();

            int? rol = string.IsNullOrEmpty(ddlfiltrobuscarrol.SelectedValue) ? (int?)null : int.Parse(ddlfiltrobuscarrol.SelectedValue);

            bool? activo = string.IsNullOrEmpty(ddlFiltroActividad.SelectedValue)
                ? (bool?)null : ddlFiltroActividad.SelectedValue == "1" ? true : false;









            UsuarioNegocio usuario = new UsuarioNegocio();
            dgvUsuarios.DataSource = usuario.AplicarFiltros(texto, rol, activo);
            dgvUsuarios.DataBind();

            updUsuarios.Update();









        }

        private void CargarMedicosSinUsuarios()
        {
            MedicoNegocio medico = new MedicoNegocio();
            ddlMedicosAasociar.DataSource = medico.ListarMedicoSinUsuario();
            ddlMedicosAasociar.DataTextField = "NombreCompleto";
            ddlMedicosAasociar.DataValueField = "id";
            ddlMedicosAasociar.DataBind();
        }

        private void CargarEmailMedico()
        {
            int id = int.Parse(ddlMedicosAasociar.SelectedValue);
            MedicoNegocio medico = new MedicoNegocio();
            Medico aux = new Medico();
            aux = medico.buscarPorId(id);




            if (string.IsNullOrEmpty(aux.Email))
            {
                txtCorreoAgregar.Text = "";
                txtCorreoAgregar.ReadOnly = false;
            }

            else
            {
                txtCorreoAgregar.Text = aux.Email;
                txtCorreoAgregar.ReadOnly = true;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            { CargarUsuarios(); }

        }

        protected void chkEstado_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            GridViewRow fila = (GridViewRow)chk.NamingContainer;

            int id = (int)dgvUsuarios.DataKeys[fila.RowIndex].Value;

            UsuarioNegocio usuario = new UsuarioNegocio();

            usuario.modificarEstado(id);

            CargarUsuarios();

        }

        protected void dgvUsuarios_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvUsuarios.PageIndex = e.NewPageIndex;
            CargarUsuarios();
        }

        protected void btnGuardarUsuario_Click(object sender, EventArgs e)
        {
            string nombre = txtNombreAgregar.Text;
            string usuario = txtNonbreUsuarioAgregar.Text;
            string correo = txtCorreoAgregar.Text;


            int rol = int.Parse(ddlRolUsuarioAgregar.SelectedValue);
            int? idmedico = null;


            string pass = txtPassword.Text;
            string confirmarpass = txtConfirmarPassword.Text;



            if (string.IsNullOrWhiteSpace(nombre))
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "El nombre es obligatorio, intentelo de nuevo.";


                return;
            }


            if (string.IsNullOrWhiteSpace(usuario))
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "El usuario es obligatorio, intentelo de nuevo.";


                return;
            }

            if (string.IsNullOrWhiteSpace(correo))
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "El correo es obligatorio, intentelo de nuevo.";


                return;
            }


            if (string.IsNullOrWhiteSpace(pass))
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "la contraseña es obligatoria, intentelo de nuevo.";


                return;
            }

            if (string.IsNullOrWhiteSpace(confirmarpass))
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "debe ingresar dos veces la contraseña, intentelo de nuevo.";


                return;
            }






            try
            {
                MailAddress confirmarCorreo = new MailAddress(correo);
            }
            catch (FormatException ex)
            {

                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "Correo no valido, intentelo de nuevo.";

                return;
            }







            if (pass != confirmarpass)
            {
                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "Las contraseñas no coinciden, intentelo de nuevo.";


                return;
            }

            if (!Enum.IsDefined(typeof(TipoUsuario), rol))
            {
                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                pnlMensajeUsuario.Style["color"] = "#842029";

                lblmensajefinal.Text = "El rol seleccionado no es válido.";
                return;
            }

            if (rol == 3)
            {

                if (ddlMedicosAasociar.Items.Count == 0)
                {
                    pnlMensajeUsuario.Visible = true;
                    pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                    pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                    pnlMensajeUsuario.Style["color"] = "#842029";

                    lblmensajefinal.Text = "No hay medicos para seleccionado válido.";
                    return;
                }
                idmedico = int.Parse(ddlMedicosAasociar.SelectedValue);
            }









            try
            {
                Usuario nuevo = new Usuario();

                nuevo.Nombre = nombre;
                nuevo.Email = correo;
                nuevo.Pass = pass;
                nuevo.TipoUsuario = (TipoUsuario)rol;
                nuevo.NombreUsuario = usuario;

                UsuarioNegocio negocio = new UsuarioNegocio();

                negocio.RegistrarUsuario(nuevo, idmedico);

                txtNombreAgregar.Text = "";
                txtNonbreUsuarioAgregar.Text = "";
                txtCorreoAgregar.Text = "";
                txtPassword.Text = "";
                txtConfirmarPassword.Text = "";
                txtCorreoAgregar.ReadOnly = false;
                ddlRolUsuarioAgregar.SelectedValue = "1";
                condicionalMedicoDDL.Visible = false;
                ddlMedicosAasociar.Items.Clear();



                CargarUsuarios();
                updUsuarios.Update();


                pnlMensajeUsuario.Visible = true;
                pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                pnlMensajeUsuario.Style["background-color"] = "#d1f2d9";
                pnlMensajeUsuario.Style["color"] = "#005320";

                lblmensajefinal.Text = "Usuario creado correctamente.";
            }
            catch (SqlException ex)
            {

                if (ex.Number == 50001)
                {
                    pnlMensajeUsuario.Visible = true;
                    pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                    pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                    pnlMensajeUsuario.Style["color"] = "#842029";

                    lblmensajefinal.Text = ex.Message;

                }
                else if (ex.Number == 50002)
                {
                    pnlMensajeUsuario.Visible = true;
                    pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                    pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                    pnlMensajeUsuario.Style["color"] = "#842029";

                    lblmensajefinal.Text = ex.Message;

                }
                else
                {
                    pnlMensajeUsuario.Visible = true;
                    pnlMensajeUsuario.CssClass = "d-flex align-items-center gap-2 p-2 rounded-2 mt-2";
                    pnlMensajeUsuario.Style["background-color"] = "#f8d7da";
                    pnlMensajeUsuario.Style["color"] = "#842029";

                    lblmensajefinal.Text = "Error inesperado";

                }

            }










        }

        protected void ddlRolUsuarioAgregar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlRolUsuarioAgregar.SelectedValue == "3")
            {
                CargarMedicosSinUsuarios();
                condicionalMedicoDDL.Visible = true;

                if (ddlMedicosAasociar.Items.Count > 0)
                { CargarEmailMedico(); }
            }
            else
            {
                condicionalMedicoDDL.Visible = false;
                txtCorreoAgregar.Text = "";
                txtCorreoAgregar.ReadOnly = false;

            }


        }

        protected void ddlMedicosAasociar_SelectedIndexChanged(object sender, EventArgs e)
        {

            CargarEmailMedico();
        }

        protected void ddlfiltrobuscarrol_SelectedIndexChanged(object sender, EventArgs e)
        {


            AplicarFiltrosdgv();
        }

        protected void ddlFiltroActividad_SelectedIndexChanged(object sender, EventArgs e)
        {

            AplicarFiltrosdgv();
        }

        protected void BotonRestablecerFiltro_Click(object sender, EventArgs e)
        {
            txtBuscarUsuario.Text = "";
            ddlfiltrobuscarrol.SelectedValue = "";
            ddlFiltroActividad.SelectedValue = "";

            AplicarFiltrosdgv();
        }

        protected void txtBuscarUsuario_TextChanged(object sender, EventArgs e)
        {
            AplicarFiltrosdgv();
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            GridViewRow fila = (GridViewRow)boton.NamingContainer;

            int id = (int)dgvUsuarios.DataKeys[fila.RowIndex].Value;

            Response.Redirect("FormularioModificarUsuario.aspx?id=" + id + "&modo=datos");

        }

        protected void btnRestablecer_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            GridViewRow fila = (GridViewRow)boton.NamingContainer;

            int id = (int)dgvUsuarios.DataKeys[fila.RowIndex].Value;

            Response.Redirect("FormularioModificarUsuario.aspx?id=" + id + "&modo=password");
        }
    }
}