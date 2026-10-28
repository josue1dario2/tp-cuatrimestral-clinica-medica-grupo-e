<%@ Page Title="Mis turnos - Agenda Médica" Language="C#" MasterPageFile="~/Medico.Master" AutoEventWireup="true" CodeBehind="MisTurnos.aspx.cs" Inherits="Clinica_Medica_Grupo_e.MisTurnos" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntTitulo" ContentPlaceHolderID="TituloHeader" runat="server">
    <div class="cl-header-title fw-semibold text-dark lh-sm">Mis Turnos - Agenda Médica</div>
    <asp:Label ID="lblSubtituloHeader" runat="server" CssClass="cl-header-subtitle text-secondary small d-block" Text="Centro Ambulatorio Central • Consultorio 4B"></asp:Label>
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column w-100 gap-4">

        <!-- ===================== 1. ENCABEZADO DE SECCIÓN ===================== -->
        <div class="cl-card p-4 d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
            <div class="d-flex align-items-start gap-3">
                <div class="cl-section-icon rounded-3 d-flex align-items-center justify-content-center flex-shrink-0">
                    <i class="bi bi-hospital"></i>
                </div>
                <div class="d-flex flex-column">
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <h1 class="cl-section-title fw-semibold text-dark mb-0">Agenda Médica y Turnos</h1>
                        <span class="cl-pill-activo badge rounded-pill fw-semibold d-flex align-items-center gap-1">
                            <span class="spinner-grow spinner-grow-sm text-success" role="status"></span>
                            <asp:Label ID="lblEstadoConsultorio" runat="server" Text="Consultorio Activo"></asp:Label>
                        </span>
                    </div>
                    <p class="cl-section-meta text-secondary mb-0 mt-1">
                        <asp:Label ID="lblNombreMedico" runat="server" CssClass="fw-semibold text-dark" Text="Dr. Martín Soria"></asp:Label>
                        •
                        <asp:Label ID="lblDatosConsultorio" runat="server" Text="Especialidad: Cardiología Clínica • Consultorio 07 (Sede Central)"></asp:Label>
                    </p>
                </div>
            </div>

            <div class="cl-no-print d-flex align-items-center gap-2 align-self-end align-self-lg-center">
                <%-- Imprimir es solo del navegador, no necesita PostBack --%>
                <button type="button" class="btn btn-cl-secondary d-flex align-items-center gap-2 px-3 py-2" onclick="window.print();" title="Imprimir agenda del día">
                    <i class="bi bi-printer"></i>
                    <span>Imprimir agenda</span>
                </button>
                <asp:LinkButton ID="btnExportarAgenda" runat="server" OnClick="btnExportarAgenda_Click" ToolTip="Descargar planilla Excel/PDF"
                    CssClass="btn btn-cl-secondary d-flex align-items-center gap-2 px-3 py-2">
                    <i class="bi bi-download"></i>
                    <span>Exportar</span>
                </asp:LinkButton>
            </div>
        </div>

        <!-- ===================== 2. SEMANA EN CURSO ===================== -->
        <div class="d-flex flex-column gap-2">
            <div class="d-flex align-items-center justify-content-between px-1">
                <asp:Label ID="lblSemanaTitulo" runat="server" CssClass="cl-small-caps text-uppercase text-secondary fw-semibold" Text="Semana en curso • Mayo - Junio 2025"></asp:Label>
                <asp:Label ID="lblHorarioAtencion" runat="server" CssClass="cl-metric-note text-secondary" Text="Horario de atención: 08:30 a 13:30 hs"></asp:Label>
            </div>

            <%--
                Campos esperados en el DataSource (un ítem por día):
                  Fecha (yyyy-MM-dd), DiaNombre, DiaNumero, Mes, TurnosTexto, Detalle,
                  EsHoy (bool), CardCss ("" | cl-week-today | cl-week-off)
            --%>
            <div class="row g-2">
                <asp:Repeater ID="rptSemana" runat="server" OnItemCommand="rptSemana_ItemCommand">
                    <ItemTemplate>
                        <div class="col-6 col-md-3 col-lg">
                            <asp:LinkButton ID="lnkDia" runat="server" CssClass="cl-week-link"
                                CommandName="SeleccionarDia" CommandArgument='<%# Eval("Fecha") %>'>
                                <div class='cl-week-card <%# Eval("CardCss") %>'>
                                    <div class="d-flex align-items-center justify-content-between w-100 mb-1">
                                        <span class="cl-week-dayname cl-small-caps text-uppercase text-secondary fw-semibold"><%#: Eval("DiaNombre") %></span>
                                        <asp:PlaceHolder ID="phHoy" runat="server" Visible='<%# (bool)Eval("EsHoy") %>'>
                                            <span class="cl-week-badge-hoy badge rounded-pill fw-semibold text-white px-2 py-1">Hoy</span>
                                        </asp:PlaceHolder>
                                    </div>
                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                        <span class="cl-week-number fw-semibold text-dark mb-0"><%#: Eval("DiaNumero") %></span>
                                        <span class="cl-week-month text-secondary"><%#: Eval("Mes") %></span>
                                    </div>
                                    <div class="cl-week-footer d-flex flex-column mt-auto pt-2">
                                        <span class="cl-week-count fw-semibold text-dark"><%#: Eval("TurnosTexto") %></span>
                                        <span class="cl-week-detail text-secondary"><%#: Eval("Detalle") %></span>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- ===================== 3. MÉTRICAS DE LA JORNADA ===================== -->
        <div class="row g-3">
            <div class="col-12 col-md-4">
                <div class="cl-card p-4 h-100 d-flex align-items-center justify-content-between">
                    <div class="d-flex flex-column">
                        <span class="cl-metric-label text-secondary fw-medium">Total Turnos Hoy</span>
                        <div class="d-flex align-items-baseline gap-1 mt-1">
                            <asp:Label ID="lblMetricaTotalTurnos" runat="server" CssClass="cl-metric-value fw-semibold text-dark" Text="12"></asp:Label>
                            <span class="cl-metric-unit text-secondary">pacientes</span>
                        </div>
                        <asp:Label ID="lblMetricaJornada" runat="server" CssClass="cl-metric-note text-secondary mt-1" Text="Jornada 08:30 - 13:30 hs"></asp:Label>
                    </div>
                    <div class="cl-metric-icon cl-metric-icon-blue rounded-3 d-flex align-items-center justify-content-center flex-shrink-0">
                        <i class="bi bi-people-fill"></i>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-4">
                <div class="cl-card p-4 h-100 d-flex align-items-center justify-content-between">
                    <div class="d-flex flex-column">
                        <span class="cl-metric-label text-secondary fw-medium">Pendientes / En Espera</span>
                        <div class="d-flex align-items-baseline gap-1 mt-1">
                            <asp:Label ID="lblMetricaPendientes" runat="server" CssClass="cl-metric-value fw-semibold text-cl-primary-dark" Text="8"></asp:Label>
                            <span class="cl-metric-unit text-secondary">por atender</span>
                        </div>
                        <asp:Label ID="lblMetricaEnEspera" runat="server" CssClass="cl-metric-note fw-semibold text-cl-primary-dark mt-1" Text="1 en sala de espera ahora"></asp:Label>
                    </div>
                    <div class="cl-metric-icon cl-metric-icon-teal rounded-3 d-flex align-items-center justify-content-center flex-shrink-0">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-4">
                <div class="cl-card p-4 h-100 d-flex align-items-center justify-content-between">
                    <div class="d-flex flex-column">
                        <span class="cl-metric-label text-secondary fw-medium">Atendidos / Finalizados</span>
                        <div class="d-flex align-items-baseline gap-1 mt-1">
                            <asp:Label ID="lblMetricaAtendidos" runat="server" CssClass="cl-metric-value fw-semibold text-cl-green-dark" Text="4"></asp:Label>
                            <span class="cl-metric-unit text-secondary">completados</span>
                        </div>
                        <asp:Label ID="lblMetricaPorcentaje" runat="server" CssClass="cl-metric-note fw-semibold text-cl-green-dark mt-1" Text="33% de la jornada completada"></asp:Label>
                    </div>
                    <div class="cl-metric-icon cl-metric-icon-green rounded-3 d-flex align-items-center justify-content-center flex-shrink-0">
                        <i class="bi bi-check-circle-fill"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===================== 4. FECHA, FILTRO Y BÚSQUEDA ===================== -->
        <div class="cl-no-print cl-card p-3 d-flex flex-column flex-lg-row align-items-stretch align-items-lg-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-1 flex-wrap flex-sm-nowrap">
                <asp:LinkButton ID="btnDiaAnterior" runat="server" OnClick="btnDiaAnterior_Click" ToolTip="Día anterior"
                    CssClass="cl-btn-square btn btn-cl-secondary d-flex align-items-center justify-content-center p-2">
                    <i class="bi bi-chevron-left"></i>
                </asp:LinkButton>
                <div class="cl-date-box d-flex align-items-center gap-2 px-3 py-2 rounded-2 text-dark fw-semibold">
                    <i class="bi bi-calendar3 text-cl-primary-dark"></i>
                    <asp:Label ID="lblFechaSeleccionada" runat="server" Text="Hoy - Lunes 26 de mayo, 2025"></asp:Label>
                </div>
                <asp:LinkButton ID="btnDiaSiguiente" runat="server" OnClick="btnDiaSiguiente_Click" ToolTip="Día siguiente"
                    CssClass="cl-btn-square btn btn-cl-secondary d-flex align-items-center justify-content-center p-2">
                    <i class="bi bi-chevron-right"></i>
                </asp:LinkButton>
                <asp:LinkButton ID="btnIrAHoy" runat="server" OnClick="btnIrAHoy_Click"
                    CssClass="cl-btn-hoy btn btn-cl-secondary px-3 py-2 fw-semibold" Text="Ir a hoy"></asp:LinkButton>
            </div>

            <div class="d-flex flex-column flex-sm-row align-items-center gap-2 w-100 justify-content-lg-end">
                <div class="cl-filter-select w-100">
                    <asp:DropDownList ID="ddlFiltroEstado" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroEstado_SelectedIndexChanged"
                        CssClass="cl-input-soft form-select border-0 text-dark">
                        <asp:ListItem Value="todos" Text="Todos los estados (12)"></asp:ListItem>
                        <asp:ListItem Value="nuevo" Text="Nuevos / Pendientes (8)"></asp:ListItem>
                        <asp:ListItem Value="cerrado" Text="Atendidos / Cerrados (4)"></asp:ListItem>
                        <asp:ListItem Value="reprogramado" Text="Reprogramados (1)"></asp:ListItem>
                        <asp:ListItem Value="noasistio" Text="No asistió (0)"></asp:ListItem>
                        <asp:ListItem Value="cancelado" Text="Cancelados (0)"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="cl-filter-search position-relative w-100">
                    <i class="cl-search-icon bi bi-search position-absolute top-50 translate-middle-y text-secondary"></i>
                    <%-- AutoPostBack: busca al presionar Enter o al salir del campo --%>
                    <asp:TextBox ID="txtBuscarPaciente" runat="server" AutoPostBack="true" OnTextChanged="txtBuscarPaciente_TextChanged"
                        CssClass="cl-input-soft form-control border-0 ps-5" placeholder="Buscar paciente o DNI..."></asp:TextBox>
                </div>
            </div>
        </div>

        <!-- ===================== 5. TABLA DE TURNOS ===================== -->
        <div class="cl-card overflow-hidden d-flex flex-column">
            <div class="table-responsive">
                <%--
                    Campos esperados en el DataSource (un ítem por turno):
                      IdTurno, Hora, PacienteNombre, PacienteDetalle ("62 años • DNI 16.482.910 • PAMI"), Motivo,
                      EstadoTexto, EstadoCss (cl-estado-nuevo | cl-estado-cerrado | cl-estado-reprogramado | cl-estado-cancelado | cl-estado-noasistio),
                      EstadoIcono (ej: bi-check-circle-fill), EnSalaEspera (bool),
                      FilaCss ("" | cl-fila-actual | cl-fila-atenuada),
                      AccionTexto, AccionComando (Atender | VerFicha | VerMotivo...), AccionCss (btn-cl-primary | btn-cl-secondary), AccionIcono
                --%>
                <asp:Repeater ID="rptMisTurnos" runat="server" OnItemCommand="rptMisTurnos_ItemCommand">
                    <HeaderTemplate>
                        <table class="cl-turnos-table table table-hover align-middle mb-0">
                            <thead>
                                <tr class="text-secondary fw-semibold">
                                    <th class="py-3 px-4">Hora</th>
                                    <th class="py-3 px-4">Paciente • DNI • Cobertura</th>
                                    <th class="py-3 px-4">Motivo de Consulta</th>
                                    <th class="py-3 px-4">Estado</th>
                                    <th class="py-3 px-4 text-end">Acciones Médicas</th>
                                </tr>
                            </thead>
                            <tbody class="text-dark">
                    </HeaderTemplate>
                    <ItemTemplate>
                                <tr class='<%# Eval("FilaCss") %>'>
                                    <td class="cl-col-hora py-3 px-4 fw-semibold text-secondary font-monospace text-nowrap"><%#: Eval("Hora") %></td>
                                    <td class="py-3 px-4">
                                        <div class="d-flex flex-column">
                                            <div class="d-flex align-items-center gap-2 flex-wrap">
                                                <span class="fw-semibold text-dark"><%#: Eval("PacienteNombre") %></span>
                                                <asp:PlaceHolder ID="phSalaEspera" runat="server" Visible='<%# (bool)Eval("EnSalaEspera") %>'>
                                                    <span class="cl-pill-sala badge fw-semibold text-white d-flex align-items-center gap-1">
                                                        <i class="bi bi-door-open"></i> En sala de espera
                                                    </span>
                                                </asp:PlaceHolder>
                                            </div>
                                            <span class="cl-row-detail text-secondary"><%#: Eval("PacienteDetalle") %></span>
                                        </div>
                                    </td>
                                    <td class="py-3 px-4"><%#: Eval("Motivo") %></td>
                                    <td class="py-3 px-4 text-nowrap">
                                        <span class='cl-estado <%# Eval("EstadoCss") %>'>
                                            <i class='bi <%# Eval("EstadoIcono") %>'></i> <%#: Eval("EstadoTexto") %>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4 text-end text-nowrap">
                                        <asp:LinkButton ID="btnAccion" runat="server"
                                            CommandName='<%# Eval("AccionComando") %>' CommandArgument='<%# Eval("IdTurno") %>'
                                            CssClass='<%# "cl-btn-accion btn py-1 px-3 fw-semibold " + Eval("AccionCss") %>'>
                                            <i class='bi <%# Eval("AccionIcono") %> me-1'></i> <%#: Eval("AccionTexto") %>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false" CssClass="text-center text-secondary small py-4">
                    No hay turnos para la fecha y el filtro seleccionados.
                </asp:Panel>
            </div>

            <div class="cl-table-footer d-flex align-items-center justify-content-between p-3">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-check text-cl-primary-dark"></i>
                    <asp:Label ID="lblResumenTabla" runat="server" Text="Mostrando 8 registros de 12 para el Dr. Martín Soria en Consultorio 07"></asp:Label>
                </div>
                <asp:Label ID="lblTurnosRestantes" runat="server" CssClass="fw-semibold" Text="Turnos restantes: 8"></asp:Label>
            </div>
        </div>

        <!-- ===================== 6. MODAL: INICIAR ATENCIÓN ===================== -->
        <%-- Se abre desde el code-behind al presionar "Atender" en una fila (ver comentario en MisTurnos.aspx.cs) --%>
        <div class="modal fade" id="modalAtencion" tabindex="-1" aria-labelledby="modalAtencionLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">

                    <div class="cl-modal-header modal-header border-0 text-white p-3 px-4">
                        <div class="d-flex align-items-center gap-3">
                            <div class="cl-modal-icon rounded-3 d-flex align-items-center justify-content-center flex-shrink-0">
                                <i class="bi bi-hospital"></i>
                            </div>
                            <div class="d-flex flex-column">
                                <h2 class="h6 modal-title fw-semibold text-white mb-0" id="modalAtencionLabel">Iniciar Atención Médica</h2>
                                <asp:Label ID="lblModalMedico" runat="server" CssClass="cl-modal-subtitle" Text="Dr. Martín Soria • Consultorio 07"></asp:Label>
                            </div>
                        </div>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <div class="modal-body p-4 d-flex flex-column gap-3">
                        <asp:HiddenField ID="hfIdTurnoModal" runat="server" />

                        <div class="bg-cl-soft p-3 rounded-3 d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-2">
                            <div class="d-flex flex-column">
                                <asp:Label ID="lblModalPaciente" runat="server" CssClass="fw-bold text-dark" Text="González, Martín Nicolás"></asp:Label>
                                <asp:Label ID="lblModalPacienteDetalle" runat="server" CssClass="cl-text-12 text-secondary" Text="38 años • DNI 35.892.410 • OSDE 210"></asp:Label>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <asp:Label ID="lblModalHora" runat="server" CssClass="cl-modal-badge-hora badge fw-semibold" Text="Turno: 10:00 hs"></asp:Label>
                                <asp:Label ID="lblModalEstado" runat="server" CssClass="cl-modal-badge-estado badge fw-semibold" Text="En espera"></asp:Label>
                            </div>
                        </div>

                        <div class="d-flex flex-column gap-1">
                            <span class="cl-text-13 fw-medium text-secondary">Motivo declarado en recepción:</span>
                            <p class="cl-modal-quote p-2 px-3 rounded-2 text-dark mb-0">
                                <asp:Label ID="lblModalMotivo" runat="server" Text="Chequeo cardiológico anual preventivo y realización de ECG en consultorio. Refiere antecedentes familiares de HTA."></asp:Label>
                            </p>
                        </div>

                        <div class="d-flex flex-column gap-1">
                            <label class="form-label d-flex align-items-center justify-content-between mb-1" for="<%= txtNotasConsulta.ClientID %>">
                                <span class="cl-text-13 fw-semibold text-dark">Notas de consulta • Anamnesis inicial:</span>
                                <span class="cl-text-12 text-secondary fw-normal">Guardado automático en HC</span>
                            </label>
                            <asp:TextBox ID="txtNotasConsulta" runat="server" TextMode="MultiLine" Rows="4"
                                CssClass="cl-modal-notes form-control border-0 p-3"
                                placeholder="Ingrese hallazgos clínicos, TA (mmHg), FC, auscultación cardíaca y conclusiones del ECG..."></asp:TextBox>
                        </div>

                        <div class="d-flex align-items-center gap-2 flex-wrap">
                            <asp:LinkButton ID="btnVerHCCompleta" runat="server" OnClick="btnVerHCCompleta_Click"
                                CssClass="cl-text-13 btn btn-cl-secondary py-1 px-3 d-flex align-items-center gap-1">
                                <i class="bi bi-folder2-open"></i> Ver HC completa
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnCargarECG" runat="server" OnClick="btnCargarECG_Click"
                                CssClass="cl-text-13 btn btn-cl-secondary py-1 px-3 d-flex align-items-center gap-1">
                                <i class="bi bi-activity"></i> Cargar trazo ECG
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnRecetaDigital" runat="server" OnClick="btnRecetaDigital_Click"
                                CssClass="cl-text-13 btn btn-cl-secondary py-1 px-3 d-flex align-items-center gap-1">
                                <i class="bi bi-prescription2"></i> Receta digital
                            </asp:LinkButton>
                        </div>
                    </div>

                    <div class="cl-modal-footer modal-footer d-flex align-items-center justify-content-between p-3 px-4">
                        <button type="button" class="btn btn-cl-secondary px-3 py-2" data-bs-dismiss="modal">Cancelar</button>
                        <div class="d-flex align-items-center gap-2">
                            <asp:LinkButton ID="btnLlamarPantalla" runat="server" OnClick="btnLlamarPantalla_Click"
                                CssClass="btn btn-cl-secondary px-3 py-2 d-flex align-items-center gap-2">
                                <i class="bi bi-megaphone"></i>
                                <span>Llamar por pantalla</span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnIniciarConsulta" runat="server" OnClick="btnIniciarConsulta_Click"
                                CssClass="btn btn-cl-primary px-4 py-2 d-flex align-items-center gap-2 shadow-sm">
                                <i class="bi bi-play-fill"></i>
                                <span>Iniciar Consulta</span>
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/mis-turnos.js") %>'></script>
</asp:Content>
