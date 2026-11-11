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
    public partial class FormularioModificarUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = int.Parse(Request.QueryString["id"]);
            
            string modo = Request.QueryString["modo"];

            if(modo=="datos")
            {
                divContraseñas.Visible=false;



            }
            else if (modo=="password")
            {
                    divMail.Visible = false;
                    divNombreUsuario.Visible = false;
            }

            if (!IsPostBack)
            {

                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario usuario = negocio.StoredBuscarPorID(id);

                if (usuario == null)
                {
                    Response.Redirect("GestionUsuariosAdmin.aspx");
                        return;
                }
                else
                {
                    txtNombreUsuario.Text = usuario.NombreUsuario;
                    txtEmail.Text = usuario.Email;
                 
                }
               


            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            int id = int.Parse(Request.QueryString["id"]);
            string modo = Request.QueryString["modo"];

            UsuarioNegocio negocio = new UsuarioNegocio();

            Usuario modificado = negocio.StoredBuscarPorID(id);

            if (modificado == null)
            {
                Response.Redirect("GestionUsuariosAdmin.aspx");
                return;
            }

            if (!chkConfirmarCambios.Checked)
            {
                lblErrorValidacion.Text = "Debes confirmar que deseas guardar los cambios";
                lblErrorValidacion.Visible = true;
                return;
            }

            if (modo == "datos")
            {
                if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) ||
                    string.IsNullOrWhiteSpace(txtEmail.Text))
                {
                    lblErrorValidacion.Text = "El nombre de usuario y el correo electrónico son obligatorios.";
                    lblErrorValidacion.Visible = true;
                    return;
                }

                modificado.NombreUsuario = txtNombreUsuario.Text.Trim();
                modificado.Email = txtEmail.Text.Trim();
            }
            else if (modo == "password")
            {


                if (string.IsNullOrWhiteSpace(txtContraseña.Text) ||
                     string.IsNullOrWhiteSpace(txtConfirmarContraseña.Text))
                {
                    lblErrorValidacion.Text = "Debés completar ambos campos de contraseña.";
                    lblErrorValidacion.Visible = true;
                    return;
                }



                if (txtContraseña.Text != txtConfirmarContraseña.Text)
                {
                    lblErrorValidacion.Text = "Las contraseñas no coinciden.";
                    lblErrorValidacion.Visible = true;
                    return;
                }

                modificado.Pass = txtContraseña.Text;
            }

            negocio.ModificarUsuario(modificado);

            Response.Redirect("GestionUsuariosAdmin.aspx");
        }
    }
}