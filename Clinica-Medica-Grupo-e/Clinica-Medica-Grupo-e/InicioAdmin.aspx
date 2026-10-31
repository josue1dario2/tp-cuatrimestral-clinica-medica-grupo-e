<%@ Page Title="Inicio - Gestión de Turnos" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="InicioAdmin.aspx.cs" Inherits="vista.InicioAdmin" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column gap-4">

        <!-- ===================== 1. BIENVENIDA ===================== -->
        <section class="card-custom p-4 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
            <div class="d-flex flex-column">
                <div class="d-flex align-items-center gap-2">
                    <h1 class="fs-24 fw-semibold text-dark mb-0 tracking-tight">
                        <asp:Label ID="lblSaludo" runat="server" Text="Buenos días, María"></asp:Label>
                    </h1>
                    <asp:Label ID="lblSede" runat="server" CssClass="chip-soft badge rounded-pill px-2 py-1 fw-normal fs-11" Text="Sede Central"></asp:Label>
                </div>
                <p class="fs-14 text-cl-secondary mb-0 mt-1 d-flex align-items-center gap-2 flex-wrap">
                    <span class="material-symbols-outlined icon-18 text-cl-primary">event_available</span>
                    <asp:Label ID="lblFechaLarga" runat="server" Text="Lunes 24 de octubre de 2025"></asp:Label>
                    •
                    <asp:Label ID="lblTurnoNombre" runat="server" CssClass="fw-semibold text-dark" Text="Turno Mañana"></asp:Label>
                    <asp:Label ID="lblTurnoHorario" runat="server" Text="(08:00 - 14:00 hs)"></asp:Label>
                </p>
            </div>
            <div class="d-flex align-items-center gap-3 flex-wrap">
                <div class="bg-cl-low d-flex align-items-center gap-2 px-3 py-2 rounded-3">
                    <div class="pulse-dot-wrapper">
                        <span class="pulse-dot-ping"></span>
                        <span class="pulse-dot-core"></span>
                    </div>
                    <asp:Label ID="lblEstadoRecepcion" runat="server" CssClass="fw-semibold text-dark fs-14" Text="Recepción Activa"></asp:Label>
                    <asp:Label ID="lblBox" runat="server" CssClass="chip-soft-strong badge rounded-pill px-2 py-1 fs-11" Text="Box 02"></asp:Label>
                </div>
                <asp:LinkButton ID="btnCambiarFecha" runat="server" OnClick="btnCambiarFecha_Click"
                    CssClass="btn-soft-outline btn d-flex align-items-center gap-2 px-3 py-2 rounded-3">
                    <span class="material-symbols-outlined icon-18">calendar_today</span>
                    <span>Cambiar Fecha</span>
                </asp:LinkButton>
            </div>
        </section>

        <!-- ===================== 2. ACCESOS RÁPIDOS ===================== -->
        <section class="row g-3">
            <div class="col-12 col-sm-6 col-lg-3">
                <asp:HyperLink ID="lnkNuevoTurno" runat="server" NavigateUrl="~/NuevoTurno.aspx" CssClass="card-quick-action card-quick-action-primary w-100">
                    <div class="icon-box icon-box-48 icon-box-white rounded-3">
                        <span class="material-symbols-outlined icon-28">add_circle</span>
                    </div>
                    <div class="d-flex flex-column min-w-0 flex-grow-1">
                        <span class="fs-16 fw-semibold text-white">Nuevo Turno</span>
                        <span class="fs-12 text-white-50 text-truncate mt-1">Asignar consulta médica</span>
                    </div>
                    <span class="material-symbols-outlined text-white-50">arrow_forward</span>
                </asp:HyperLink>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <asp:HyperLink ID="lnkBuscarPaciente" runat="server" NavigateUrl="~/Pacientes.aspx" CssClass="card-quick-action w-100">
                    <div class="icon-box icon-box-48 icon-box-blue rounded-3">
                        <span class="material-symbols-outlined icon-26">person_search</span>
                    </div>
                    <div class="d-flex flex-column min-w-0 flex-grow-1">
                        <span class="fs-16 fw-semibold text-dark">Buscar Paciente</span>
                        <span class="fs-12 text-secondary text-truncate mt-1">Historial y DNI</span>
                    </div>
                    <span class="material-symbols-outlined text-secondary">chevron_right</span>
                </asp:HyperLink>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <asp:HyperLink ID="lnkVerTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="card-quick-action w-100">
                    <div class="icon-box icon-box-48 icon-box-high rounded-3">
                        <span class="material-symbols-outlined icon-26">calendar_month</span>
                    </div>
                    <div class="d-flex flex-column min-w-0 flex-grow-1">
                        <span class="fs-16 fw-semibold text-dark">Ver Turnos</span>
                        <span class="fs-12 text-secondary text-truncate mt-1">Grilla semanal y salas</span>
                    </div>
                    <span class="material-symbols-outlined text-secondary">chevron_right</span>
                </asp:HyperLink>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <asp:LinkButton ID="btnRecepcionCheckin" runat="server" OnClick="btnRecepcionCheckin_Click" CssClass="card-quick-action w-100">
                    <div class="icon-box icon-box-48 icon-box-green rounded-3">
                        <span class="material-symbols-outlined icon-26">how_to_reg</span>
                    </div>
                    <div class="d-flex flex-column min-w-0 flex-grow-1">
                        <span class="fs-16 fw-semibold text-dark">Recepción / Check-in</span>
                        <span class="fs-12 text-secondary text-truncate mt-1">Marcar ingreso en sala</span>
                    </div>
                    <span class="material-symbols-outlined text-secondary">chevron_right</span>
                </asp:LinkButton>
            </div>
        </section>

        <!-- ===================== 3. INDICADORES DEL DÍA ===================== -->
        <section class="row g-3">

            <!-- Turnos de hoy -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 d-flex flex-column justify-content-between h-100">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="d-flex flex-column">
                            <span class="kpi-label text-uppercase fw-semibold text-secondary">Turnos de hoy</span>
                            <asp:Label ID="lblKpiTurnosHoy" runat="server" CssClass="kpi-value fw-semibold text-dark tracking-tight mt-1" Text="42"></asp:Label>
                        </div>
                        <div class="icon-box icon-box-40 icon-box-teal rounded-3">
                            <span class="material-symbols-outlined icon-22">calendar_today</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-2 d-flex align-items-center justify-content-between">
                        <div class="kpi-foot d-flex align-items-center gap-1 text-cl-success">
                            <span class="material-symbols-outlined icon-16">trending_up</span>
                            <asp:Label ID="lblKpiVariacion" runat="server" Text="+4 respecto a ayer"></asp:Label>
                        </div>
                        <svg class="kpi-sparkline flex-shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 64 24">
                            <path d="M2 18 L16 14 L30 17 L44 9 L62 4" stroke-linecap="round" stroke-linejoin="round"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Pendientes -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 d-flex flex-column justify-content-between h-100">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="d-flex flex-column">
                            <span class="kpi-label text-uppercase fw-semibold text-secondary">Pendientes</span>
                            <asp:Label ID="lblKpiPendientes" runat="server" CssClass="kpi-value fw-semibold text-dark tracking-tight mt-1" Text="14"></asp:Label>
                        </div>
                        <div class="icon-box icon-box-40 icon-box-blue rounded-3">
                            <span class="material-symbols-outlined icon-22">schedule</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-2 d-flex align-items-center justify-content-between">
                        <div class="kpi-foot d-flex align-items-center gap-1 text-secondary">
                            <span class="material-symbols-outlined icon-16">hourglass_top</span>
                            <span>En sala o por llegar</span>
                        </div>
                        <div class="kpi-progress rounded-pill overflow-hidden">
                            <%-- El ancho se asigna desde el code-behind: pnlBarraPendientes.Style["width"] = "33%"; --%>
                            <asp:Panel ID="pnlBarraPendientes" runat="server" CssClass="kpi-progress-bar rounded-pill" Style="width: 33%;"></asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cancelados hoy -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 d-flex flex-column justify-content-between h-100">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="d-flex flex-column">
                            <span class="kpi-label text-uppercase fw-semibold text-secondary">Cancelados hoy</span>
                            <asp:Label ID="lblKpiCancelados" runat="server" CssClass="kpi-value fw-semibold tracking-tight mt-1 text-danger" Text="3"></asp:Label>
                        </div>
                        <div class="icon-box icon-box-40 icon-box-red rounded-3">
                            <span class="material-symbols-outlined icon-22">event_busy</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-2 d-flex align-items-center justify-content-between">
                        <div class="kpi-foot d-flex align-items-center gap-1 text-secondary">
                            <span class="material-symbols-outlined icon-16 text-danger">info</span>
                            <asp:Label ID="lblKpiCanceladosAviso" runat="server" Text="2 con aviso previo"></asp:Label>
                        </div>
                        <asp:Label ID="lblKpiCanceladosPorcentaje" runat="server" CssClass="kpi-badge-danger badge rounded-pill fw-semibold" Text="7.1%"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Pacientes atendidos -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-4 d-flex flex-column justify-content-between h-100">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="d-flex flex-column">
                            <span class="kpi-label text-uppercase fw-semibold text-secondary">Pacientes atendidos</span>
                            <asp:Label ID="lblKpiAtendidos" runat="server" CssClass="kpi-value fw-semibold tracking-tight mt-1 text-cl-success" Text="25"></asp:Label>
                        </div>
                        <div class="icon-box icon-box-40 icon-box-green rounded-3">
                            <span class="material-symbols-outlined icon-22">check_circle</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-2 d-flex align-items-center justify-content-between">
                        <div class="kpi-foot d-flex align-items-center gap-1 text-cl-success">
                            <span class="material-symbols-outlined icon-16">task_alt</span>
                            <asp:Label ID="lblKpiAtendidosPorcentaje" runat="server" Text="59% del total diario"></asp:Label>
                        </div>
                        <%-- Anillo decorativo: stroke-dashoffset = 88 - (88 * porcentaje / 100) --%>
                        <svg class="kpi-donut flex-shrink-0" viewBox="0 0 36 36">
                            <circle class="kpi-donut-track" cx="18" cy="18" r="14" fill="none" stroke="currentColor" stroke-width="4"></circle>
                            <circle cx="18" cy="18" r="14" fill="none" stroke="currentColor" stroke-width="4" stroke-dasharray="88" stroke-dashoffset="36" stroke-linecap="round"></circle>
                        </svg>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===================== 4. TURNOS DE HOY ===================== -->
        <section class="card-custom">

            <!-- Título, contador y filtros -->
            <div class="p-4 d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
                <div class="d-flex flex-column flex-sm-row align-items-sm-center gap-2 gap-sm-3">
                    <div class="d-flex align-items-center gap-2">
                        <div class="icon-box icon-box-32 icon-box-low rounded-3">
                            <span class="material-symbols-outlined">view_timeline</span>
                        </div>
                        <h2 class="fs-20 fw-semibold text-dark mb-0">Turnos de hoy</h2>
                    </div>
                    <span class="chip-soft badge rounded-pill px-3 py-2 fw-medium fs-13">
                        Mostrando
                        <asp:Label ID="lblCantidadMostrada" runat="server" CssClass="fw-bold text-dark mx-1" Text="8"></asp:Label>
                        de
                        <asp:Label ID="lblCantidadTotal" runat="server" Text="42"></asp:Label>
                        turnos
                    </span>
                </div>

                <asp:Panel ID="pnlFiltros" runat="server" DefaultButton="btnRefrescar" CssClass="d-flex flex-wrap align-items-center gap-2">
                    <div class="search-wrapper position-relative">
                        <span class="search-icon material-symbols-outlined icon-18 position-absolute text-secondary">search</span>
                        <asp:TextBox ID="txtBuscarTabla" runat="server" CssClass="form-control-custom w-100 ps-5" placeholder="Buscar por DNI o apellido..."></asp:TextBox>
                    </div>
                    <asp:DropDownList ID="ddlEstado" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged" CssClass="form-select-custom pe-4">
                        <asp:ListItem Value="todos" Text="Todos los estados"></asp:ListItem>
                        <asp:ListItem Value="nuevo" Text="Nuevo"></asp:ListItem>
                        <asp:ListItem Value="cerrado" Text="Cerrado"></asp:ListItem>
                        <asp:ListItem Value="reprogramado" Text="Reprogramado"></asp:ListItem>
                        <asp:ListItem Value="noasistio" Text="No asistió"></asp:ListItem>
                        <asp:ListItem Value="cancelado" Text="Cancelado"></asp:ListItem>
                    </asp:DropDownList>
                    <%-- Los médicos se cargan desde la base; AppendDataBoundItems mantiene la opción "Todos" --%>
                    <asp:DropDownList ID="ddlProfesional" runat="server" AutoPostBack="true" AppendDataBoundItems="true"
                        OnSelectedIndexChanged="ddlProfesional_SelectedIndexChanged" CssClass="form-select-custom pe-4">
                        <asp:ListItem Value="0" Text="Todos los profesionales"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:LinkButton ID="btnRefrescar" runat="server" OnClick="btnRefrescar_Click" ToolTip="Refrescar lista"
                        CssClass="btn-square-40 btn d-flex align-items-center justify-content-center rounded-3 p-0">
                        <span class="material-symbols-outlined">refresh</span>
                    </asp:LinkButton>
                </asp:Panel>
            </div>

            <!-- Tabla -->
            <div class="table-responsive w-100">
                <%--
                    Campos esperados en el DataSource (un ítem por turno):
                      IdTurno, Hora, PacienteIniciales, PacienteNombre, PacienteDetalle ("DNI 38.412.905 • OSDE 310"),
                      MedicoNombre, Especialidad,
                      EstadoTexto, EstadoCss (badge-estado-nuevo | -cerrado | -reprogramado | -no-asistio | -cancelado),
                      FilaCss ("" | row-highlight | row-cancelado),
                      AvatarCss ("" | avatar-circle-primary | avatar-circle-danger),
                      AccionTexto, AccionComando (CheckIn | VerFicha | Reprogramar | VerCambio | LiberarCupo),
                      AccionCss (btn-action-outline | btn-action-primary)
                --%>
                <asp:Repeater ID="rptTurnosHoy" runat="server" OnItemCommand="rptTurnosHoy_ItemCommand">
                    <HeaderTemplate>
                        <table class="table-turnos">
                            <thead>
                                <tr>
                                    <th scope="col">Hora</th>
                                    <th scope="col">Paciente</th>
                                    <th scope="col">Médico Asignado</th>
                                    <th scope="col">Especialidad</th>
                                    <th scope="col">Estado</th>
                                    <th scope="col" class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                                <tr class='<%# Eval("FilaCss") %>'>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="turno-hora turno-tachable fw-semibold text-dark"><%#: Eval("Hora") %></span>
                                            <span class="turno-hora-dot" title="Próximo turno en espera"></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class='avatar-circle <%# Eval("AvatarCss") %>'><%#: Eval("PacienteIniciales") %></div>
                                            <div class="d-flex flex-column min-w-0">
                                                <span class="turno-tachable fw-semibold text-dark text-truncate fs-14"><%#: Eval("PacienteNombre") %></span>
                                                <span class="text-secondary fs-12"><%#: Eval("PacienteDetalle") %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="turno-medico-icon material-symbols-outlined icon-18 text-secondary">stethoscope</span>
                                            <span class="text-dark fs-14"><%#: Eval("MedicoNombre") %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="turno-especialidad badge rounded-2 fw-normal px-2 py-1"><%#: Eval("Especialidad") %></span>
                                    </td>
                                    <td>
                                        <span class='badge-estado <%# Eval("EstadoCss") %>'>
                                            <span class="dot"></span>
                                            <%#: Eval("EstadoTexto") %>
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-flex align-items-center justify-content-end gap-2">
                                            <asp:LinkButton ID="btnAccion" runat="server" CssClass='<%# Eval("AccionCss") %>'
                                                CommandName='<%# Eval("AccionComando") %>' CommandArgument='<%# Eval("IdTurno") %>'
                                                Text='<%#: Eval("AccionTexto") %>'></asp:LinkButton>

                                            <%-- Menú de más acciones (dropdown de Bootstrap) --%>
                                            <div class="dropdown">
                                                <button type="button" class="btn-icon-more" data-bs-toggle="dropdown" aria-expanded="false"
                                                    data-bs-popper-config='{"strategy":"fixed"}' title="Más acciones">
                                                    <span class="material-symbols-outlined icon-18">more_vert</span>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                    <li><asp:LinkButton ID="lnkMenuVerFicha" runat="server" CssClass="dropdown-item" CommandName="VerFicha" CommandArgument='<%# Eval("IdTurno") %>' Text="Ver ficha"></asp:LinkButton></li>
                                                    <li><asp:LinkButton ID="lnkMenuReprogramar" runat="server" CssClass="dropdown-item" CommandName="Reprogramar" CommandArgument='<%# Eval("IdTurno") %>' Text="Reprogramar"></asp:LinkButton></li>
                                                    <li><hr class="dropdown-divider" /></li>
                                                    <li><asp:LinkButton ID="lnkMenuCancelar" runat="server" CssClass="dropdown-item text-danger" CommandName="Cancelar" CommandArgument='<%# Eval("IdTurno") %>' Text="Cancelar turno"></asp:LinkButton></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false" CssClass="text-center text-secondary fs-14 py-4">
                    No hay turnos para los filtros seleccionados.
                </asp:Panel>
            </div>

            <!-- Pie de tabla: paginación -->
            <div class="table-footer p-3 px-4 d-flex flex-column flex-sm-row align-items-center justify-content-between gap-3">
                <div class="d-flex align-items-center gap-2 text-secondary fs-12">
                    <span>Filas por página:</span>
                    <asp:DropDownList ID="ddlFilasPorPagina" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilasPorPagina_SelectedIndexChanged"
                        CssClass="select-filas form-select form-select-sm border-0 bg-white text-dark fw-semibold px-2 py-1 rounded-2 shadow-none">
                        <asp:ListItem Value="8" Text="8"></asp:ListItem>
                        <asp:ListItem Value="15" Text="15"></asp:ListItem>
                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="lblResumenPaginacion" runat="server" CssClass="ms-2" Text="Mostrando 1 - 8 de 42 turnos programados"></asp:Label>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-secondary fs-12">
                        Página <asp:Label ID="lblPaginaActual" runat="server" CssClass="fw-bold text-dark" Text="1"></asp:Label>
                        de <asp:Label ID="lblTotalPaginas" runat="server" Text="6"></asp:Label>
                    </span>
                    <div class="d-flex align-items-center gap-1">
                        <asp:LinkButton ID="btnPaginaAnterior" runat="server" OnClick="btnPaginaAnterior_Click" CssClass="btn-page text-secondary" ToolTip="Página anterior">
                            <span class="material-symbols-outlined icon-18">chevron_left</span>
                        </asp:LinkButton>
                        <%-- Campos esperados: Numero, Css ("" | active) --%>
                        <asp:Repeater ID="rptPaginas" runat="server" OnItemCommand="rptPaginas_ItemCommand">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkPagina" runat="server" CssClass='<%# "btn-page " + Eval("Css") %>'
                                    CommandName="IrAPagina" CommandArgument='<%# Eval("Numero") %>' Text='<%# Eval("Numero") %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="btnPaginaSiguiente" runat="server" OnClick="btnPaginaSiguiente_Click" CssClass="btn-page" ToolTip="Página siguiente">
                            <span class="material-symbols-outlined icon-18">chevron_right</span>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
