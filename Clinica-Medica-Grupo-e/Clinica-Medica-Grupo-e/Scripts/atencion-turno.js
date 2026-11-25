// AtencionTurno.aspx: contador de caracteres, frases rápidas, tarjetas de resolución
// y modal de confirmación. Si la página está en modo solo lectura, no hay formulario y no hace nada.
document.addEventListener('DOMContentLoaded', function () {
    var formulario = document.getElementById('pnlFormularioAtencion');
    if (!formulario) return;

    var paciente = formulario.getAttribute('data-paciente') || 'el paciente';
    var numeroTurno = formulario.getAttribute('data-numero') || '';

    var txtEvolucion = document.getElementById('txtEvolucionClinica');
    var lblContador = document.getElementById('lblContadorCaracteres');
    var lblErrorEvolucion = document.getElementById('lblErrorEvolucionCliente');
    var spanObligatoria = document.getElementById('spanEvolucionObligatoria');

    var rdoCerrado = document.getElementById('rdoCerrado');
    var rdoNoAsistio = document.getElementById('rdoNoAsistio');
    var pnlCerrado = document.getElementById('pnlOpcionCerrado');
    var pnlNoAsistio = document.getElementById('pnlOpcionNoAsistio');
    var lblMensaje = document.getElementById('lblMensajeEstadoResolucion');

    var btnGuardarFinal = document.getElementById('btnGuardarFinal');
    var modalEl = document.getElementById('modalConfirmacionCierre');
    var lblModalTitulo = document.getElementById('lblModalTitulo');
    var lblModalTexto = document.getElementById('lblModalTexto');

    // Los textos se arman con textContent (y no con innerHTML) porque el nombre del paciente lo cargó un usuario.
    function ponerTexto(elemento, antes, resaltado, despues) {
        elemento.textContent = '';
        elemento.appendChild(document.createTextNode(antes));
        var strong = document.createElement('strong');
        strong.textContent = resaltado;
        elemento.appendChild(strong);
        elemento.appendChild(document.createTextNode(despues));
    }

    // 1. Contador de caracteres
    function actualizarContador() {
        if (txtEvolucion && lblContador) lblContador.textContent = txtEvolucion.value.length;
    }

    if (txtEvolucion) {
        txtEvolucion.addEventListener('input', function () {
            actualizarContador();
            if (lblErrorEvolucion && txtEvolucion.value.trim() !== '') lblErrorEvolucion.classList.add('d-none');
        });
    }
    actualizarContador();

    // 2. Frases rápidas: se insertan donde está el cursor
    document.querySelectorAll('[data-snippet]').forEach(function (boton) {
        boton.addEventListener('click', function () {
            var texto = this.getAttribute('data-snippet');
            if (!txtEvolucion || !texto) return;

            var inicio = txtEvolucion.selectionStart;
            var fin = txtEvolucion.selectionEnd;
            txtEvolucion.value = txtEvolucion.value.substring(0, inicio) + texto + txtEvolucion.value.substring(fin);
            txtEvolucion.focus();
            txtEvolucion.selectionStart = txtEvolucion.selectionEnd = inicio + texto.length;
            actualizarContador();
            if (lblErrorEvolucion) lblErrorEvolucion.classList.add('d-none');
        });
    });

    // 3. Tarjetas de resolución (Cerrado / No asistió)
    function esCerrado() {
        return !rdoNoAsistio || !rdoNoAsistio.checked;
    }

    function actualizarResolucion() {
        var cerrado = esCerrado();

        if (pnlCerrado) pnlCerrado.classList.toggle('activo-cerrado', cerrado);
        if (pnlNoAsistio) pnlNoAsistio.classList.toggle('activo-noasistio', !cerrado);
        if (spanObligatoria) spanObligatoria.classList.toggle('d-none', !cerrado);
        if (!cerrado && lblErrorEvolucion) lblErrorEvolucion.classList.add('d-none');

        if (lblMensaje) {
            var icono = document.createElement('i');
            var texto = document.createElement('span');
            if (cerrado) {
                icono.className = 'bi bi-check-circle-fill text-success fs-6';
                ponerTexto(texto, 'Al marcar como ', '"Cerrado"', ', el turno finaliza y la consulta queda registrada en la ficha de ' + paciente + '.');
            } else {
                icono.className = 'bi bi-person-x-fill text-secondary fs-6';
                ponerTexto(texto, 'Al marcar como ', '"No asistió"', ', el turno se registra como inasistencia y no se guarda evolución clínica.');
            }
            lblMensaje.textContent = '';
            lblMensaje.appendChild(icono);
            lblMensaje.appendChild(texto);
        }
    }

    if (rdoCerrado) rdoCerrado.addEventListener('change', actualizarResolucion);
    if (rdoNoAsistio) rdoNoAsistio.addEventListener('change', actualizarResolucion);
    // Toda la tarjeta elige la opción, no solo el círculo.
    if (pnlCerrado && rdoCerrado) pnlCerrado.addEventListener('click', function () { rdoCerrado.checked = true; actualizarResolucion(); });
    if (pnlNoAsistio && rdoNoAsistio) pnlNoAsistio.addEventListener('click', function () { rdoNoAsistio.checked = true; actualizarResolucion(); });
    // Después de un PostBack con error, la opción elegida vuelve marcada: se sincroniza el estilo.
    actualizarResolucion();

    // 4. Enter en un campo de texto de una línea no debe enviar el formulario
    //    (el primer botón de envío es "Confirmar y guardar" del modal).
    formulario.querySelectorAll('input[type="text"]').forEach(function (campo) {
        campo.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') e.preventDefault();
        });
    });

    // 5. Botón "Guardar atención y finalizar turno": valida y abre el modal de confirmación
    if (btnGuardarFinal && modalEl && window.bootstrap) {
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);

        btnGuardarFinal.addEventListener('click', function () {
            var cerrado = esCerrado();

            if (cerrado && txtEvolucion && txtEvolucion.value.trim() === '') {
                if (lblErrorEvolucion) lblErrorEvolucion.classList.remove('d-none');
                txtEvolucion.focus();
                return;
            }

            if (lblModalTitulo) {
                lblModalTitulo.textContent = cerrado ? '¿Confirmar cierre de la consulta?' : '¿Confirmar inasistencia?';
            }
            if (lblModalTexto) {
                var detalle = cerrado
                    ? '. La evolución se incorporará a la ficha del paciente y no se podrá modificar.'
                    : '. El turno no se podrá atender después.';
                ponerTexto(lblModalTexto, 'El turno #' + numeroTurno + ' de ' + paciente + ' será registrado como ',
                    cerrado ? 'Cerrado' : 'No asistió', detalle);
            }

            modal.show();
        });
    }
});
