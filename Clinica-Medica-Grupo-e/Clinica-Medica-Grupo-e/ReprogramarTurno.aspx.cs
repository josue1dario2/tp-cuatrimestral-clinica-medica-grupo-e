using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class ReprogramarTurno : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // TODO (etapa de lógica): leer el turno con Request.QueryString["id"],
                //       cargar los Label de la columna izquierda, ddlMedico, el calendario y los horarios.

                // TEMPORAL: datos de ejemplo para ver el calendario y los horarios con el diseño.
                // Borrar estas dos líneas (y los dos métodos de abajo) cuando se conecte la base.
                CargarCalendarioDeEjemplo();
                CargarHorariosDeEjemplo();
            }
        }

        // =====================================================================
        // TEMPORAL: datos de ejemplo (solo para ver el diseño)
        // =====================================================================

        private void CargarCalendarioDeEjemplo()
        {
            CultureInfo cultura = new CultureInfo("es-AR");
            DateTime hoy = DateTime.Today;
            DateTime turnoActual = hoy.AddDays(2);    // día "a liberar" (rojo)
            DateTime seleccionado = hoy.AddDays(5);   // día elegido (verde azulado)

            // Se muestra el mes del día elegido (si hoy es fin de mes, es el mes siguiente).
            DateTime primeroDelMes = new DateTime(seleccionado.Year, seleccionado.Month, 1);

            // La grilla empieza el lunes de la semana del día 1 y termina el domingo de la última semana.
            int diasHastaLunes = ((int)primeroDelMes.DayOfWeek + 6) % 7;
            DateTime inicio = primeroDelMes.AddDays(-diasHastaLunes);
            DateTime ultimoDelMes = primeroDelMes.AddMonths(1).AddDays(-1);
            int diasHastaDomingo = (7 - (int)ultimoDelMes.DayOfWeek) % 7;
            DateTime fin = ultimoDelMes.AddDays(diasHastaDomingo);

            var dias = new List<object>();
            for (DateTime dia = inicio; dia <= fin; dia = dia.AddDays(1))
            {
                string css = "cell-disabled";
                string punto = "d-none";
                bool habilitado = false;
                string titulo = "";

                bool esDelMes = dia.Month == primeroDelMes.Month;
                bool esFinDeSemana = dia.DayOfWeek == DayOfWeek.Saturday || dia.DayOfWeek == DayOfWeek.Sunday;

                if (dia == seleccionado)
                {
                    css = "cell-selected"; punto = "dot-seleccionado"; habilitado = true; titulo = "Día seleccionado";
                }
                else if (dia == turnoActual)
                {
                    css = "cell-current-release"; punto = "dot-actual"; habilitado = true; titulo = "Turno actual agendado";
                }
                else if (dia == hoy)
                {
                    css = "cell-today"; punto = "dot-hoy"; habilitado = true; titulo = "Hoy";
                }
                else if (esDelMes && dia > hoy && !esFinDeSemana)
                {
                    css = "cell-active-available"; punto = "dot-libre"; habilitado = true; titulo = "Con turnos disponibles";
                }

                dias.Add(new
                {
                    Fecha = dia.ToString("yyyy-MM-dd"),
                    Numero = dia.Day,
                    Titulo = titulo,
                    Habilitado = habilitado,
                    Css = css,
                    PuntoCss = punto
                });
            }

            rptDias.DataSource = dias;
            rptDias.DataBind();

            string mes = primeroDelMes.ToString("MMMM yyyy", cultura);
            lblMesCalendario.Text = char.ToUpper(mes[0]) + mes.Substring(1);
        }

        private void CargarHorariosDeEjemplo()
        {
            var horarios = new List<object>();
            for (int hora = 8; hora < 14; hora++)
            {
                bool ocupado = hora == 10 || hora == 12;
                bool elegido = hora == 11;

                horarios.Add(new
                {
                    Hora = hora,
                    Texto = hora.ToString("00") + ":00 hs",
                    Titulo = ocupado ? "Cupo ocupado" : "",
                    Disponible = !ocupado,
                    Css = elegido ? "slot-selected" : (ocupado ? "time-slot-locked" : "shadow-sm"),
                    IndicadorCss = elegido || ocupado ? "material-symbols-outlined slot-icon" : "slot-dot",
                    IndicadorTexto = elegido ? "check" : (ocupado ? "lock" : "")
                });
            }

            rptHorarios.DataSource = horarios;
            rptHorarios.DataBind();
        }

        // =====================================================================
        // Eventos (vacíos: se completan en la etapa de lógica)
        // =====================================================================

        protected void ddlMedico_SelectedIndexChanged(object sender, EventArgs e)
        {
            // TODO: recargar el calendario y los horarios del médico elegido.
        }

        protected void btnMesAnterior_Click(object sender, EventArgs e)
        {
            // TODO: mostrar el mes anterior.
        }

        protected void btnMesHoy_Click(object sender, EventArgs e)
        {
            // TODO: volver al mes actual.
        }

        protected void btnMesSiguiente_Click(object sender, EventArgs e)
        {
            // TODO: mostrar el mes siguiente.
        }

        protected void rptDias_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "SeleccionarDia", e.CommandArgument == fecha "yyyy-MM-dd"
            // TODO: marcar el día elegido y cargar sus horarios.
        }

        protected void rptHorarios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // e.CommandName == "SeleccionarHorario", e.CommandArgument == hora (ej: "11")
            // TODO: marcar el horario elegido y actualizar los resúmenes.
        }

        protected void btnGuardarCambios_Click(object sender, EventArgs e)
        {
            // TODO: validar el motivo, guardar la nueva fecha y hora del turno y volver a Turnos.aspx.
        }
    }
}
