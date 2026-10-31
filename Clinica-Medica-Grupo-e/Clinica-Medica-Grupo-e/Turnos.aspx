<%@ Page Title="Turnos - Gestión de Turnos" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="Turnos.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Turnos" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Mensaje de error (por ejemplo, si la base de datos no responde) -->
    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-warning d-flex align-items-center gap-2 mb-4">
        <span class="material-symbols-outlined">warning</span>
        <asp:Label ID="lblError" runat="server"></asp:Label>
    </asp:Panel>

    <!-- ===================== 1. ENCABEZADO ===================== -->
    <div class="d-flex flex-column gap-4 mb-4">
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
            <div>
                <div class="d-flex align-items-center gap-1 mb-1">
                    <span class="page-tag badge text-uppercase fw-semibold">Módulo Operativo</span>
                    <span class="text-muted fs-11">•</span>
                    <span class="text-muted fw-semibold fs-12">Consultorios Externos</span>
                </div>
                <h1 class="page-title h3 fw-bold text-dark mb-1">Gestión y Listado Integral de Turnos Médicos</h1>
                <p class="text-muted mb-0 fs-14">Control operativo de citaciones, reprogramaciones y trazabilidad asistencial en consultorios externos.</p>
            </div>
            <div class="no-print d-flex align-items-center gap-2 flex-wrap">
                <%-- Imprimir es solo del navegador, no necesita PostBack --%>
                <button type="button" class="btn-print btn btn-outline-secondary d-flex align-items-center gap-2 bg-white text-dark shadow-sm px-3 py-2 fw-medium" onclick="window.print();">
                    <span class="material-symbols-outlined text-cl-primary">print</span>
                    <span>Imprimir listado del día</span>
                </button>
                <asp:HyperLink ID="lnkNuevoTurno" runat="server" NavigateUrl="~/NuevoTurno.aspx"
                    CssClass="btn btn-teal d-flex align-items-center gap-2 shadow-sm px-3 py-2 fw-semibold">
                    <span class="material-symbols-outlined">add</span>
                    <span>Nuevo turno</span>
                </asp:HyperLink>
            </div>
        </div>

        <!-- Métricas -->
        <div class="row g-3">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card-custom p-3 p-xl-4 h-100 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="metric-label text-muted fw-medium d-block">Total programados hoy</span>
                        <div class="d-flex align-items-baseline gap-2 mt-1">
                            <asp:Label ID="lblMetricaTotal" runat="server" CssClass="fs-2 fw-bold text-dark lh-1" Text="48"></asp:Label>
                            <asp:Label ID="lblMetricaCupo" runat="server" CssClass="metric-badge metric-badge-teal badge" Text="100% cupo"></asp:Label>
                        </div>
                        <asp:Label ID="lblMetricaEspecialidades" runat="server" CssClass="metric-note text-muted d-block mt-2" Text="6 especialidades activas"></asp:Label>
                    </div>
                    <div class="metric-icon-box metric-icon-teal">
                        <span class="material-symbols-outlined fs-3">calendar_month</span>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card-custom p-3 p-xl-4 h-100 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="metric-label text-muted fw-medium d-block">En espera / Nuevos</span>
                        <div class="d-flex align-items-baseline gap-2 mt-1">
                            <asp:Label ID="lblMetricaEspera" runat="server" CssClass="fs-2 fw-bold text-dark lh-1" Text="14"></asp:Label>
                            <asp:Label ID="lblMetricaEsperaPorcentaje" runat="server" CssClass="metric-badge metric-badge-blue badge" Text="29.1%"></asp:Label>
                        </div>
                        <span class="metric-note text-muted d-block mt-2">Pacientes en sala o por llegar</span>
                    </div>
                    <div class="metric-icon-box metric-icon-blue">
                        <span class="material-symbols-outlined fs-3">schedule</span>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card-custom p-3 p-xl-4 h-100 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="metric-label text-muted fw-medium d-block">Atendidos / Cerrados</span>
                        <div class="d-flex align-items-baseline gap-2 mt-1">
                            <asp:Label ID="lblMetricaAtendidos" runat="server" CssClass="fs-2 fw-bold text-dark lh-1" Text="26"></asp:Label>
                            <asp:Label ID="lblMetricaAtendidosPorcentaje" runat="server" CssClass="metric-badge metric-badge-emerald badge" Text="54.2%"></asp:Label>
                        </div>
                        <span class="metric-note text-muted d-block mt-2">Consultas finalizadas</span>
                    </div>
                    <div class="metric-icon-box metric-icon-emerald">
                        <span class="material-symbols-outlined fs-3">check_circle</span>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card-custom p-3 p-xl-4 h-100 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="metric-label text-muted fw-medium d-block">Reprog. / Cancelados</span>
                        <div class="d-flex align-items-baseline gap-2 mt-1">
                            <asp:Label ID="lblMetricaReprogCancel" runat="server" CssClass="fs-2 fw-bold text-dark lh-1" Text="8"></asp:Label>
                            <div class="d-inline-flex gap-1">
                                <asp:Label ID="lblMetricaReprogramados" runat="server" CssClass="metric-badge metric-badge-amber badge" Text="5 R"></asp:Label>
                                <asp:Label ID="lblMetricaCancelados" runat="server" CssClass="metric-badge metric-badge-red badge" Text="3 C"></asp:Label>
                            </div>
                        </div>
                        <span class="metric-note text-muted d-block mt-2">Cupos liberados hoy</span>
                    </div>
                    <div class="metric-icon-box metric-icon-amber">
                        <span class="material-symbols-outlined fs-3">sync_problem</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===================== 2. FILTROS ===================== -->
    <asp:Panel ID="pnlFiltros" runat="server" DefaultButton="btnBuscarTurnos" CssClass="no-print card-custom p-4 mb-4">
        <div class="d-flex align-items-center justify-content-between mb-3 pb-1">
            <div class="d-flex align-items-center gap-2">
                <span class="material-symbols-outlined text-cl-primary">filter_alt</span>
                <span class="filter-title fw-semibold text-dark">Búsqueda avanzada y filtros de agenda</span>
            </div>
            <span class="text-muted fs-13">Mostrando agenda clínica activa</span>
        </div>

        <div class="row g-3">
            <div class="col-12 col-md-6 col-lg-4 col-xl-2">
                <asp:Label ID="lblFiltroDesde" runat="server" AssociatedControlID="txtFechaDesde" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Fecha desde"></asp:Label>
                <asp:TextBox ID="txtFechaDesde" runat="server" TextMode="Date" CssClass="filter-input form-control form-control-sm"></asp:TextBox>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-2">
                <asp:Label ID="lblFiltroHasta" runat="server" AssociatedControlID="txtFechaHasta" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Fecha hasta"></asp:Label>
                <asp:TextBox ID="txtFechaHasta" runat="server" TextMode="Date" CssClass="filter-input form-control form-control-sm"></asp:TextBox>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-2">
                <asp:Label ID="lblFiltroMedico" runat="server" AssociatedControlID="ddlMedico" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Médico / Profesional"></asp:Label>
                <%-- Se carga desde la base; AppendDataBoundItems mantiene la opción "Todos" --%>
                <asp:DropDownList ID="ddlMedico" runat="server" AppendDataBoundItems="true" CssClass="filter-input form-select form-select-sm">
                    <asp:ListItem Value="0" Text="Todos los médicos"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-2">
                <asp:Label ID="lblFiltroEspecialidad" runat="server" AssociatedControlID="ddlEspecialidad" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Especialidad"></asp:Label>
                <asp:DropDownList ID="ddlEspecialidad" runat="server" AppendDataBoundItems="true" CssClass="filter-input form-select form-select-sm">
                    <asp:ListItem Value="0" Text="Todas las especialidades"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-2">
                <asp:Label ID="lblFiltroPaciente" runat="server" AssociatedControlID="txtPaciente" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Paciente (DNI o apellido)"></asp:Label>
                <asp:TextBox ID="txtPaciente" runat="server" CssClass="filter-input form-control form-control-sm" placeholder="Ej: 34.892 o López"></asp:TextBox>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-1">
                <asp:Label ID="lblFiltroEstado" runat="server" AssociatedControlID="ddlEstado" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Estado"></asp:Label>
                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="filter-input form-select form-select-sm">
                    <asp:ListItem Value="" Text="Todos"></asp:ListItem>
                    <asp:ListItem Value="nuevo" Text="Nuevo"></asp:ListItem>
                    <asp:ListItem Value="reprogramado" Text="Reprogramado"></asp:ListItem>
                    <asp:ListItem Value="cerrado" Text="Cerrado / Atendido"></asp:ListItem>
                    <asp:ListItem Value="noasistio" Text="No asistió"></asp:ListItem>
                    <asp:ListItem Value="cancelado" Text="Cancelado"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-12 col-md-6 col-lg-4 col-xl-1">
                <asp:Label ID="lblFiltroNumero" runat="server" AssociatedControlID="txtNumeroTurno" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="N° de turno"></asp:Label>
                <asp:TextBox ID="txtNumeroTurno" runat="server" CssClass="filter-input form-control form-control-sm" placeholder="Ej: 1001"></asp:TextBox>
            </div>
        </div>

        <div class="d-flex align-items-center justify-content-end gap-2 mt-3 pt-2">
            <asp:LinkButton ID="btnLimpiarFiltros" runat="server" OnClick="btnLimpiarFiltros_Click"
                CssClass="btn-limpiar btn btn-light d-flex align-items-center gap-1 border text-secondary px-3">
                <span class="material-symbols-outlined icon-18">restart_alt</span>
                <span>Limpiar filtros</span>
            </asp:LinkButton>
            <asp:LinkButton ID="btnBuscarTurnos" runat="server" OnClick="btnBuscarTurnos_Click"
                CssClass="btn btn-teal d-flex align-items-center gap-1 px-4 fw-semibold shadow-sm fs-13">
                <span class="material-symbols-outlined icon-18">search</span>
                <span>Buscar turnos</span>
            </asp:LinkButton>
        </div>
    </asp:Panel>

    <!-- ===================== 3. TABLA DE TURNOS ===================== -->
    <div class="card-custom overflow-hidden mb-4">
        <div class="table-responsive">
            <%--
                Campos esperados en el DataSource (un ítem por turno):
                  IdTurno, NumeroTurno ("#1001"), FechaHora ("24/05/2025 • 16:00 hs"),
                  Subtexto (turno de trabajo del médico, o "Cupo liberado" si está cancelado),
                  PacienteNombre, PacienteDni, Contacto (teléfono o email), MedicoNombre, MedicoMatricula, Especialidad,
                  EstadoTexto, EstadoCss (badge-estado-nuevo | -cerrado | -reprogramado | -no-asistio | -cancelado),
                  EstadoIcono (Material Symbols: fiber_new | check_circle | history | person_off | cancel),
                  FilaCss ("" | row-inactivo | row-cancelado),
                  PuedeReprogramar (bool), PuedeCancelar (bool)
            --%>
            <asp:Repeater ID="rptTurnos" runat="server" OnItemCommand="rptTurnos_ItemCommand">
                <HeaderTemplate>
                    <table class="table-gestion table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th scope="col" class="py-3 px-3">N° Turno</th>
                                <th scope="col" class="py-3 px-3">Fecha y Hora</th>
                                <th scope="col" class="py-3 px-3">Paciente &amp; Contacto</th>
                                <th scope="col" class="py-3 px-3">Médico &amp; Matrícula</th>
                                <th scope="col" class="py-3 px-3">Especialidad</th>
                                <th scope="col" class="py-3 px-3 text-center">Estado</th>
                                <th scope="col" class="py-3 px-3 text-end no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr class='<%# Eval("FilaCss") %>'>
                                <td class="py-3 px-3">
                                    <span class="turno-numero font-monospace fw-semibold bg-light px-2 py-1 rounded text-nowrap"><%#: Eval("NumeroTurno") %></span>
                                </td>
                                <td class="py-3 px-3">
                                    <div class="turno-fecha fw-semibold text-dark"><%#: Eval("FechaHora") %></div>
                                    <div class="turno-subtexto text-muted"><%#: Eval("Subtexto") %></div>
                                </td>
                                <td class="py-3 px-3">
                                    <div class="fw-semibold text-dark"><%#: Eval("PacienteNombre") %></div>
                                    <div class="text-muted fs-12">DNI <%#: Eval("PacienteDni") %> • <span class="fw-medium text-cl-primary"><%#: Eval("Contacto") %></span></div>
                                </td>
                                <td class="py-3 px-3">
                                    <div class="fw-medium text-dark"><%#: Eval("MedicoNombre") %></div>
                                    <div class="text-muted fs-12"><%#: Eval("MedicoMatricula") %></div>
                                </td>
                                <td class="py-3 px-3">
                                    <span class="especialidad-pill badge rounded-pill px-2 py-1">
                                        <span class="especialidad-dot d-inline-block rounded-circle me-1"></span>
                                        <%#: Eval("Especialidad") %>
                                    </span>
                                </td>
                                <td class="py-3 px-3 text-center">
                                    <span class='badge-estado <%# Eval("EstadoCss") %>'>
                                        <span class="material-symbols-outlined icon-16"><%#: Eval("EstadoIcono") %></span>
                                        <%#: Eval("EstadoTexto") %>
                                    </span>
                                </td>
                                <td class="py-3 px-3 text-end text-nowrap no-print">
                                    <asp:LinkButton ID="btnVerDetalle" runat="server" CssClass="btn-row-action btn-row-ver" ToolTip="Ver ficha y trazabilidad"
                                        CommandName="VerDetalle" CommandArgument='<%# Eval("IdTurno") %>'>
                                        <span class="material-symbols-outlined">visibility</span>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnReprogramar" runat="server" CssClass="btn-row-action btn-row-reprogramar" ToolTip="Reprogramar turno"
                                        CommandName="Reprogramar" CommandArgument='<%# Eval("IdTurno") %>' Enabled='<%# (bool)Eval("PuedeReprogramar") %>'>
                                        <span class="material-symbols-outlined">event_repeat</span>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnCancelar" runat="server" CssClass="btn-row-action btn-row-cancelar" ToolTip="Cancelar turno"
                                        CommandName="Cancelar" CommandArgument='<%# Eval("IdTurno") %>' Enabled='<%# (bool)Eval("PuedeCancelar") %>'>
                                        <span class="material-symbols-outlined">event_busy</span>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false" CssClass="text-center text-muted fs-14 py-4">
                No se encontraron turnos con los filtros seleccionados.
            </asp:Panel>
        </div>

        <!-- Paginación -->
        <div class="table-gestion-footer no-print p-3 bg-white border-top d-flex flex-column flex-sm-row align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3 text-muted">
                <span>
                    Mostrando <asp:Label ID="lblRangoMostrado" runat="server" CssClass="fw-bold text-dark" Text="1 - 10"></asp:Label>
                    de <asp:Label ID="lblTotalRegistros" runat="server" CssClass="fw-bold text-dark" Text="142"></asp:Label>
                    turnos registrados
                </span>
                <div class="d-flex align-items-center gap-1">
                    <asp:Label ID="lblPorPagina" runat="server" AssociatedControlID="ddlPorPagina" CssClass="text-muted" Text="Por página:"></asp:Label>
                    <asp:DropDownList ID="ddlPorPagina" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPorPagina_SelectedIndexChanged"
                        CssClass="select-filas form-select form-select-sm py-0 ps-2 pe-4">
                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                        <asp:ListItem Value="25" Text="25"></asp:ListItem>
                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="d-flex align-items-center gap-1">
                <asp:LinkButton ID="btnPaginaAnterior" runat="server" OnClick="btnPaginaAnterior_Click" CssClass="btn-page text-secondary" ToolTip="Página anterior">
                    <span class="material-symbols-outlined icon-18">chevron_left</span>
                </asp:LinkButton>
                <%-- Campos esperados: Numero, Css ("" | active) --%>
                <asp:Repeater ID="rptPaginas" runat="server" OnItemCommand="rptPaginas_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkPagina" runat="server" CssClass='<%# "btn-page border " + Eval("Css") %>'
                            CommandName="IrAPagina" CommandArgument='<%# Eval("Numero") %>' Text='<%# Eval("Numero") %>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:LinkButton ID="btnPaginaSiguiente" runat="server" OnClick="btnPaginaSiguiente_Click" CssClass="btn-page" ToolTip="Página siguiente">
                    <span class="material-symbols-outlined icon-18">chevron_right</span>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- ===================== MODAL: CANCELAR TURNO ===================== -->
    <%-- Se abre desde el code-behind al presionar "Cancelar" en una fila (ver Turnos.aspx.cs) --%>
    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-labelledby="modalCancelarLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-3">

                <div class="modal-header border-bottom-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon-circle modal-icon-danger rounded-circle d-flex align-items-center justify-content-center">
                            <span class="material-symbols-outlined">warning</span>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold text-dark mb-0" id="modalCancelarLabel">Cancelar Turno Médico</h5>
                            <span class="text-muted fs-12">Acción irrevocable • Liberación de cupo</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body py-3">
                    <asp:HiddenField ID="hfIdTurnoCancelar" runat="server" />

                    <div class="p-3 bg-light rounded-3 mb-3">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="modal-codigo font-monospace fw-bold bg-white px-2 rounded border">
                                Código: <asp:Label ID="lblCancelarCodigo" runat="server" Text="T-2025-000123"></asp:Label>
                            </span>
                            <asp:Label ID="lblCancelarEstado" runat="server" CssClass="badge-estado badge-estado-nuevo" Text="Nuevo"></asp:Label>
                        </div>
                        <div class="row g-2 mb-2 fs-13">
                            <div class="col-6">
                                <span class="text-muted d-block">Paciente:</span>
                                <asp:Label ID="lblCancelarPaciente" runat="server" CssClass="fw-bold text-dark d-block" Text="Juan Ignacio López"></asp:Label>
                                <asp:Label ID="lblCancelarPacienteDetalle" runat="server" CssClass="text-muted fs-12" Text="DNI 34.892.104 • OSDE 310"></asp:Label>
                            </div>
                            <div class="col-6">
                                <span class="text-muted d-block">Profesional:</span>
                                <asp:Label ID="lblCancelarMedico" runat="server" CssClass="fw-bold text-dark d-block" Text="Dr. Gómez Rossi, Alejandro"></asp:Label>
                                <asp:Label ID="lblCancelarMedicoDetalle" runat="server" CssClass="text-muted fs-12" Text="Dermatología • Cons. 04"></asp:Label>
                            </div>
                        </div>
                        <div class="pt-2 border-top fs-13">
                            <span class="text-muted">Fecha y hora citada: </span>
                            <asp:Label ID="lblCancelarFecha" runat="server" CssClass="fw-bold text-dark" Text="Sábado 24 de mayo 2025 - 16:00 hs"></asp:Label>
                        </div>
                    </div>

                    <div class="modal-aviso d-flex align-items-start gap-2 p-3 rounded-2 mb-3">
                        <span class="material-symbols-outlined">info</span>
                        <div>Al cancelar este turno se liberará automáticamente el cupo en la agenda médica y se notificará al paciente por correo electrónico.</div>
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblMotivoCancelacion" runat="server" AssociatedControlID="txtMotivoCancelacion" CssClass="form-label fw-semibold text-dark mb-1 fs-13">
                            Motivo de cancelación <span class="text-danger">*</span>
                        </asp:Label>
                        <asp:TextBox ID="txtMotivoCancelacion" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control fs-13"></asp:TextBox>
                        <span class="text-muted d-block mt-1 fs-12">Este motivo quedará asentado en el historial de trazabilidad del paciente.</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <asp:CheckBox ID="chkNotificarPaciente" runat="server" Checked="true" CssClass="chk-teal" />
                        <asp:Label ID="lblNotificarPaciente" runat="server" AssociatedControlID="chkNotificarPaciente" CssClass="text-dark fs-13 mb-0" Text="Notificar al paciente por email de inmediato"></asp:Label>
                    </div>
                </div>

                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-light border text-secondary px-3 py-2 fw-medium fs-14" data-bs-dismiss="modal">Volver</button>
                    <asp:LinkButton ID="btnConfirmarCancelacion" runat="server" OnClick="btnConfirmarCancelacion_Click"
                        CssClass="btn btn-danger d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold shadow-sm fs-14">
                        <span class="material-symbols-outlined">check</span>
                        <span>Confirmar cancelación</span>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <!-- ===================== MODAL: DETALLE Y TRAZABILIDAD ===================== -->
    <%-- Se abre desde el code-behind al presionar "Ver" en una fila (ver Turnos.aspx.cs) --%>
    <div class="modal fade" id="modalDetalle" tabindex="-1" aria-labelledby="modalDetalleLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-3">

                <div class="modal-header border-bottom-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon-circle modal-icon-teal rounded-circle d-flex align-items-center justify-content-center">
                            <span class="material-symbols-outlined">clinical_notes</span>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 flex-wrap">
                                <h5 class="modal-title fw-bold text-dark mb-0" id="modalDetalleLabel">
                                    Ficha Completa de Turno #<asp:Label ID="lblDetalleNumero" runat="server" Text="T-2025-000125"></asp:Label>
                                </h5>
                                <asp:Label ID="lblDetalleEstado" runat="server" CssClass="badge-estado badge-estado-reprogramado" Text="Reprogramado"></asp:Label>
                            </div>
                            <span class="text-muted fs-12">Registro auditable • Historial de movimientos del turno</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body py-3">
                    <div class="p-3 bg-light rounded-3 mb-4">
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <span class="modal-section-label text-muted text-uppercase fw-semibold d-block mb-1">Información del paciente</span>
                                <asp:Label ID="lblDetallePaciente" runat="server" CssClass="modal-nombre fw-bold text-dark d-block" Text="Laura Beatriz Martínez"></asp:Label>
                                <div class="modal-datos text-muted mt-1">
                                    <div>DNI: <asp:Label ID="lblDetalleDni" runat="server" CssClass="fw-bold text-dark" Text="32.115.420"></asp:Label></div>
                                    <div>Teléfono: <asp:Label ID="lblDetalleTelefono" runat="server" Text="+54 11 4892-1104"></asp:Label></div>
                                    <div>Email: <asp:Label ID="lblDetalleEmail" runat="server" Text="l.martinez@gmail.com"></asp:Label></div>
                                    <div>Dirección: <asp:Label ID="lblDetalleDireccion" runat="server" Text="Av. San Martín 123"></asp:Label></div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <span class="modal-section-label text-muted text-uppercase fw-semibold d-block mb-1">Asignación profesional</span>
                                <asp:Label ID="lblDetalleMedico" runat="server" CssClass="modal-nombre fw-bold text-dark d-block" Text="Dra. Sofía Albarracín"></asp:Label>
                                <div class="modal-datos text-muted mt-1">
                                    <div>Matrícula: <asp:Label ID="lblDetalleMatricula" runat="server" Text="MN 120.441"></asp:Label></div>
                                    <div>Especialidad: <asp:Label ID="lblDetalleEspecialidad" runat="server" Text="Ginecología"></asp:Label></div>
                                    <div>Turno de trabajo: <asp:Label ID="lblDetalleTurnoTrabajo" runat="server" Text="Mañana (08:00 a 14:00 hs)"></asp:Label></div>
                                    <div>Fecha y hora: <asp:Label ID="lblDetalleFechaHora" runat="server" CssClass="fw-bold text-dark" Text="24/05/2025 • 11:15 hs"></asp:Label></div>
                                </div>
                            </div>
                            <div class="col-12 pt-2 border-top">
                                <span class="modal-section-label text-muted text-uppercase fw-semibold d-block">Motivo de la consulta</span>
                                <asp:Label ID="lblDetalleMotivo" runat="server" CssClass="text-dark d-block mt-1 fs-13" Text="Control anual ginecológico y evaluación de resultados de ecografía mamaria."></asp:Label>
                            </div>
                        </div>
                    </div>

                    <%-- La base todavía no tiene una tabla de historial de movimientos:
                         esta sección queda oculta hasta que exista (phHistorial.Visible = true). --%>
                    <asp:PlaceHolder ID="phHistorial" runat="server" Visible="false">
                    <div class="mb-3">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <span class="material-symbols-outlined text-cl-primary">timeline</span>
                            <span class="fw-bold text-dark fs-14">Línea de tiempo del historial de movimientos</span>
                        </div>
                        <%--
                            Campos esperados (un ítem por movimiento):
                              Titulo, FechaHora, Operador, OperadorDetalle (rol o área), Comentario,
                              Icono (Material Symbols: add | sync | mail | cancel...), DotCss (bg-primary | bg-warning text-dark | bg-success | bg-danger)
                        --%>
                        <div class="timeline">
                            <div class="timeline-line"></div>
                            <asp:Repeater ID="rptHistorial" runat="server">
                                <ItemTemplate>
                                    <div class="timeline-item position-relative mb-3">
                                        <div class='timeline-dot <%# Eval("DotCss") %>'>
                                            <span class="material-symbols-outlined"><%#: Eval("Icono") %></span>
                                        </div>
                                        <div class="bg-white border p-3 rounded-2 shadow-sm">
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <strong class="text-dark fs-13"><%#: Eval("Titulo") %></strong>
                                                <span class="font-monospace text-muted fs-12"><%#: Eval("FechaHora") %></span>
                                            </div>
                                            <div class="text-muted fs-12">Operador: <strong class="text-dark"><%#: Eval("Operador") %></strong> (<%#: Eval("OperadorDetalle") %>)</div>
                                            <div class="fst-italic text-muted mt-1 fs-12"><%#: Eval("Comentario") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    </asp:PlaceHolder>
                </div>

                <div class="modal-footer border-top-0 pt-0 d-flex justify-content-between">
                    <button type="button" class="btn btn-light border text-cl-primary d-inline-flex align-items-center gap-2 px-3 py-2 fw-medium fs-14" onclick="window.print();">
                        <span class="material-symbols-outlined">print</span>
                        <span>Imprimir ficha de turno</span>
                    </button>
                    <button type="button" class="btn btn-teal px-4 py-2 fw-semibold shadow-sm" data-bs-dismiss="modal">Cerrar detalle</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/turnos.js") %>'></script>
</asp:Content>
