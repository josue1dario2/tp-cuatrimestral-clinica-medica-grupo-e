using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Clinica_Medica_Grupo_e
{
    public partial class Estadisticas : System.Web.UI.Page
    {
        private static readonly CultureInfo Cultura = new CultureInfo("es-AR");
        private static readonly CultureInfo Invariante = CultureInfo.InvariantCulture;

        // Circunferencia del anillo del donut: 2 × π × 60 (radio del <circle> en el .aspx).
        private const double CircunferenciaDonut = 376.99;
        private const int EspecialidadesEnRanking = 6;
        private const int MedicosEnGrafico = 6;
        private const int FilasPorPagina = 10;
        private const int DiasMaximosRango = 366;

        // ESTADO DE LA PÁGINA (Session con prefijo "Estadisticas_", se borra en el primer !IsPostBack).
        // Se guarda el filtro APLICADO: la paginación, el ranking y el desglose recalculan con él,
        // aunque el usuario haya cambiado los desplegables sin tocar "Aplicar filtros".

        private string PeriodoAplicado
        {
            get { return Session["Estadisticas_Periodo"] as string ?? "ultimos30"; }
            set { Session["Estadisticas_Periodo"] = value; }
        }

        private DateTime Desde
        {
            get { return Session["Estadisticas_Desde"] == null ? DateTime.Today.AddDays(-29) : (DateTime)Session["Estadisticas_Desde"]; }
            set { Session["Estadisticas_Desde"] = value; }
        }

        private DateTime Hasta
        {
            get { return Session["Estadisticas_Hasta"] == null ? DateTime.Today : (DateTime)Session["Estadisticas_Hasta"]; }
            set { Session["Estadisticas_Hasta"] = value; }
        }

        private int IdEspecialidad
        {
            get { return Session["Estadisticas_IdEspecialidad"] == null ? 0 : (int)Session["Estadisticas_IdEspecialidad"]; }
            set { Session["Estadisticas_IdEspecialidad"] = value; }
        }

        private int Pagina
        {
            get { return Session["Estadisticas_Pagina"] == null ? 1 : (int)Session["Estadisticas_Pagina"]; }
            set { Session["Estadisticas_Pagina"] = value; }
        }

        // false: "Demanda por Especialidad" muestra las 6 primeras; true: todas.
        private bool RankingCompleto
        {
            get { return Session["Estadisticas_RankingCompleto"] != null && (bool)Session["Estadisticas_RankingCompleto"]; }
            set { Session["Estadisticas_RankingCompleto"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
            {
                Session["MensajeLogin"] = "Debés iniciar sesión para acceder al sistema.";
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Usuario usuario = (Usuario)Session["Usuario"];

            if (usuario.TipoUsuario != TipoUsuario.Admin)
            {
                Response.Redirect("~/InicioAdmin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            pnlMensaje.Visible = false;

            if (!IsPostBack)
            {
                LimpiarEstado();
                MostrarAutor(usuario);

                try
                {
                    CargarFiltros();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("No se pudieron cargar las especialidades: " + Server.HtmlEncode(ex.Message), true);
                }

                Calcular();
            }
        }

        private void LimpiarEstado()
        {
            Session.Remove("Estadisticas_Periodo");
            Session.Remove("Estadisticas_Desde");
            Session.Remove("Estadisticas_Hasta");
            Session.Remove("Estadisticas_IdEspecialidad");
            Session.Remove("Estadisticas_Pagina");
            Session.Remove("Estadisticas_RankingCompleto");
        }

        private void MostrarAutor(Usuario usuario)
        {
            string nombre = ((usuario.Nombre ?? "") + " " + (usuario.Apellido ?? "")).Trim();
            if (nombre == "")
                nombre = usuario.NombreUsuario ?? usuario.Email ?? "";
            lblAutorReporte.Text = Server.HtmlEncode(nombre);
        }

        private void MostrarMensaje(string mensaje, bool esError)
        {
            lblMensaje.Text = mensaje;
            pnlMensaje.CssClass = esError ? "alert alert-danger mb-0" : "alert alert-warning mb-0";
            pnlMensaje.Visible = true;
        }

        // ----- Filtros -----

        private void CargarFiltros()
        {
            // Los textos del período muestran las fechas reales (el diseño traía fechas de ejemplo).
            DateTime hoy = DateTime.Today;
            DateTime desde, hasta;

            foreach (ListItem item in ddlPeriodo.Items)
            {
                if (item.Value == "personalizado")
                {
                    item.Text = "Rango personalizado...";
                    continue;
                }

                RangoDelPeriodo(item.Value, out desde, out hasta);
                switch (item.Value)
                {
                    case "hoy":
                        item.Text = "Hoy (" + hoy.ToString("d 'de' MMMM yyyy", Cultura) + ")";
                        break;
                    case "semana":
                        item.Text = "Esta semana (" + desde.ToString("dd/MM") + " - " + hasta.ToString("dd/MM/yyyy") + ")";
                        break;
                    case "mes":
                        item.Text = "Este mes (" + Capitalizar(desde.ToString("MMMM yyyy", Cultura)) + ")";
                        break;
                    case "mesAnterior":
                        item.Text = "Mes anterior (" + Capitalizar(desde.ToString("MMMM yyyy", Cultura)) + ")";
                        break;
                    default:
                        item.Text = "Últimos 30 días (" + desde.ToString("dd/MM/yyyy") + " - " + hasta.ToString("dd/MM/yyyy") + ")";
                        break;
                }
            }

            ddlPeriodo.SelectedValue = "ultimos30";
            txtDesde.Text = "";
            txtHasta.Text = "";
            MostrarRangoPersonalizado(false);

            List<Especialidad> especialidades = new EspecialidadNegocio().listar()
                .OrderBy(es => es.Descripcion)
                .ToList();

            ddlEspecialidad.Items.Clear();
            ddlEspecialidad.Items.Add(new ListItem("Todas las especialidades (" + especialidades.Count(es => es.Activo) + " activas)", "0"));
            foreach (Especialidad es in especialidades)
                ddlEspecialidad.Items.Add(new ListItem(es.Activo ? es.Descripcion : es.Descripcion + " (inactiva)", es.Id.ToString()));
        }

        // Los campos Desde / Hasta se ven solo con "Rango personalizado" (Scripts/estadisticas.js los muestra al cambiar la opción).
        private void MostrarRangoPersonalizado(bool visible)
        {
            pnlRangoPersonalizado.CssClass = visible ? "col-12 col-md-6 col-lg-3" : "col-12 col-md-6 col-lg-3 d-none";
        }

        // Fechas de cada opción del período (salvo "personalizado").
        private static void RangoDelPeriodo(string periodo, out DateTime desde, out DateTime hasta)
        {
            DateTime hoy = DateTime.Today;
            switch (periodo)
            {
                case "hoy":
                    desde = hoy;
                    hasta = hoy;
                    break;
                case "semana":
                    // Lunes a domingo de la semana actual.
                    int diasDesdeLunes = ((int)hoy.DayOfWeek + 6) % 7;
                    desde = hoy.AddDays(-diasDesdeLunes);
                    hasta = desde.AddDays(6);
                    break;
                case "mes":
                    desde = new DateTime(hoy.Year, hoy.Month, 1);
                    hasta = desde.AddMonths(1).AddDays(-1);
                    break;
                case "mesAnterior":
                    desde = new DateTime(hoy.Year, hoy.Month, 1).AddMonths(-1);
                    hasta = desde.AddMonths(1).AddDays(-1);
                    break;
                default:   // ultimos30
                    desde = hoy.AddDays(-29);
                    hasta = hoy;
                    break;
            }
        }

        // Período anterior para las tendencias: el mes anterior si el período es un mes completo;
        // si no, la misma cantidad de días justo antes.
        private void PeriodoAnterior(out DateTime desde, out DateTime hasta)
        {
            if (PeriodoAplicado == "mes" || PeriodoAplicado == "mesAnterior")
            {
                desde = Desde.AddMonths(-1);
                hasta = Desde.AddDays(-1);
                return;
            }

            int dias = (Hasta - Desde).Days + 1;
            hasta = Desde.AddDays(-1);
            desde = hasta.AddDays(-(dias - 1));
        }

        protected void btnAplicarFiltros_Click(object sender, EventArgs e)
        {
            string periodo = ddlPeriodo.SelectedValue;
            DateTime desde, hasta;

            if (periodo == "personalizado")
            {
                MostrarRangoPersonalizado(true);

                // TextMode="Date" envía la fecha como yyyy-MM-dd.
                if (!DateTime.TryParseExact(txtDesde.Text, "yyyy-MM-dd", Invariante, DateTimeStyles.None, out desde)
                    || !DateTime.TryParseExact(txtHasta.Text, "yyyy-MM-dd", Invariante, DateTimeStyles.None, out hasta))
                {
                    MostrarMensaje("Para el rango personalizado complete las fechas Desde y Hasta.", false);
                    return;
                }

                if (desde > hasta)
                {
                    MostrarMensaje("La fecha Desde no puede ser posterior a la fecha Hasta.", false);
                    return;
                }

                if ((hasta - desde).Days + 1 > DiasMaximosRango)
                {
                    MostrarMensaje("El rango personalizado no puede superar los " + DiasMaximosRango + " días.", false);
                    return;
                }
            }
            else
            {
                MostrarRangoPersonalizado(false);
                RangoDelPeriodo(periodo, out desde, out hasta);
            }

            int idEspecialidad;
            int.TryParse(ddlEspecialidad.SelectedValue, out idEspecialidad);

            PeriodoAplicado = periodo;
            Desde = desde;
            Hasta = hasta;
            IdEspecialidad = idEspecialidad;
            Pagina = 1;
            Calcular();
        }

        protected void btnRestablecer_Click(object sender, EventArgs e)
        {
            LimpiarEstado();
            ddlPeriodo.SelectedValue = "ultimos30";
            ddlEspecialidad.SelectedValue = "0";
            txtDesde.Text = "";
            txtHasta.Text = "";
            MostrarRangoPersonalizado(false);
            Calcular();
        }

        // ----- Cálculo -----

        private void Calcular()
        {
            List<Turno> turnos;
            List<Turno> turnosAnteriores;
            List<Medico> medicos;
            List<Especialidad> especialidades;

            try
            {
                TurnoNegocio turnoNegocio = new TurnoNegocio();
                turnos = turnoNegocio.buscar(new FiltroTurnos { Desde = Desde, Hasta = Hasta, IdEspecialidad = IdEspecialidad });

                DateTime desdeAnterior, hastaAnterior;
                PeriodoAnterior(out desdeAnterior, out hastaAnterior);
                turnosAnteriores = turnoNegocio.buscar(new FiltroTurnos { Desde = desdeAnterior, Hasta = hastaAnterior, IdEspecialidad = IdEspecialidad });

                medicos = new MedicoNegocio().listarConDetalle();
                especialidades = new EspecialidadNegocio().listar();
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudieron leer los turnos desde la base de datos: " + Server.HtmlEncode(ex.Message), true);
                turnos = new List<Turno>();
                turnosAnteriores = new List<Turno>();
                medicos = new List<Medico>();
                especialidades = new List<Especialidad>();
            }

            if (turnos.Count == 0 && !pnlMensaje.Visible)
                MostrarMensaje("No hay turnos registrados en el período y la especialidad elegidos.", false);

            MostrarKpis(turnos, turnosAnteriores);
            MostrarDistribucionEstados(turnos);
            MostrarDemanda(turnos);
            MostrarActividadMedicos(turnos);
            List<FilaRendimiento> filas = ArmarRendimiento(turnos, medicos, especialidades);
            MostrarRendimiento(filas, turnos.Count, ContarMedicos(medicos, filas));
        }

        // ----- 1. Tarjetas KPI -----

        private void MostrarKpis(List<Turno> turnos, List<Turno> anteriores)
        {
            int total = turnos.Count;
            int cancelados = turnos.Count(t => t.Estado == EstadoTurno.Cancelado);
            int ausentes = turnos.Count(t => t.Estado == EstadoTurno.NoAsistio);
            int cerrados = turnos.Count(t => t.Estado == EstadoTurno.Cerrado);

            int totalAnterior = anteriores.Count;
            int canceladosAnterior = anteriores.Count(t => t.Estado == EstadoTurno.Cancelado);
            int ausentesAnterior = anteriores.Count(t => t.Estado == EstadoTurno.NoAsistio);
            int cerradosAnterior = anteriores.Count(t => t.Estado == EstadoTurno.Cerrado);

            // Total de turnos
            lblKpiTotal.Text = total.ToString("N0", Cultura);
            int diasHabiles = DiasHabiles(Desde, Hasta);
            lblKpiTotalPromedio.Text = "Promedio: " + ((double)total / diasHabiles).ToString("0.#", Cultura) + " turnos/día hábil";
            if (totalAnterior == 0)
                MostrarTendencia(tndKpiTotal, lblKpiTotalIcono, lblKpiTotalTendencia, null, "", true);
            else
                MostrarTendencia(tndKpiTotal, lblKpiTotalIcono, lblKpiTotalTendencia,
                    (total - totalAnterior) * 100.0 / totalAnterior, "%", true);

            // Tasas: la tendencia es la diferencia en puntos porcentuales con el período anterior.
            lblKpiCancelacion.Text = Porcentaje(cancelados, total);
            lblKpiCancelados.Text = cancelados.ToString("N0", Cultura) + (cancelados == 1 ? " turno cancelado en total" : " turnos cancelados en total");
            MostrarTendencia(tndKpiCancelacion, lblKpiCancelacionIcono, lblKpiCancelacionTendencia,
                DiferenciaDeTasas(cancelados, total, canceladosAnterior, totalAnterior), " pts", false);

            lblKpiInasistencia.Text = Porcentaje(ausentes, total);
            lblKpiAusentes.Text = ausentes.ToString("N0", Cultura) + (ausentes == 1 ? " paciente ausente sin aviso previo" : " pacientes ausentes sin aviso previo");
            MostrarTendencia(tndKpiInasistencia, lblKpiInasistenciaIcono, lblKpiInasistenciaTendencia,
                DiferenciaDeTasas(ausentes, total, ausentesAnterior, totalAnterior), " pts", false);

            lblKpiCerrados.Text = Porcentaje(cerrados, total);
            lblKpiCerradosCantidad.Text = "(" + cerrados.ToString("N0", Cultura) + ")";
            MostrarTendencia(tndKpiCerrados, lblKpiCerradosIcono, lblKpiCerradosTendencia,
                DiferenciaDeTasas(cerrados, total, cerradosAnterior, totalAnterior), " pts", true);
        }

        // variacion null = no hay con qué comparar. subirEsBueno: si un aumento se pinta verde (true) o rojo (false).
        private void MostrarTendencia(HtmlGenericControl contenedor, Label icono, Label valor, double? variacion, string unidad, bool subirEsBueno)
        {
            if (!variacion.HasValue)
            {
                contenedor.Attributes["class"] = "es-tendencia es-tendencia-neutra";
                icono.Text = "remove";
                valor.Text = "Sin datos";
                contenedor.Attributes["title"] = "No hay turnos en el período anterior para comparar.";
                return;
            }

            double v = Math.Round(variacion.Value, 1);
            string css;
            if (v == 0)
            {
                css = "es-tendencia-neutra";
                icono.Text = "trending_flat";
            }
            else
            {
                bool subio = v > 0;
                css = subio == subirEsBueno ? "es-tendencia-positiva" : "es-tendencia-negativa";
                icono.Text = subio ? "trending_up" : "trending_down";
            }

            contenedor.Attributes["class"] = "es-tendencia " + css;
            contenedor.Attributes.Remove("title");
            valor.Text = (v > 0 ? "+" : "") + v.ToString("0.0", Cultura) + unidad;
        }

        private static double? DiferenciaDeTasas(int cantidad, int total, int cantidadAnterior, int totalAnterior)
        {
            if (total == 0 || totalAnterior == 0)
                return null;
            return cantidad * 100.0 / total - cantidadAnterior * 100.0 / totalAnterior;
        }

        // Lunes a viernes entre las dos fechas (como mínimo 1, para no dividir por cero).
        private static int DiasHabiles(DateTime desde, DateTime hasta)
        {
            int dias = 0;
            for (DateTime d = desde.Date; d <= hasta.Date; d = d.AddDays(1))
            {
                if (d.DayOfWeek != DayOfWeek.Saturday && d.DayOfWeek != DayOfWeek.Sunday)
                    dias++;
            }
            return Math.Max(dias, 1);
        }

        // ----- 2. Donut y leyenda por estado -----

        private void MostrarDistribucionEstados(List<Turno> turnos)
        {
            int total = turnos.Count;
            lblDistribucionTotal.Text = total.ToString("N0", Cultura);
            lblDonutTotal.Text = total.ToString("N0", Cultura);

            var definicion = new[]
            {
                new { Estado = EstadoTurno.Cerrado, Nombre = "Cerrados (Atendidos)", Color = "#16a34a" },
                new { Estado = EstadoTurno.Cancelado, Nombre = "Cancelados", Color = "#dc2626" },
                new { Estado = EstadoTurno.NoAsistio, Nombre = "No Asistió (Ausente)", Color = "#6b7280" },
                new { Estado = EstadoTurno.Nuevo, Nombre = "Nuevos", Color = "#2563eb" },
                new { Estado = EstadoTurno.Reprogramado, Nombre = "Reprogramados", Color = "#d97706" }
            };

            // Cada segmento empieza donde termina el anterior (Dashoffset negativo acumulado).
            var estados = new List<object>();
            double acumulado = 0;
            foreach (var d in definicion)
            {
                int cantidad = turnos.Count(t => t.Estado == d.Estado);
                double largo = total == 0 ? 0 : CircunferenciaDonut * cantidad / total;

                estados.Add(new
                {
                    d.Nombre,
                    d.Color,
                    Cantidad = cantidad.ToString("N0", Cultura),
                    Porcentaje = Porcentaje(cantidad, total),
                    Dasharray = largo.ToString("0.##", Invariante) + " " + CircunferenciaDonut.ToString(Invariante),
                    Dashoffset = (-acumulado).ToString("0.##", Invariante)
                });
                acumulado += largo;
            }

            rptEstados.DataSource = estados;
            rptEstados.DataBind();

            // El anillo solo dibuja los estados con turnos (un segmento de largo 0 deja una marca en el borde).
            rptDonut.DataSource = estados.Where((x, i) => turnos.Any(t => t.Estado == definicion[i].Estado)).ToList();
            rptDonut.DataBind();
        }

        // ----- 3. Barras por especialidad -----

        private void MostrarDemanda(List<Turno> turnos)
        {
            int total = turnos.Count;
            lblDemandaTotal.Text = total.ToString("N0", Cultura);

            var grupos = turnos
                .GroupBy(t => new { t.Especialidad.Id, t.Especialidad.Descripcion })
                .Select(g => new { g.Key.Descripcion, Cantidad = g.Count() })
                .OrderByDescending(g => g.Cantidad)
                .ThenBy(g => g.Descripcion)
                .ToList();

            int maximo = grupos.Count == 0 ? 1 : grupos[0].Cantidad;
            var filas = (RankingCompleto ? grupos : grupos.Take(EspecialidadesEnRanking))
                .Select(g => new
                {
                    Especialidad = g.Descripcion,
                    Porcentaje = Porcentaje(g.Cantidad, total),
                    Cantidad = g.Cantidad.ToString("N0", Cultura),
                    // La especialidad con más turnos ocupa toda la barra.
                    Ancho = (g.Cantidad * 100.0 / maximo).ToString("0.#", Invariante) + "%"
                })
                .ToList();

            rptDemanda.DataSource = filas;
            rptDemanda.DataBind();

            lnkVerRanking.Visible = grupos.Count > EspecialidadesEnRanking;
            lblVerRanking.Text = RankingCompleto
                ? "Ver solo las " + EspecialidadesEnRanking + " principales"
                : "Ver ranking completo (" + grupos.Count + ")";
        }

        protected void lnkVerRanking_Click(object sender, EventArgs e)
        {
            RankingCompleto = !RankingCompleto;
            Calcular();
        }

        // ----- 4. Columnas por médico -----

        private void MostrarActividadMedicos(List<Turno> turnos)
        {
            var grupos = turnos
                .GroupBy(t => t.Medico.Id)
                .Select(g => new
                {
                    Medico = g.First().Medico,
                    Cantidad = g.Count(),
                    // Si atiende varias especialidades, se muestra la que más turnos tuvo en el período.
                    Especialidad = g.GroupBy(t => t.Especialidad.Descripcion)
                                    .OrderByDescending(x => x.Count())
                                    .First().Key
                })
                .OrderByDescending(g => g.Cantidad)
                .ThenBy(g => g.Medico.Apellido)
                .Take(MedicosEnGrafico)
                .ToList();

            int maximo = grupos.Count == 0 ? 1 : grupos[0].Cantidad;

            rptActividadMedicos.DataSource = grupos.Select(g => new
            {
                Cantidad = g.Cantidad.ToString("N0", Cultura),
                Alto = (g.Cantidad * 100.0 / maximo).ToString("0.#", Invariante) + "%",
                Iniciales = Iniciales(g.Medico.Nombre, g.Medico.Apellido),
                NombreCorto = "Dr/a. " + Inicial(g.Medico.Nombre) + ". " + g.Medico.Apellido,
                NombreCompleto = "Dr/a. " + g.Medico.Nombre + " " + g.Medico.Apellido,
                g.Especialidad
            }).ToList();
            rptActividadMedicos.DataBind();

            pnlSinMedicos.Visible = grupos.Count == 0;
        }

        // ----- 5. Matriz de rendimiento -----

        private class FilaRendimiento
        {
            public int IdEspecialidad { get; set; }
            public string Especialidad { get; set; }
            public int Medicos { get; set; }
            public int Total { get; set; }
            public int Atendidos { get; set; }
            public int Cancelados { get; set; }
            public int Inasistencias { get; set; }
        }

        // Una fila por especialidad activa (y por las inactivas que igual tuvieron turnos), respetando el filtro.
        private List<FilaRendimiento> ArmarRendimiento(List<Turno> turnos, List<Medico> medicos, List<Especialidad> especialidades)
        {
            var conTurnos = new HashSet<int>(turnos.Select(t => t.Especialidad.Id));

            return especialidades
                .Where(es => (IdEspecialidad == 0 || es.Id == IdEspecialidad) && (es.Activo || conTurnos.Contains(es.Id)))
                .Select(es =>
                {
                    List<Turno> propios = turnos.Where(t => t.Especialidad.Id == es.Id).ToList();
                    return new FilaRendimiento
                    {
                        IdEspecialidad = es.Id,
                        Especialidad = es.Descripcion,
                        // Médicos activos que tienen asignada la especialidad.
                        Medicos = medicos.Count(m => m.Activo && m.Especialidades != null && m.Especialidades.Any(x => x.Id == es.Id)),
                        Total = propios.Count,
                        Atendidos = propios.Count(t => t.Estado == EstadoTurno.Cerrado),
                        Cancelados = propios.Count(t => t.Estado == EstadoTurno.Cancelado),
                        Inasistencias = propios.Count(t => t.Estado == EstadoTurno.NoAsistio)
                    };
                })
                .OrderByDescending(f => f.Total)
                .ThenBy(f => f.Especialidad)
                .ToList();
        }

        // Médicos activos distintos con alguna de las especialidades de la tabla (un médico con dos especialidades cuenta una vez).
        private static int ContarMedicos(List<Medico> medicos, List<FilaRendimiento> filas)
        {
            var ids = new HashSet<int>(filas.Select(f => f.IdEspecialidad));
            return medicos.Count(m => m.Activo && m.Especialidades != null && m.Especialidades.Any(x => ids.Contains(x.Id)));
        }

        private void MostrarRendimiento(List<FilaRendimiento> filas, int totalTurnos, int medicosDistintos)
        {
            int paginas = Math.Max(1, (int)Math.Ceiling(filas.Count / (double)FilasPorPagina));
            if (Pagina > paginas) Pagina = paginas;
            if (Pagina < 1) Pagina = 1;

            // Colores del ícono: se alternan para distinguir las filas (no hay un ícono por especialidad en la base).
            string[] colores = { "icon-box-teal", "icon-box-blue", "icon-box-red", "es-icono-gris" };

            rptRendimiento.DataSource = filas
                .Skip((Pagina - 1) * FilasPorPagina)
                .Take(FilasPorPagina)
                .Select((f, i) => new
                {
                    f.IdEspecialidad,
                    f.Especialidad,
                    Icono = "stethoscope",
                    IconoCss = colores[((Pagina - 1) * FilasPorPagina + i) % colores.Length],
                    Medicos = f.Medicos.ToString("N0", Cultura),
                    Total = f.Total.ToString("N0", Cultura),
                    Atendidos = f.Atendidos.ToString("N0", Cultura),
                    Cancelados = f.Cancelados.ToString("N0", Cultura),
                    Inasistencias = f.Inasistencias.ToString("N0", Cultura),
                    Cumplimiento = f.Total == 0 ? "-" : Porcentaje(f.Atendidos, f.Total),
                    CumplimientoCss = CssCumplimiento(f.Atendidos, f.Total)
                })
                .ToList();
            rptRendimiento.DataBind();

            // Pie de la tabla: totales de todas las filas (no solo de la página).
            int atendidos = filas.Sum(f => f.Atendidos);
            lblTotalMedicos.Text = medicosDistintos.ToString("N0", Cultura) + (medicosDistintos == 1 ? " médico" : " médicos");
            lblTotalTurnos.Text = filas.Sum(f => f.Total).ToString("N0", Cultura);
            lblTotalAtendidos.Text = atendidos.ToString("N0", Cultura);
            lblTotalCancelados.Text = filas.Sum(f => f.Cancelados).ToString("N0", Cultura);
            lblTotalInasistencias.Text = filas.Sum(f => f.Inasistencias).ToString("N0", Cultura);
            lblTotalCumplimiento.Text = totalTurnos == 0 ? "-" : Porcentaje(atendidos, totalTurnos) + " PROM.";

            int primera = filas.Count == 0 ? 0 : (Pagina - 1) * FilasPorPagina + 1;
            int ultima = Math.Min(Pagina * FilasPorPagina, filas.Count);
            lblMostrando.Text = filas.Count == 0
                ? "No hay especialidades para mostrar"
                : "Mostrando " + primera + "-" + ultima + " de " + filas.Count + (filas.Count == 1 ? " especialidad" : " especialidades");

            lblPaginaActual.Text = Pagina + " / " + paginas;
            btnPaginaAnterior.Enabled = Pagina > 1;
            btnPaginaSiguiente.Enabled = Pagina < paginas;
        }

        private static string CssCumplimiento(int atendidos, int total)
        {
            if (total == 0) return "es-tendencia-neutra";
            return atendidos * 100.0 / total >= 80 ? "es-tendencia-positiva" : "es-tendencia-negativa";
        }

        protected void btnPaginaAnterior_Click(object sender, EventArgs e)
        {
            Pagina = Pagina - 1;
            Calcular();
        }

        protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
        {
            Pagina = Pagina + 1;
            Calcular();
        }

        // "Ver desglose": filtra toda la página por esa especialidad (mismo período).
        protected void rptRendimiento_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idEspecialidad;
            if (e.CommandName != "VerDesglose" || !int.TryParse(e.CommandArgument.ToString(), out idEspecialidad))
                return;

            if (ddlEspecialidad.Items.FindByValue(idEspecialidad.ToString()) != null)
                ddlEspecialidad.SelectedValue = idEspecialidad.ToString();

            // Los desplegables vuelven a mostrar el filtro aplicado (por si se habían cambiado sin aplicar).
            ddlPeriodo.SelectedValue = PeriodoAplicado;
            MostrarRangoPersonalizado(PeriodoAplicado == "personalizado");

            IdEspecialidad = idEspecialidad;
            Pagina = 1;
            Calcular();
        }

        // ----- Exportar la matriz a CSV (se abre con Excel) -----

        protected void btnExportarTabla_Click(object sender, EventArgs e)
        {
            List<Turno> turnos;
            List<Medico> medicos;
            List<FilaRendimiento> filas;
            try
            {
                turnos = new TurnoNegocio().buscar(new FiltroTurnos { Desde = Desde, Hasta = Hasta, IdEspecialidad = IdEspecialidad });
                medicos = new MedicoNegocio().listarConDetalle();
                filas = ArmarRendimiento(turnos, medicos, new EspecialidadNegocio().listar());
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudo exportar la tabla: " + Server.HtmlEncode(ex.Message), true);
                Calcular();
                return;
            }

            // Separador ";" porque Excel en español usa la coma como separador decimal.
            StringBuilder csv = new StringBuilder();
            csv.AppendLine("Matriz de rendimiento por especialidad");
            csv.AppendLine("Período;" + Desde.ToString("dd/MM/yyyy") + " - " + Hasta.ToString("dd/MM/yyyy"));
            csv.AppendLine("Especialidad;" + Csv(IdEspecialidad == 0 ? "Todas" : ddlEspecialidad.Items.FindByValue(IdEspecialidad.ToString())?.Text ?? IdEspecialidad.ToString()));
            csv.AppendLine();
            csv.AppendLine("Especialidad;Médicos asignados;Turnos totales;Atendidos (cerrados);Cancelados;Inasistencias;% Cumplimiento");

            foreach (FilaRendimiento f in filas)
            {
                csv.AppendLine(string.Join(";",
                    Csv(f.Especialidad), f.Medicos, f.Total, f.Atendidos, f.Cancelados, f.Inasistencias,
                    f.Total == 0 ? "" : (f.Atendidos * 100.0 / f.Total).ToString("0.0", Cultura)));
            }

            int total = filas.Sum(f => f.Total);
            int atendidos = filas.Sum(f => f.Atendidos);
            csv.AppendLine(string.Join(";", "TOTAL", ContarMedicos(medicos, filas), total, atendidos,
                filas.Sum(f => f.Cancelados), filas.Sum(f => f.Inasistencias),
                total == 0 ? "" : (atendidos * 100.0 / total).ToString("0.0", Cultura)));

            // UTF-8 con BOM para que Excel muestre bien los acentos.
            byte[] contenido = Encoding.UTF8.GetPreamble().Concat(Encoding.UTF8.GetBytes(csv.ToString())).ToArray();

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment; filename=rendimiento_especialidades_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
            Response.BinaryWrite(contenido);
            Response.Flush();
            Response.SuppressContent = true;
            Context.ApplicationInstance.CompleteRequest();
        }

        // Encierra el texto entre comillas si tiene ; o comillas.
        private static string Csv(string texto)
        {
            if (texto == null) return "";
            if (texto.Contains(";") || texto.Contains("\"") || texto.Contains("\n"))
                return "\"" + texto.Replace("\"", "\"\"") + "\"";
            return texto;
        }

        // ----- Sin datos en el sistema: los botones quedan ocultos en el .aspx -----

        protected void btnExportarPdf_Click(object sender, EventArgs e) { }
        protected void btnExportarExcel_Click(object sender, EventArgs e) { }

        // ----- Textos -----

        private static string Porcentaje(int cantidad, int total)
        {
            if (total == 0) return "0%";
            return (cantidad * 100.0 / total).ToString("0.0", Cultura) + "%";
        }

        private static string Iniciales(string nombre, string apellido)
        {
            return (Inicial(nombre) + Inicial(apellido)).ToUpper();
        }

        private static string Inicial(string texto)
        {
            return string.IsNullOrEmpty(texto) ? "" : texto.Substring(0, 1).ToUpper();
        }

        private static string Capitalizar(string texto)
        {
            return string.IsNullOrEmpty(texto) ? texto : char.ToUpper(texto[0], Cultura) + texto.Substring(1);
        }
    }
}
