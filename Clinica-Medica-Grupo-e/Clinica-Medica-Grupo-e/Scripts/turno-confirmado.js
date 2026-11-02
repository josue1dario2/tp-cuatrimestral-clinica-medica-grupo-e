// Copiar el código del turno y mostrar el aviso flotante (toast).
// lblCodigoTurno tiene ClientIDMode="Static", por eso su id en el HTML es "lblCodigoTurno".

function copyTurnCode() {
    var code = document.getElementById('lblCodigoTurno').innerText.trim();
    navigator.clipboard.writeText(code).then(function () {
        var feedback = document.getElementById('copyFeedback');
        feedback.innerText = '¡Copiado!';
        triggerNotification('Código ' + code + ' copiado al portapapeles.');
        setTimeout(function () {
            feedback.innerText = 'Copiar';
        }, 2000);
    }).catch(function () {
        triggerNotification('Código ' + code + ' seleccionado.');
    });
}

function triggerNotification(msg) {
    var toast = document.getElementById('toastNotification');
    var toastMsg = document.getElementById('toastMessage');
    toastMsg.innerText = msg;
    toast.classList.add('show');

    setTimeout(function () {
        toast.classList.remove('show');
    }, 3000);
}
