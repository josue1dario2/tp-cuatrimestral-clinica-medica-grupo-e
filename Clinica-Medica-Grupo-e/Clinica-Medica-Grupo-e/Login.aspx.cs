using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
          
            UsuarioNegocio negocio = new UsuarioNegocio();
            Usuario usuario = negocio.Login(txtUsuario.Text, txtContrasena.Text);
            try
            {

                if (usuario != null)
                {
                    usuario.Pass = null;

                    Session["Usuario"] = usuario;


                    switch (usuario.TipoUsuario)
                    {

                        case TipoUsuario.Admin:
                            Response.Redirect("InicioAdmin.aspx");
                            break;



                        case TipoUsuario.Recepcionista:
                            Response.Redirect("InicioAdmin.aspx");
                            break;

                        case TipoUsuario.Medico:
                            Response.Redirect("InicioMedico.aspx");
                            break;





                    }



                }
                else 
                {

                    pnlError.Visible = true;
                    lblError.Text = "Usuario o contraseña incorrectos.";

                }




            }
            catch (Exception)
            {

                throw;
            }

        }
    }
}