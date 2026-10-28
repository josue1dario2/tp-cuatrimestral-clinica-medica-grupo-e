// Cambia el texto e ícono del desplegable "Turnos ya atendidos hoy".
document.addEventListener('DOMContentLoaded', function () {
    var collapseEl = document.getElementById('collapseAtendidos');
    var lblToggle = document.getElementById('lblToggleAtendidosTexto');
    var iconToggle = document.getElementById('iconToggleAtendidos');

    if (!collapseEl) return;

    collapseEl.addEventListener('show.bs.collapse', function () {
        if (lblToggle) lblToggle.textContent = 'Ocultar';
        if (iconToggle) iconToggle.classList.replace('bi-chevron-down', 'bi-chevron-up');
    });

    collapseEl.addEventListener('hide.bs.collapse', function () {
        if (lblToggle) lblToggle.textContent = 'Ver detalle';
        if (iconToggle) iconToggle.classList.replace('bi-chevron-up', 'bi-chevron-down');
    });
});
