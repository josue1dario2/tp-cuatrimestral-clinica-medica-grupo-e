// Abre un modal de Bootstrap por su id (por ejemplo "modalDetalle").
// Desde el code-behind se llama así (ver Turnos.aspx.cs):
//   ClientScript.RegisterStartupScript(GetType(), "abrirModal",
//       "document.addEventListener('DOMContentLoaded', function () { abrirModal('modalDetalle'); });", true);
function abrirModal(idModal) {
    var modalEl = document.getElementById(idModal);
    if (modalEl && window.bootstrap) {
        bootstrap.Modal.getOrCreateInstance(modalEl).show();
    }
}
