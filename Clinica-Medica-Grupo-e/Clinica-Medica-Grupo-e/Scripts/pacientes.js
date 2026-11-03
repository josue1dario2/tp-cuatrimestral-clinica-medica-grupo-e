// Panel lateral "Nuevo / Editar paciente" de Pacientes.aspx.
// Desde el code-behind se puede abrir con:
//   ScriptManager.RegisterStartupScript(this, GetType(), "abrirDrawer", "abrirDrawerPaciente();", true);

function abrirDrawerPaciente() {
    var drawer = document.getElementById('drawerPaciente');
    var backdrop = document.getElementById('drawerBackdrop');
    if (!drawer || !backdrop) return;
    backdrop.classList.add('abierto');
    setTimeout(function () {
        drawer.classList.add('abierto');
    }, 10);
}

function cerrarDrawerPaciente() {
    var drawer = document.getElementById('drawerPaciente');
    var backdrop = document.getElementById('drawerBackdrop');
    if (!drawer || !backdrop) return;
    drawer.classList.remove('abierto');
    setTimeout(function () {
        backdrop.classList.remove('abierto');
    }, 300);
}
