// Abre el modal "Iniciar Atención Médica".
// Desde el code-behind se llama así (ver MisTurnos.aspx.cs):
//   ClientScript.RegisterStartupScript(GetType(), "modalAtencion",
//       "document.addEventListener('DOMContentLoaded', abrirModalAtencion);", true);
function abrirModalAtencion() {
    var modalEl = document.getElementById('modalAtencion');
    if (modalEl && window.bootstrap) {
        bootstrap.Modal.getOrCreateInstance(modalEl).show();
    }
}
