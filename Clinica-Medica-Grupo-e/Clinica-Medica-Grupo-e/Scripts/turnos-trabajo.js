// Formulario de la derecha de TurnosTrabajo.aspx (alta / edición).

// "Nuevo turno de trabajo": muestra el formulario vacío, listo para un alta.
function nuevoTurnoTrabajo() {
    var form = document.getElementById('formTurnoTrabajo');
    if (!form) return;
    document.getElementById('hfIdTurnoTrabajo').value = '';
    document.getElementById('txtNombre').value = '';
    document.getElementById('lblFormTitulo').innerText = 'Nuevo turno de trabajo';
    form.classList.remove('d-none');
    form.scrollIntoView({ behavior: 'smooth', block: 'start' });
    document.getElementById('txtNombre').focus();
}

// La X y "Cancelar": esconden el formulario (sin PostBack).
function ocultarFormulario() {
    var form = document.getElementById('formTurnoTrabajo');
    if (form) form.classList.add('d-none');
}
