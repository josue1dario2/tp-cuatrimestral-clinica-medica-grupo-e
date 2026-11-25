// Estadisticas.aspx: muestra los campos Desde / Hasta solo con la opción "Rango personalizado".
document.addEventListener('DOMContentLoaded', function () {
    var ddlPeriodo = document.getElementById('ddlPeriodo');
    var pnlRango = document.getElementById('pnlRangoPersonalizado');
    if (!ddlPeriodo || !pnlRango) return;

    ddlPeriodo.addEventListener('change', function () {
        pnlRango.classList.toggle('d-none', ddlPeriodo.value !== 'personalizado');
    });
});
