<%@ Page Title="Inicio - Panel Médico" Language="C#" MasterPageFile="~/Medico.Master" AutoEventWireup="true" CodeBehind="InicioMedico.aspx.cs" Inherits="vista.InicioMedico" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column gap-4">

        <!-- ===================== 1. BIENVENIDA ===================== -->
        <div class="cl-card p-4 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
            <div class="d-flex flex-column gap-1">
                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <h1 class="h3 fw-bold mb-0 text-dark">
                        <asp:Label ID="lblSaludoDoctor" runat="server" Text="Buenas tardes, Dr. Gómez"></asp:Label>
                    </h1>
                    <span class="cl-status-pill badge rounded-pill fw-semibold d-inline-flex align-items-center gap-2 px-3 py-2 text-dark">
                        <span class="cl-pulse-dot"></span>
                        <asp:Label ID="lblEstadoAtencion" runat="server" Text="En consultorio • Activo"></asp:Label>
                    </span>
                </div>
                <div class="d-flex align-items-center gap-2 text-secondary small flex-wrap mt-1">
                    <span class="d-inline-flex align-items-center gap-1">
                        <i class="bi bi-calendar3"></i>
                        <asp:Label ID="lblFechaLarga" runat="server" Text="Lunes 24 de octubre de 2025"></asp:Label>
                    </span>
                    <span class="text-black-50">•</span>
                    <span class="d-inline-flex align-items-center gap-1">
                        <i class="bi bi-door-closed"></i>
                        <asp:Label ID="lblConsultorioTurno" runat="server" Text="Consultorio 4 • Turno Tarde"></asp:Label>
                    </span>
                    <span class="text-black-50">•</span>
                    <asp:Label ID="lblEspecialidad" runat="server" CssClass="fw-semibold text-cl-primary" Text="Dermatología Clínica"></asp:Label>
                </div>
            </div>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <asp:LinkButton ID="btnPausarAtencion" runat="server" OnClick="btnPausarAtencion_Click"
                    CssClass="btn btn-cl-subtle d-inline-flex align-items-center gap-2 px-3 py-2">
                    <i class="bi bi-pause-circle fs-6"></i>
                    <span>Pausar atención</span>
                </asp:LinkButton>
                <asp:LinkButton ID="btnBusquedaHC" runat="server" OnClick="btnBusquedaHC_Click"
                    CssClass="btn btn-cl-primary d-inline-flex align-items-center gap-2 px-3 py-2 shadow-sm">
                    <i class="bi bi-folder2-open fs-6"></i>
                    <span>Búsqueda de HC</span>
                </asp:LinkButton>
            </div>
        </div>

        <!-- ===================== 2. INDICADORES ===================== -->
        <div class="row g-3">

            <!-- Turnos programados -->
            <div class="col-12 col-md-4">
                <div class="cl-card p-3 p-xl-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between">
                        <div>
                            <span class="cl-kpi-label text-uppercase fw-semibold text-secondary">Turnos programados</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiProgramados" runat="server" CssClass="h2 fw-bold mb-0 text-dark" Text="16"></asp:Label>
                                <span class="text-secondary small">pacientes</span>
                            </div>
                        </div>
                        <div class="cl-kpi-icon rounded-3 d-flex align-items-center justify-content-center p-2">
                            <i class="bi bi-calendar-check fs-4"></i>
                        </div>
                    </div>
                    <div class="cl-kpi-footer mt-3 pt-2 border-top d-flex align-items-center justify-content-between small text-secondary">
                        <span class="d-inline-flex align-items-center gap-1">
                            <i class="bi bi-clock text-cl-primary"></i>
                            <asp:Label ID="lblHorarioAtencion" runat="server" Text="14:00 a 20:00 hs"></asp:Label>
                        </span>
                        <asp:Label ID="lblKpiCancelados" runat="server" CssClass="badge bg-danger-subtle text-danger fw-semibold px-2 py-1 rounded-pill" Text="1 cancelado"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Completados -->
            <div class="col-12 col-md-4">
                <div class="cl-card p-3 p-xl-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between">
                        <div>
                            <span class="cl-kpi-label text-uppercase fw-semibold text-secondary">Completados</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiCompletados" runat="server" CssClass="h2 fw-bold mb-0 text-cl-success" Text="7"></asp:Label>
                                <asp:Label ID="lblKpiCompletadosTotal" runat="server" CssClass="text-secondary small" Text="de 16"></asp:Label>
                            </div>
                        </div>
                        <div class="cl-kpi-icon cl-kpi-icon-success rounded-3 d-flex align-items-center justify-content-center p-2">
                            <i class="bi bi-check-circle-fill fs-4"></i>
                        </div>
                    </div>
                    <div class="mt-3 pt-2 border-top d-flex flex-column gap-1">
                        <div class="cl-kpi-progress-label d-flex justify-content-between small fw-medium">
                            <span class="text-secondary">Progreso del turno</span>
                            <asp:Label ID="lblKpiPorcentaje" runat="server" CssClass="fw-bold text-cl-success" Text="44%"></asp:Label>
                        </div>
                        <div class="cl-progress progress" role="progressbar">
                            <!-- El ancho se asigna desde el code-behind: pnlBarraProgreso.Style["width"] = "44%"; -->
                            <asp:Panel ID="pnlBarraProgreso" runat="server" CssClass="progress-bar" Style="width: 44%;"></asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pendientes -->
            <div class="col-12 col-md-4">
                <div class="cl-card p-3 p-xl-4 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex align-items-start justify-content-between">
                        <div>
                            <span class="cl-kpi-label text-uppercase fw-semibold text-secondary">Pendientes de atención</span>
                            <div class="d-flex align-items-baseline gap-2 mt-1">
                                <asp:Label ID="lblKpiPendientes" runat="server" CssClass="h2 fw-bold mb-0 text-cl-primary" Text="8"></asp:Label>
                                <span class="text-secondary small">restantes</span>
                            </div>
                        </div>
                        <div class="cl-kpi-icon rounded-3 d-flex align-items-center justify-content-center p-2">
                            <i class="bi bi-geo-alt-fill fs-4"></i>
                        </div>
                    </div>
                    <div class="cl-kpi-footer mt-3 pt-2 border-top d-flex align-items-center justify-content-between small text-secondary">
                        <span class="d-inline-flex align-items-center gap-1 fw-semibold text-cl-primary">
                            <span class="cl-pulse-dot cl-pulse-dot-primary"></span>
                            <asp:Label ID="lblKpiEnEspera" runat="server" Text="1 en sala de espera"></asp:Label>
                        </span>
                        <asp:Label ID="lblKpiReprogramados" runat="server" CssClass="badge bg-secondary-subtle text-secondary fw-semibold px-2 py-1 rounded-pill" Text="1 reprogramado"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===================== 3. PRÓXIMO TURNO ===================== -->
        <asp:Panel ID="pnlProximoTurno" runat="server" CssClass="cl-card position-relative overflow-hidden shadow-sm">
            <div class="cl-accent-bar"></div>
            <div class="p-4">

                <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between pb-3 gap-2 border-bottom">
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <span class="cl-pill-proximo badge fw-bold px-3 py-2 text-uppercase rounded-pill">
                            <i class="cl-pill-proximo-dot bi bi-circle-fill me-1"></i>
                            Próximo turno
                        </span>
                        <span class="cl-pill-llegada badge fw-medium px-3 py-2 rounded-pill">
                            <i class="bi bi-person-check-fill me-1"></i>
                            <asp:Label ID="lblProximoLlegada" runat="server" Text="En sala de espera • Llegó 15:48 hs (a tiempo)"></asp:Label>
                        </span>
                    </div>
                    <div class="d-flex align-items-center gap-2 fw-bold h4 mb-0 text-cl-primary">
                        <i class="bi bi-alarm fs-4"></i>
                        <asp:Label ID="lblProximoTurnoHora" runat="server" Text="16:00 hs"></asp:Label>
                    </div>
                </div>

                <div class="row g-4 align-items-center pt-3">
                    <div class="col-12 col-lg-8 d-flex flex-column gap-3">

                        <!-- Datos del paciente -->
                        <div class="d-flex align-items-center gap-3">
                            <div class="cl-patient-avatar rounded-circle d-flex align-items-center justify-content-center fw-bold fs-5 text-primary flex-shrink-0">
                                <asp:Label ID="lblProximoPacienteIniciales" runat="server" Text="ME"></asp:Label>
                            </div>
                            <div>
                                <h2 class="h4 fw-bold mb-1 text-dark">
                                    <asp:Label ID="lblProximoPacienteNombre" runat="server" Text="Mariano Etcheverry"></asp:Label>
                                </h2>
                                <div class="d-flex align-items-center gap-2 text-secondary small flex-wrap">
                                    <span class="fw-semibold text-dark">DNI:
                                        <asp:Label ID="lblProximoPacienteDni" runat="server" Text="28.650.112"></asp:Label>
                                    </span>
                                    <span>•</span>
                                    <asp:Label ID="lblProximoPacienteEdad" runat="server" Text="42 años (14/08/1983)"></asp:Label>
                                    <span>•</span>
                                    <span class="badge bg-light text-dark border fw-medium px-2 py-1">
                                        <i class="bi bi-shield-check text-primary me-1"></i>
                                        <asp:Label ID="lblProximoPacienteCobertura" runat="server" Text="Galeno Oro • Plan 450"></asp:Label>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Motivo de consulta -->
                        <div class="cl-reason-box p-3 rounded-3">
                            <div class="cl-reason-label text-uppercase fw-semibold text-secondary mb-1">Motivo de consulta y observaciones previas</div>
                            <p class="cl-reason-text mb-2 text-dark">
                                <asp:Label ID="lblProximoMotivo" runat="server" Text="Control evolutivo de lesión dérmica y revisión de biopsia previa. Paciente refiere molestia leve y prurito intermitente en antebrazo izquierdo desde hace 2 semanas."></asp:Label>
                            </p>
                            <div class="cl-reason-meta d-flex align-items-center gap-2 text-secondary small">
                                <i class="bi bi-clock-history text-primary"></i>
                                <asp:Label ID="lblProximoUltimaVisita" runat="server" Text="Última visita: 18 de julio de 2025 (hace 3 meses) • Dra. V. Álvarez (Dermatología)"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <!-- Acciones rápidas -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-2">
                        <asp:LinkButton ID="btnLlamarAtender" runat="server" OnClick="btnLlamarAtender_Click"
                            CssClass="btn btn-cl-primary py-3 d-inline-flex align-items-center justify-content-center gap-2 shadow-sm fw-bold text-uppercase w-100">
                            <i class="bi bi-heart-pulse-fill fs-5"></i>
                            <span>Llamar y atender paciente</span>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnAbrirHC" runat="server" OnClick="btnAbrirHC_Click"
                            CssClass="btn btn-cl-subtle py-2 d-inline-flex align-items-center justify-content-center gap-2 fw-semibold w-100">
                            <i class="bi bi-journal-medical fs-6"></i>
                            <span>Abrir historia clínica</span>
                        </asp:LinkButton>
                        <div class="d-flex align-items-center justify-content-between px-1 pt-1 small">
                            <asp:LinkButton ID="btnAvisarRecepcion" runat="server" OnClick="btnAvisarRecepcion_Click"
                                CssClass="btn btn-link btn-sm text-secondary text-decoration-none p-0 d-inline-flex align-items-center gap-1">
                                <i class="bi bi-telephone fs-6"></i>
                                <span>Avisar a recepción</span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnReprogramarTurno" runat="server" OnClick="btnReprogramarTurno_Click"
                                CssClass="btn btn-link btn-sm text-secondary text-decoration-none p-0 d-inline-flex align-items-center gap-1">
                                <i class="bi bi-calendar-event fs-6"></i>
                                <span>Reprogramar</span>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- ===================== 4. AGENDA DEL DÍA ===================== -->
        <div class="cl-card p-4 d-flex flex-column gap-3">

            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 pb-2 border-bottom">
                <div>
                    <h3 class="h5 fw-bold mb-0 text-dark">Agenda del día • Turnos restantes</h3>
                    <asp:Label ID="lblResumenAgenda" runat="server" CssClass="text-secondary small" Text="8 pacientes citados de 16:00 a 19:30 hs"></asp:Label>
                </div>
                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <!-- Filtros: el filtro seleccionado lleva "bg-white text-primary shadow-sm rounded-2" -->
                    <div class="cl-filter-group btn-group p-1 rounded-3" role="group">
                        <asp:LinkButton ID="btnFiltroTodos" runat="server" OnClick="btnFiltroTodos_Click"
                            CssClass="btn btn-sm bg-white text-primary fw-semibold shadow-sm px-3 rounded-2" Text="Todos (8)"></asp:LinkButton>
                        <asp:LinkButton ID="btnFiltroEspera" runat="server" OnClick="btnFiltroEspera_Click"
                            CssClass="btn btn-sm btn-link text-secondary text-decoration-none fw-semibold px-3" Text="En espera (1)"></asp:LinkButton>
                        <asp:LinkButton ID="btnFiltroConfirmados" runat="server" OnClick="btnFiltroConfirmados_Click"
                            CssClass="btn btn-sm btn-link text-secondary text-decoration-none fw-semibold px-3" Text="Confirmados (6)"></asp:LinkButton>
                    </div>
                    <asp:LinkButton ID="btnActualizarLista" runat="server" OnClick="btnActualizarLista_Click" ToolTip="Actualizar lista"
                        CssClass="btn btn-cl-subtle btn-sm p-2 rounded-2">
                        <i class="bi bi-arrow-clockwise fs-6"></i>
                    </asp:LinkButton>
                </div>
            </div>

            <div class="table-responsive">
                <div class="cl-schedule-grid d-flex flex-column gap-1">

                    <div class="row mx-0 cl-table-header text-uppercase">
                        <div class="col-2">Hora</div>
                        <div class="col-4">Paciente &amp; cobertura</div>
                        <div class="col-3">Motivo de consulta</div>
                        <div class="col-2 text-center">Estado</div>
                        <div class="col-1 text-end">Acción</div>
                    </div>

                    <%--
                        Campos esperados en el DataSource:
                          IdTurno, Hora, PacienteNombre, PacienteDni, Cobertura, Motivo,
                          EstadoTexto, EstadoCss  (cl-badge-espera | cl-badge-nuevo | cl-badge-reprogramado | cl-badge-cancelado)
                          FilaCss                 ("" | cl-schedule-row-active | cl-schedule-row-reprogramado | cl-schedule-row-cancelado)
                    --%>
                    <asp:Repeater ID="rptTurnosRestantes" runat="server" OnItemCommand="rptTurnosRestantes_ItemCommand">
                        <ItemTemplate>
                            <div class='row mx-0 cl-schedule-row <%# Eval("FilaCss") %>'>
                                <div class="col-2">
                                    <span class="cl-row-time fw-semibold text-dark"><%#: Eval("Hora") %></span>
                                </div>
                                <div class="col-4 d-flex flex-column">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="fw-semibold text-dark small"><%#: Eval("PacienteNombre") %></span>
                                        <span class="cl-row-dni text-secondary small">DNI <%#: Eval("PacienteDni") %></span>
                                    </div>
                                    <span class="cl-row-coverage text-secondary small"><%#: Eval("Cobertura") %></span>
                                </div>
                                <div class="col-3 text-truncate small text-dark pe-2"><%#: Eval("Motivo") %></div>
                                <div class="col-2 text-center">
                                    <span class='cl-badge-custom <%# Eval("EstadoCss") %>'><%#: Eval("EstadoTexto") %></span>
                                </div>
                                <div class="col-1 text-end">
                                    <asp:LinkButton ID="btnVerFicha" runat="server" CommandName="VerFicha" CommandArgument='<%# Eval("IdTurno") %>'
                                        CssClass="btn btn-link btn-sm text-primary text-decoration-none fw-semibold" Text="Ficha"></asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false" CssClass="text-center text-secondary small py-4">
                        No hay turnos restantes para hoy.
                    </asp:Panel>
                </div>
            </div>

            <!-- Turnos ya atendidos (desplegable) -->
            <div class="mt-3 pt-2">
                <button type="button" id="btnToggleAtendidos"
                    class="btn btn-cl-subtle w-100 d-flex align-items-center justify-content-between p-3 rounded-3 text-start"
                    data-bs-toggle="collapse" data-bs-target="#collapseAtendidos" aria-expanded="false" aria-controls="collapseAtendidos">
                    <span class="d-flex align-items-center gap-2">
                        <i class="bi bi-check2-circle fs-5 text-cl-success"></i>
                        <asp:Label ID="lblCantidadAtendidos" runat="server" CssClass="fw-semibold text-dark small" Text="Turnos ya atendidos hoy (7)"></asp:Label>
                        <asp:Label ID="lblRangoAtendidos" runat="server" CssClass="text-secondary small" Text="• 14:00 a 15:45 hs"></asp:Label>
                    </span>
                    <span class="d-flex align-items-center gap-1 text-secondary small fw-semibold">
                        <span id="lblToggleAtendidosTexto">Ver detalle</span>
                        <i class="bi bi-chevron-down" id="iconToggleAtendidos"></i>
                    </span>
                </button>

                <div class="collapse mt-2" id="collapseAtendidos">
                    <div class="d-flex flex-column gap-1 ps-2">
                        <%--
                            Campos esperados: Hora, PacienteNombre, Cobertura, Observacion,
                                              EstadoTexto, EstadoCss (cl-badge-cerrado | cl-badge-reprogramado)
                        --%>
                        <asp:Repeater ID="rptTurnosAtendidos" runat="server">
                            <ItemTemplate>
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-2 bg-white small border">
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-semibold text-dark"><%#: Eval("Hora") %></span>
                                        <span class="fw-semibold text-dark"><%#: Eval("PacienteNombre") %></span>
                                        <span class="text-secondary"><%#: Eval("Cobertura") %></span>
                                        <span class="text-muted">• <%#: Eval("Observacion") %></span>
                                    </div>
                                    <span class='cl-badge-custom <%# Eval("EstadoCss") %>'><%#: Eval("EstadoTexto") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/inicio-medico.js") %>'></script>
</asp:Content>
