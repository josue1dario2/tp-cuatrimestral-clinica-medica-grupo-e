// Contador de caracteres del motivo de la reprogramación.
// Funciona porque el TextBox tiene ClientIDMode="Static": su id en el HTML es "txtMotivoReprogramacion".
(function () {
    var textarea = document.getElementById('txtMotivoReprogramacion');
    var counter = document.getElementById('char-counter');

    if (textarea && counter) {
        var actualizar = function () {
            var length = textarea.value.length;
            counter.textContent = length + ' / 500 caracteres';
            if (length > 450) {
                counter.classList.add('text-danger');
                counter.classList.remove('text-muted');
            } else {
                counter.classList.remove('text-danger');
                counter.classList.add('text-muted');
            }
        };

        textarea.addEventListener('input', actualizar);
        actualizar(); // después de un PostBack el TextBox puede volver con texto
    }
})();
