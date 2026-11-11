<%@ Page Title="Estadísticas" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="Estadisticas.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Estadisticas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="estadisticas d-flex flex-column gap-4">

        <!--  1. ENCABEZADO Y EXPORTACIÓN  -->
        <div class="d-flex flex-column flex-xl-row align-items-xl-center justify-content-between gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="icon-box icon-box-32 icon-box-teal">
                        <span class="material-symbols-outlined icon-20">analytics</span>
                    </span>
                    <span class="text-uppercase fw-semibold text-secondary fs-11 es-etiqueta">Módulo de Auditoría y Control</span>
                </div>
                <h1 class="page-title h3 fw-bold text-dark mb-1">Estadísticas e Indicadores de Gestión</h1>
                <p class="text-muted fs-14 mb-0">Métricas consolidadas de rendimiento operativo, asistencia y ocupación médica mensual en tiempo real.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <asp:LinkButton ID="btnExportarPdf" runat="server" OnClick="btnExportarPdf_Click"
                    CssClass="btn btn-soft-outline px-3 py-2 d-inline-flex align-items-center gap-2 fw-semibold">
                    <span class="material-symbols-outlined icon-18 text-danger">picture_as_pdf</span>
                    <span>Exportar PDF</span>
                </asp:LinkButton>
                <asp:LinkButton ID="btnExportarExcel" runat="server" OnClick="btnExportarExcel_Click"
                    CssClass="btn btn-soft-outline px-3 py-2 d-inline-flex align-items-center gap-2 fw-semibold">
                    <span class="material-symbols-outlined icon-18 text-success">table_chart</span>
                    <span>Descargar Excel (CSV)</span>
                </asp:LinkButton>
                <%-- Imprime desde el navegador: no hace PostBack --%>
                <button type="button" class="btn btn-soft-outline px-3 py-2 d-inline-flex align-items-center gap-2 fw-semibold" onclick="window.print();">
                    <span class="material-symbols-outlined icon-18">print</span>
                    <span>Imprimir Informe</span>
                </button>
            </div>
        </div>

        <!--  2. FILTROS  -->
        <asp:Panel ID="pnlFiltros" runat="server" CssClass="card-custom p-3 p-lg-4" DefaultButton="btnAplicarFiltros">
            <div class="row g-3 align-items-end">
                <div class="col-12 col-md-6 col-lg-3">
                    <asp:Label ID="lblPeriodo" runat="server" AssociatedControlID="ddlPeriodo" CssClass="form-label text-uppercase fw-semibold text-secondary fs-11 mb-1" Text="Período Analítico"></asp:Label>
                    <div class="position-relative">
                        <span class="material-symbols-outlined icon-18 text-secondary es-icono-select">date_range</span>
                        <asp:DropDownList ID="ddlPeriodo" runat="server" CssClass="form-select form-select-custom es-select w-100">
                            <asp:ListItem Value="ultimos30" Selected="True">Últimos 30 días (01 May 2025 - 31 May 2025)</asp:ListItem>
                            <asp:ListItem Value="hoy">Hoy (24 de Mayo 2025)</asp:ListItem>
                            <asp:ListItem Value="semana">Esta semana en curso</asp:ListItem>
                            <asp:ListItem Value="mes">Este mes (Mayo 2025)</asp:ListItem>
                            <asp:ListItem Value="mesAnterior">Mes anterior (Abril 2025)</asp:ListItem>
                            <asp:ListItem Value="personalizado">Rango Personalizado...</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-3">
                    <%-- TEXTO DE EJEMPLO: la base no guarda sedes --%>
                    <asp:Label ID="lblSede" runat="server" AssociatedControlID="ddlSede" CssClass="form-label text-uppercase fw-semibold text-secondary fs-11 mb-1" Text="Sede Operativa"></asp:Label>
                    <div class="position-relative">
                        <span class="material-symbols-outlined icon-18 text-secondary es-icono-select">domain</span>
                        <asp:DropDownList ID="ddlSede" runat="server" CssClass="form-select form-select-custom es-select w-100">
                            <asp:ListItem Value="0" Selected="True">Todas las Sedes (Central y Belgrano)</asp:ListItem>
                            <asp:ListItem Value="1">Sede Central - Palermo (Av. Santa Fe 3200)</asp:ListItem>
                            <asp:ListItem Value="2">Sede Belgrano (Av. Cabildo 1850)</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-3">
                    <asp:Label ID="lblEspecialidad" runat="server" AssociatedControlID="ddlEspecialidad" CssClass="form-label text-uppercase fw-semibold text-secondary fs-11 mb-1" Text="Especialidad Médica"></asp:Label>
                    <div class="position-relative">
                        <span class="material-symbols-outlined icon-18 text-secondary es-icono-select">stethoscope</span>
                        <%-- Ítems de ejemplo: Value = Id de la especialidad (0 = todas) --%>
                        <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="form-select form-select-custom es-select w-100">
                            <asp:ListItem Value="0" Selected="True">Todas las especialidades (12 activas)</asp:ListItem>
                            <asp:ListItem Value="1">Cardiología Clínica</asp:ListItem>
                            <asp:ListItem Value="2">Dermatología Médica</asp:ListItem>
                            <asp:ListItem Value="3">Traumatología y Ortopedia</asp:ListItem>
                            <asp:ListItem Value="4">Pediatría Integral</asp:ListItem>
                            <asp:ListItem Value="5">Neurología</asp:ListItem>
                            <asp:ListItem Value="6">Oftalmología</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-3 d-flex gap-2">
                    <asp:LinkButton ID="btnAplicarFiltros" runat="server" OnClick="btnAplicarFiltros_Click"
                        CssClass="btn btn-teal px-3 py-2 flex-grow-1 d-inline-flex align-items-center justify-content-center gap-2 fw-semibold">
                        <span class="material-symbols-outlined icon-18">filter_alt</span>
                        <span>Aplicar filtros</span>
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnRestablecer" runat="server" OnClick="btnRestablecer_Click" ToolTip="Restablecer"
                        CssClass="btn btn-soft-outline px-3 py-2 d-inline-flex align-items-center justify-content-center gap-1 fw-semibold">
                        <span class="material-symbols-outlined icon-18">restart_alt</span>
                        <span>Restablecer</span>
                    </asp:LinkButton>
                </div>
            </div>
        </asp:Panel>

        <!--  3. TARJETAS KPI  -->
        <%-- Cada tendencia tiene: un <span runat="server"> (tndKpiX) cuya clase puede ser es-tendencia-positiva (verde) o
             es-tendencia-negativa (roja), un Label con el ícono (trending_up / trending_down) y un Label con el valor. --%>
        <div class="row g-3">
            <!-- KPI 1: Total de turnos -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between mb-3">
                        <div>
                            <span class="text-uppercase fw-semibold text-secondary fs-11 es-etiqueta">Total de Turnos</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiTotal" runat="server" CssClass="es-kpi-valor text-dark" Text="1.428"></asp:Label>
                                <span class="text-secondary small fw-medium">citas</span>
                            </div>
                        </div>
                        <div class="icon-box icon-box-48 icon-box-low">
                            <span class="material-symbols-outlined icon-26">calendar_month</span>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-1 pt-1 border-top border-light">
                        <div class="d-flex align-items-center gap-2">
                            <span id="tndKpiTotal" runat="server" class="es-tendencia es-tendencia-positiva">
                                <asp:Label ID="lblKpiTotalIcono" runat="server" CssClass="material-symbols-outlined es-icono-tendencia" Text="trending_up"></asp:Label>
                                <asp:Label ID="lblKpiTotalTendencia" runat="server" Text="+8.4%"></asp:Label>
                            </span>
                            <span class="text-secondary small">vs. mes anterior</span>
                        </div>
                        <asp:Label ID="lblKpiTotalPromedio" runat="server" CssClass="text-muted fs-12" Text="Promedio: 47.6 turnos/día hábil"></asp:Label>
                    </div>
                </div>
            </div>
            <!-- KPI 2: Tasa de cancelación -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between mb-3">
                        <div>
                            <span class="text-uppercase fw-semibold text-secondary fs-11 es-etiqueta">Tasa de Cancelación</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiCancelacion" runat="server" CssClass="es-kpi-valor text-danger" Text="7.2%"></asp:Label>
                                <span class="text-secondary small fw-medium">del total</span>
                            </div>
                        </div>
                        <div class="icon-box icon-box-48 icon-box-red">
                            <span class="material-symbols-outlined icon-26">cancel</span>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-1 pt-1 border-top border-light">
                        <div class="d-flex align-items-center gap-2">
                            <span id="tndKpiCancelacion" runat="server" class="es-tendencia es-tendencia-positiva">
                                <asp:Label ID="lblKpiCancelacionIcono" runat="server" CssClass="material-symbols-outlined es-icono-tendencia" Text="trending_down"></asp:Label>
                                <asp:Label ID="lblKpiCancelacionTendencia" runat="server" Text="-1.5%"></asp:Label>
                            </span>
                            <span class="text-secondary small">mejora favorable</span>
                        </div>
                        <asp:Label ID="lblKpiCancelados" runat="server" CssClass="text-muted fs-12" Text="103 turnos cancelados en total"></asp:Label>
                    </div>
                </div>
            </div>
            <!-- KPI 3: Tasa de inasistencia -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between mb-3">
                        <div>
                            <span class="text-uppercase fw-semibold text-secondary fs-11 es-etiqueta">Tasa de Inasistencia</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiInasistencia" runat="server" CssClass="es-kpi-valor text-dark" Text="5.8%"></asp:Label>
                                <span class="text-secondary small fw-medium">ausentismo</span>
                            </div>
                        </div>
                        <div class="icon-box icon-box-48 es-icono-gris">
                            <span class="material-symbols-outlined icon-26">person_off</span>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-1 pt-1 border-top border-light">
                        <div class="d-flex align-items-center gap-2">
                            <span id="tndKpiInasistencia" runat="server" class="es-tendencia es-tendencia-positiva">
                                <asp:Label ID="lblKpiInasistenciaIcono" runat="server" CssClass="material-symbols-outlined es-icono-tendencia" Text="trending_down"></asp:Label>
                                <asp:Label ID="lblKpiInasistenciaTendencia" runat="server" Text="-0.8%"></asp:Label>
                            </span>
                            <span class="text-secondary small">vs. mes anterior</span>
                        </div>
                        <asp:Label ID="lblKpiAusentes" runat="server" CssClass="text-muted fs-12" Text="83 pacientes ausentes sin aviso previo"></asp:Label>
                    </div>
                </div>
            </div>
            <!-- KPI 4: Turnos cerrados (atendidos) -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between mb-3">
                        <div>
                            <span class="text-uppercase fw-semibold text-secondary fs-11 es-etiqueta">Turnos Cerrados (Atendidos)</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiCerrados" runat="server" CssClass="es-kpi-valor text-success" Text="81.6%"></asp:Label>
                                <asp:Label ID="lblKpiCerradosCantidad" runat="server" CssClass="text-secondary small fw-medium" Text="(1.165)"></asp:Label>
                            </div>
                        </div>
                        <div class="icon-box icon-box-48 icon-box-green">
                            <span class="material-symbols-outlined icon-26">task_alt</span>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-1 pt-1 border-top border-light">
                        <div class="d-flex align-items-center gap-2">
                            <span id="tndKpiCerrados" runat="server" class="es-tendencia es-tendencia-positiva">
                                <asp:Label ID="lblKpiCerradosIcono" runat="server" CssClass="material-symbols-outlined es-icono-tendencia" Text="trending_up"></asp:Label>
                                <asp:Label ID="lblKpiCerradosTendencia" runat="server" Text="+3.2%"></asp:Label>
                            </span>
                            <span class="text-secondary small">efectividad alta</span>
                        </div>
                        <span class="text-muted fs-12">Efectividad de consulta completada</span>
                    </div>
                </div>
            </div>
        </div>

        <!--  4. GRÁFICOS: DISTRIBUCIÓN POR ESTADO Y DEMANDA POR ESPECIALIDAD  -->
        <div class="row g-4">
            <!-- Gráfico 1: donut por estado -->
            <div class="col-12 col-xl-5">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-center justify-content-between pb-2 border-bottom border-light">
                        <div>
                            <h2 class="h5 fw-bold text-dark mb-0">Distribución por Estado</h2>
                            <p class="text-secondary small mb-0">Proporción del ciclo de vida de los <asp:Label ID="lblDistribucionTotal" runat="server" Text="1.428"></asp:Label> turnos</p>
                        </div>
                        <span class="material-symbols-outlined text-secondary">pie_chart</span>
                    </div>
                    <%-- flex-wrap: si la tarjeta es angosta, la leyenda pasa abajo del donut en lugar de salirse --%>
                    <div class="d-flex flex-wrap align-items-center justify-content-center gap-4 my-3 py-2">
                        <%--
                            rptDonut y rptEstados usan la misma lista. Campos de cada estado:
                              Nombre, Color (#16a34a), Cantidad, Porcentaje ("81.6%"),
                              Dasharray ("307.6 376.99") y Dashoffset ("-307.6").
                            El anillo mide 376.99 (2 × π × 60). Dasharray = largo del segmento + " 376.99";
                            Dashoffset = menos la suma de los segmentos anteriores.
                            Los números del SVG van con PUNTO decimal (CultureInfo.InvariantCulture), no con coma.
                        --%>
                        <div class="position-relative flex-shrink-0 es-donut">
                            <svg class="w-100 h-100 es-donut-svg" viewBox="0 0 160 160">
                                <circle cx="80" cy="80" r="60" fill="transparent" stroke="#f1f5f9" stroke-width="22"></circle>
                                <asp:Repeater ID="rptDonut" runat="server">
                                    <ItemTemplate>
                                        <circle cx="80" cy="80" r="60" fill="transparent" stroke-width="22"
                                            stroke='<%# Eval("Color") %>'
                                            stroke-dasharray='<%# Eval("Dasharray") %>'
                                            stroke-dashoffset='<%# Eval("Dashoffset") %>'></circle>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </svg>
                            <div class="position-absolute top-50 start-50 translate-middle text-center es-sin-clic">
                                <asp:Label ID="lblDonutTotal" runat="server" CssClass="h3 fw-bold text-dark d-block mb-0 lh-1" Text="1.428"></asp:Label>
                                <span class="text-uppercase text-secondary fw-semibold es-etiqueta es-donut-leyenda">Total Turnos</span>
                            </div>
                        </div>
                        <div class="d-flex flex-column gap-2 es-leyenda">
                            <asp:Repeater ID="rptEstados" runat="server">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center justify-content-between gap-2 p-2 rounded-2 es-fila-leyenda">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="rounded-circle flex-shrink-0 es-punto" style='<%# "background-color: " + Eval("Color") + ";" %>'></span>
                                            <span class="text-dark small fw-medium"><%#: Eval("Nombre") %></span>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fw-bold text-dark small"><%#: Eval("Cantidad") %></span>
                                            <span class="text-secondary small text-end es-col-porcentaje"><%#: Eval("Porcentaje") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráfico 2: barras horizontales por especialidad -->
            <div class="col-12 col-xl-7">
                <div class="card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-center justify-content-between pb-2 border-bottom border-light">
                        <div>
                            <h2 class="h5 fw-bold text-dark mb-0">Demanda por Especialidad</h2>
                            <p class="text-secondary small mb-0">Volumen y peso porcentual de atención médica por servicio</p>
                        </div>
                        <span class="material-symbols-outlined text-secondary">bar_chart</span>
                    </div>
                    <%--
                        Campos de cada fila: Especialidad, Promedio ("(Prom. 22 min)" - TEXTO DE EJEMPLO, la base no guarda la duración),
                        Porcentaje ("26.9%"), Cantidad (384) y Ancho ("100%": la especialidad con más turnos ocupa toda la barra).
                    --%>
                    <div class="d-flex flex-column gap-3 my-3">
                        <asp:Repeater ID="rptDemanda" runat="server">
                            <ItemTemplate>
                                <div>
                                    <div class="d-flex align-items-center justify-content-between mb-1">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fw-semibold text-dark small"><%#: Eval("Especialidad") %></span>
                                            <span class="text-muted small"><%#: Eval("Promedio") %></span>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <span class="text-secondary small fw-medium"><%#: Eval("Porcentaje") %></span>
                                            <span class="fw-bold text-dark small text-end es-col-cantidad"><%#: Eval("Cantidad") %></span>
                                        </div>
                                    </div>
                                    <div class="es-barra">
                                        <div class="es-barra-relleno" style='<%# "width: " + Eval("Ancho") + ";" %>'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="d-flex align-items-center justify-content-between pt-2 border-top border-light text-secondary">
                        <span class="fs-12">Base total calculada sobre <asp:Label ID="lblDemandaTotal" runat="server" Text="1.428"></asp:Label> citas asignadas</span>
                        <asp:LinkButton ID="lnkVerRanking" runat="server" OnClick="lnkVerRanking_Click"
                            CssClass="small text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 text-cl-primary">
                            <span>Ver ranking completo</span>
                            <span class="material-symbols-outlined icon-18">arrow_forward</span>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <!--  5. GRÁFICO 3: ACTIVIDAD POR PROFESIONAL MÉDICO  -->
        <div class="card-custom p-4">
            <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-2 mb-3">
                <div>
                    <h2 class="h5 fw-bold text-dark mb-0">Actividad por Profesional Médico</h2>
                    <p class="text-secondary small mb-0">Top 6 médicos con mayor carga de atención clínica durante el período seleccionado</p>
                </div>
                <span class="d-inline-flex align-items-center gap-1 px-3 py-1 rounded-pill fs-12 chip-soft">
                    <span class="rounded-circle es-punto-chico"></span> Carga de Turnos Asignados
                </span>
            </div>
            <%--
                Campos de cada médico: Cantidad (192), Alto ("100%": el médico con más turnos ocupa toda la columna),
                Iniciales ("MS"), NombreCorto ("Dr. M. Soria"), NombreCompleto (tooltip) y Especialidad.
            --%>
            <div class="table-responsive">
                <div class="p-3 rounded-3 es-columnas">
                    <div class="d-flex align-items-end justify-content-around h-100">
                        <asp:Repeater ID="rptActividadMedicos" runat="server">
                            <ItemTemplate>
                                <div class="d-flex flex-column align-items-center h-100 justify-content-end es-columna">
                                    <span class="fw-bold small mb-1 text-cl-primary"><%#: Eval("Cantidad") %></span>
                                    <div class="es-columna-fondo">
                                        <div class="es-columna-relleno" style='<%# "height: " + Eval("Alto") + ";" %>'></div>
                                    </div>
                                    <div class="text-center mt-2">
                                        <span class="es-avatar shadow-sm mx-auto mb-1"><%#: Eval("Iniciales") %></span>
                                        <div class="fw-semibold text-truncate small es-texto-medico" title='<%#: Eval("NombreCompleto") %>'><%#: Eval("NombreCorto") %></div>
                                        <div class="text-muted text-truncate fs-11 es-texto-medico"><%#: Eval("Especialidad") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>

        <!--  6. MATRIZ DE RENDIMIENTO POR SERVICIO  -->
        <div class="card-custom overflow-hidden">
            <div class="p-3 p-lg-4 d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3 border-bottom border-light">
                <div>
                    <h2 class="h5 fw-bold text-dark mb-0">Matriz Detallada de Rendimiento por Servicio</h2>
                    <p class="text-secondary small mb-0">Desglose de turnos concertados, completados y mermas por inasistencia o cancelación</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2 px-3 py-1 rounded-2 text-secondary chip-soft">
                        <span class="material-symbols-outlined icon-18">visibility</span>
                        <span class="small fw-medium">Vista: Especialidades</span>
                    </div>
                    <asp:LinkButton ID="btnExportarTabla" runat="server" OnClick="btnExportarTabla_Click"
                        CssClass="btn btn-soft-outline btn-sm px-3 py-1 d-inline-flex align-items-center gap-1 fw-semibold text-cl-primary">
                        <span class="material-symbols-outlined icon-18">file_download</span>
                        <span>Exportar tabla a Excel</span>
                    </asp:LinkButton>
                </div>
            </div>
            <%--
                Campos de cada fila: IdEspecialidad, Especialidad, Detalle (consultorio - TEXTO DE EJEMPLO, la base no lo guarda),
                Icono (nombre Material Symbols), IconoCss (icon-box-red, icon-box-teal, icon-box-blue, es-icono-gris),
                Medicos, Total, Atendidos, Cancelados, Inasistencias y Cumplimiento ("83.6%").
            --%>
            <div class="table-responsive">
                <table class="table es-tabla mb-0 w-100">
                    <thead>
                        <tr>
                            <th>Especialidad / Servicio</th>
                            <th class="text-center">Médicos Asig.</th>
                            <th class="text-end">Turnos Totales</th>
                            <th class="text-end">Atendidos (Cerrados)</th>
                            <th class="text-end">Cancelados</th>
                            <th class="text-end">Inasistencias</th>
                            <th class="text-center">% Cumplimiento</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptRendimiento" runat="server" OnItemCommand="rptRendimiento_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class='<%# "icon-box es-icono-fila " + Eval("IconoCss") %>'>
                                                <span class="material-symbols-outlined icon-18"><%#: Eval("Icono") %></span>
                                            </div>
                                            <div>
                                                <span class="fw-semibold text-dark d-block"><%#: Eval("Especialidad") %></span>
                                                <span class="text-muted fs-12"><%#: Eval("Detalle") %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center fw-medium"><%#: Eval("Medicos") %></td>
                                    <td class="text-end fw-semibold"><%#: Eval("Total") %></td>
                                    <td class="text-end fw-medium text-success"><%#: Eval("Atendidos") %></td>
                                    <td class="text-end text-danger"><%#: Eval("Cancelados") %></td>
                                    <td class="text-end text-secondary"><%#: Eval("Inasistencias") %></td>
                                    <td class="text-center">
                                        <span class="es-tendencia es-tendencia-positiva"><%#: Eval("Cumplimiento") %></span>
                                    </td>
                                    <td class="text-center">
                                        <asp:LinkButton ID="btnVerDesglose" runat="server" CommandName="VerDesglose" CommandArgument='<%# Eval("IdEspecialidad") %>'
                                            CssClass="btn btn-link p-0 text-decoration-none small fw-semibold d-inline-flex align-items-center text-cl-primary">
                                            <span>Ver desglose</span>
                                            <span class="material-symbols-outlined icon-16">chevron_right</span>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined icon-18 text-cl-primary">functions</span>
                                    <span>TOTAL CONSOLIDADO</span>
                                </div>
                            </td>
                            <td class="text-center"><asp:Label ID="lblTotalMedicos" runat="server" Text="16 médicos"></asp:Label></td>
                            <td class="text-end"><asp:Label ID="lblTotalTurnos" runat="server" Text="1.428"></asp:Label></td>
                            <td class="text-end text-success"><asp:Label ID="lblTotalAtendidos" runat="server" Text="1.165"></asp:Label></td>
                            <td class="text-end text-danger"><asp:Label ID="lblTotalCancelados" runat="server" Text="103"></asp:Label></td>
                            <td class="text-end text-secondary"><asp:Label ID="lblTotalInasistencias" runat="server" Text="83"></asp:Label></td>
                            <td class="text-center">
                                <asp:Label ID="lblTotalCumplimiento" runat="server" CssClass="badge rounded-pill text-white px-3 py-1 fs-12 es-badge-total" Text="81.6% PROM."></asp:Label>
                            </td>
                            <td class="text-center text-muted small"><asp:Label ID="lblTotalAuditoria" runat="server" Text="Auditoría OK"></asp:Label></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <div class="p-3 d-flex flex-column flex-sm-row align-items-center justify-content-between gap-2 border-top border-light">
                <span class="text-secondary small">
                    <asp:Label ID="lblMostrando" runat="server" Text="Mostrando 6 especialidades de 6 auditadas"></asp:Label>
                    | Reporte generado automáticamente por
                    <%-- TEXTO DE EJEMPLO: podría ser el usuario logueado --%>
                    <asp:Label ID="lblAutorReporte" runat="server" CssClass="text-dark fw-medium" Text="Lic. Martín Palermo"></asp:Label>
                </span>
                <div class="d-flex align-items-center gap-1">
                    <asp:LinkButton ID="btnPaginaAnterior" runat="server" OnClick="btnPaginaAnterior_Click" Enabled="false"
                        CssClass="btn btn-soft-outline btn-sm px-3">Anterior</asp:LinkButton>
                    <asp:Label ID="lblPaginaActual" runat="server" CssClass="btn btn-teal btn-sm px-3 es-sin-clic" Text="1"></asp:Label>
                    <asp:LinkButton ID="btnPaginaSiguiente" runat="server" OnClick="btnPaginaSiguiente_Click" Enabled="false"
                        CssClass="btn btn-soft-outline btn-sm px-3">Siguiente</asp:LinkButton>
                </div>
            </div>
        </div>

    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
