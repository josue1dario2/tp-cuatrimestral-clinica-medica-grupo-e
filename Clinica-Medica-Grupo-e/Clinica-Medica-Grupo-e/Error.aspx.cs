using System;
using System.Web.UI;

namespace Clinica_Medica_Grupo_e
{
    public partial class Error : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["error"] != null)
            {
                lblError.Text = Session["error"].ToString();
            }
        }
    }
}

