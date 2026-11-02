using System;
using System.Web.UI;

namespace Clinica_Medica_Grupo_e
{
    public partial class TurnoConfirmado : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO (etapa de lógica): leer el turno con Request.QueryString["id"] y cargar los Label.
                //       Si el paciente no tiene email: pnlEmailEnviado.Visible = false; pnlSinEmail.Visible = true;
            }
        }

        protected void btnEnviarWhatsApp_Click(object sender, EventArgs e)
        {
            // TODO: enviar el comprobante por WhatsApp.
        }

        protected void btnDescargarPdf_Click(object sender, EventArgs e)
        {
            // TODO: generar y descargar el comprobante en PDF.
        }

        protected void btnGuardarEmail_Click(object sender, EventArgs e)
        {
            // TODO: validar txtEmailModal.Text, guardarlo en el paciente
            //       y reenviar el comprobante si chkReenviarComprobante.Checked.
        }
    }
}
