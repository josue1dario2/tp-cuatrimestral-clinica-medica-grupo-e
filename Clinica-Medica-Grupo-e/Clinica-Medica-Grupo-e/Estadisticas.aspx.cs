using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class Estadisticas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO (etapa de lógica): calcular los indicadores con los turnos del período elegido.
                // Mientras tanto, los Repeater se llenan con los datos de ejemplo del diseño.
                CargarEstadosDeEjemplo();
                CargarDemandaDeEjemplo();
                CargarActividadMedicosDeEjemplo();
                CargarRendimientoDeEjemplo();
            }
        }


        // EVENTOS (sin lógica todavía)


        protected void btnExportarPdf_Click(object sender, EventArgs e)
        {
            // TODO: exportar el informe a PDF.
        }

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            // TODO: descargar los datos en CSV.
        }

        protected void btnAplicarFiltros_Click(object sender, EventArgs e)
        {
            // TODO: recalcular todo con ddlPeriodo, ddlSede y ddlEspecialidad.
        }

        protected void btnRestablecer_Click(object sender, EventArgs e)
        {
            // TODO: volver los filtros a sus valores por defecto y recalcular.
        }

        protected void lnkVerRanking_Click(object sender, EventArgs e)
        {
            // TODO: mostrar todas las especialidades (no solo las primeras).
        }

        protected void btnExportarTabla_Click(object sender, EventArgs e)
        {
            // TODO: exportar la matriz de rendimiento a Excel.
        }

        protected void rptRendimiento_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // TODO: "VerDesglose" -> mostrar el detalle de la especialidad e.CommandArgument (IdEspecialidad).
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            // TODO: paginación.
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            // TODO: paginación.
        }


        // TEMPORAL: DATOS DE EJEMPLO DEL DISEÑO
        // Se borran cuando se agregue la lógica. Los nombres de los campos son los que usa el .aspx en cada Eval.


        // Donut y leyenda "Distribución por Estado" (la misma lista para los dos Repeater).
        private void CargarEstadosDeEjemplo()
        {
            var estados = new[]
            {
                new { Nombre = "Cerrados (Atendidos)", Color = "#16a34a", Cantidad = "1.165", Porcentaje = "81.6%", Dasharray = "307.6 376.99", Dashoffset = "0" },
                new { Nombre = "Cancelados", Color = "#dc2626", Cantidad = "103", Porcentaje = "7.2%", Dasharray = "27.1 376.99", Dashoffset = "-307.6" },
                new { Nombre = "No Asistió (Ausente)", Color = "#6b7280", Cantidad = "83", Porcentaje = "5.8%", Dasharray = "21.8 376.99", Dashoffset = "-334.7" },
                new { Nombre = "Nuevos / Confirmados", Color = "#2563eb", Cantidad = "52", Porcentaje = "3.6%", Dasharray = "13.6 376.99", Dashoffset = "-356.5" },
                new { Nombre = "Reprogramados", Color = "#d97706", Cantidad = "25", Porcentaje = "1.8%", Dasharray = "6.8 376.99", Dashoffset = "-370.1" }
            };

            rptDonut.DataSource = estados;
            rptDonut.DataBind();
            rptEstados.DataSource = estados;
            rptEstados.DataBind();
        }

        // Barras horizontales "Demanda por Especialidad".
        private void CargarDemandaDeEjemplo()
        {
            rptDemanda.DataSource = new[]
            {
                new { Especialidad = "Cardiología Clínica", Promedio = "(Prom. 22 min)", Porcentaje = "26.9%", Cantidad = 384, Ancho = "100%" },
                new { Especialidad = "Dermatología Médica", Promedio = "(Prom. 18 min)", Porcentaje = "20.7%", Cantidad = 295, Ancho = "76.8%" },
                new { Especialidad = "Traumatología y Ortopedia", Promedio = "(Prom. 25 min)", Porcentaje = "16.8%", Cantidad = 240, Ancho = "62.5%" },
                new { Especialidad = "Pediatría Integral", Promedio = "(Prom. 20 min)", Porcentaje = "15.1%", Cantidad = 215, Ancho = "55.9%" },
                new { Especialidad = "Neurología", Promedio = "(Prom. 30 min)", Porcentaje = "11.5%", Cantidad = 164, Ancho = "42.7%" },
                new { Especialidad = "Oftalmología", Promedio = "(Prom. 15 min)", Porcentaje = "9.0%", Cantidad = 130, Ancho = "33.8%" }
            };
            rptDemanda.DataBind();
        }

        // Columnas "Actividad por Profesional Médico".
        private void CargarActividadMedicosDeEjemplo()
        {
            rptActividadMedicos.DataSource = new[]
            {
                new { Cantidad = 192, Alto = "100%", Iniciales = "MS", NombreCorto = "Dr. M. Soria", NombreCompleto = "Dr. Martín Soria", Especialidad = "Cardiología" },
                new { Cantidad = 178, Alto = "92.7%", Iniciales = "FH", NombreCorto = "Dra. F. Herrera", NombreCompleto = "Dra. Florencia Herrera", Especialidad = "Dermatología" },
                new { Cantidad = 154, Alto = "80.2%", Iniciales = "AG", NombreCorto = "Dr. A. Gómez R.", NombreCompleto = "Dr. Alejandro Gómez Rossi", Especialidad = "Dermatología" },
                new { Cantidad = 146, Alto = "76%", Iniciales = "MV", NombreCorto = "Dra. M. Valenzuela", NombreCompleto = "Dra. Mariana Valenzuela", Especialidad = "Traumatología" },
                new { Cantidad = 132, Alto = "68.7%", Iniciales = "IQ", NombreCorto = "Dr. I. Quintana", NombreCompleto = "Dr. Ignacio Quintana", Especialidad = "Pediatría" },
                new { Cantidad = 110, Alto = "57.3%", Iniciales = "LB", NombreCorto = "Dra. L. Bustamante", NombreCompleto = "Dra. Lucía Bustamante", Especialidad = "Neurología" }
            };
            rptActividadMedicos.DataBind();
        }

        // Filas de la "Matriz Detallada de Rendimiento por Servicio" (los totales del pie quedan en los Label del .aspx).
        private void CargarRendimientoDeEjemplo()
        {
            rptRendimiento.DataSource = new[]
            {
                new { IdEspecialidad = 1, Especialidad = "Cardiología Clínica", Detalle = "Consultorio 101, 102 & ECG", Icono = "favorite", IconoCss = "icon-box-red", Medicos = 4, Total = 384, Atendidos = 321, Cancelados = 24, Inasistencias = 21, Cumplimiento = "83.6%" },
                new { IdEspecialidad = 2, Especialidad = "Dermatología Médica", Detalle = "Consultorio 204 & Procedimientos", Icono = "dermatology", IconoCss = "icon-box-teal", Medicos = 3, Total = 295, Atendidos = 244, Cancelados = 20, Inasistencias = 16, Cumplimiento = "82.7%" },
                new { IdEspecialidad = 3, Especialidad = "Traumatología y Ortopedia", Detalle = "Consultorio 108 & Sala Yesos", Icono = "accessibility_new", IconoCss = "es-icono-gris", Medicos = 3, Total = 240, Atendidos = 195, Cancelados = 19, Inasistencias = 14, Cumplimiento = "81.3%" },
                new { IdEspecialidad = 4, Especialidad = "Pediatría Integral", Detalle = "Sector Niños - Consultorios P1 y P2", Icono = "child_care", IconoCss = "icon-box-blue", Medicos = 2, Total = 215, Atendidos = 173, Cancelados = 17, Inasistencias = 13, Cumplimiento = "80.5%" },
                new { IdEspecialidad = 5, Especialidad = "Neurología", Detalle = "Consultorio 301", Icono = "psychology", IconoCss = "icon-box-teal", Medicos = 2, Total = 164, Atendidos = 130, Cancelados = 13, Inasistencias = 11, Cumplimiento = "79.3%" },
                new { IdEspecialidad = 6, Especialidad = "Oftalmología", Detalle = "Consultorio 105 & Lámpara de Hendidura", Icono = "visibility", IconoCss = "es-icono-gris", Medicos = 2, Total = 130, Atendidos = 102, Cancelados = 10, Inasistencias = 8, Cumplimiento = "78.5%" }
            };
            rptRendimiento.DataBind();
        }
    }
}
