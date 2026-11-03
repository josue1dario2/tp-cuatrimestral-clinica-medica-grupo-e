<%@ Page Title="Turnos de Trabajo" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="TurnosTrabajo.aspx.cs" Inherits="Clinica_Medica_Grupo_e.TurnosTrabajo" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="turnos-trabajo d-flex flex-column gap-4">

        <!-- ===================== 1. ENCABEZADO ===================== -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill fw-semibold tt-tag">CONFIGURACIÓN DE PLANTA</span>
                    <span class="text-muted fs-12">•</span>
                    <span class="fs-12 text-secondary fw-medium">Clínica Central &amp; Sedes</span>
                </div>
                <h1 class="page-title h3 fw-bold text-dark mb-1">Turnos de Trabajo</h1>
                <p class="text-muted fs-14 mb-0 tt-subtitulo">Definición de esquemas horarios y franjas de atención clínica para asignación médica y grilla operativa de consultorios.</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <asp:LinkButton ID="btnExportar" runat="server" OnClick="btnExportar_Click"
                    CssClass="btn tt-btn-soft d-flex align-items-center gap-2 shadow-sm">
                    <span class="material-symbols-outlined icon-18">file_download</span>
                    <span class="fw-semibold fs-14">Exportar grilla</span>
                </asp:LinkButton>
                <%-- Muestra el formulario de la derecha (lo vacía para un alta nueva); no hace PostBack --%>
                <button type="button" class="btn btn-teal d-flex align-items-center gap-2 shadow-sm" onclick="nuevoTurnoTrabajo();">
                    <span class="material-symbols-outlined icon-20">add_circle</span>
                    <span class="fw-semibold fs-14">Nuevo turno de trabajo</span>
                </button>
            </div>
        </div>

        <!-- ===================== 2. TARJETAS KPI ===================== -->
        <%-- Los anchos de las barras (style="width: …") los puede cambiar el code-behind con barKpiX.Style["width"] = "…%" --%>
        <div class="row g-3">
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-3 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="fs-13 text-muted fw-medium">Turnos configurados</span>
                            <asp:Label ID="lblKpiTurnos" runat="server" CssClass="tt-kpi-valor d-block mt-1" Text="5"></asp:Label>
                        </div>
                        <div class="tt-kpi-icono tt-kpi-icono-teal"><span class="material-symbols-outlined">more_time</span></div>
                    </div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between fs-13 text-muted mb-1">
                            <span class="text-success fw-semibold d-inline-flex align-items-center gap-1">
                                <span class="material-symbols-outlined tt-icon-15">check_circle</span>
                                <asp:Label ID="lblKpiTurnosActivos" runat="server" Text="5 esquemas activos"></asp:Label>
                            </span>
                            <asp:Label ID="lblKpiTurnosPorcentaje" runat="server" Text="100% operativos"></asp:Label>
                        </div>
                        <div class="progress tt-progress">
                            <div id="barKpiTurnos" runat="server" class="progress-bar tt-bar-teal" role="progressbar" style="width: 100%;"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-3 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="fs-13 text-muted fw-medium">Médicos con horario</span>
                            <asp:Label ID="lblKpiMedicos" runat="server" CssClass="tt-kpi-valor d-block mt-1" Text="22"></asp:Label>
                        </div>
                        <div class="tt-kpi-icono tt-kpi-icono-azul"><span class="material-symbols-outlined">stethoscope</span></div>
                    </div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between fs-13 text-muted mb-1">
                            <asp:Label ID="lblKpiMedicosAsignados" runat="server" CssClass="fw-semibold text-dark" Text="22 profesionales"></asp:Label>
                            <asp:Label ID="lblKpiMedicosTotal" runat="server" Text="De 26 registrados"></asp:Label>
                        </div>
                        <div class="progress tt-progress">
                            <div id="barKpiMedicos" runat="server" class="progress-bar tt-bar-gris" role="progressbar" style="width: 84.6%;"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-3 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="fs-13 text-muted fw-medium">Cobertura horaria</span>
                            <div class="d-flex align-items-baseline gap-1 mt-1">
                                <asp:Label ID="lblKpiCobertura" runat="server" CssClass="h4 fw-bold mb-0" Text="07:00 a 22:00"></asp:Label>
                                <span class="fs-13 text-muted">hs</span>
                            </div>
                        </div>
                        <div class="tt-kpi-icono tt-kpi-icono-verde"><span class="material-symbols-outlined">schedule</span></div>
                    </div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between fs-13 text-muted mb-1">
                            <asp:Label ID="lblKpiHorasDiarias" runat="server" CssClass="text-success fw-semibold" Text="15 horas diarias"></asp:Label>
                            <span>Guardia continua</span>
                        </div>
                        <div class="progress tt-progress">
                            <div id="barKpiCobertura" runat="server" class="progress-bar bg-success" role="progressbar" style="width: 75%;"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card-custom p-3 h-100 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="fs-13 text-muted fw-medium">Bloques diarios</span>
                            <asp:Label ID="lblKpiBloques" runat="server" CssClass="tt-kpi-valor d-block mt-1" Text="45"></asp:Label>
                        </div>
                        <div class="tt-kpi-icono tt-kpi-icono-celeste"><span class="material-symbols-outlined">grid_on</span></div>
                    </div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between fs-13 text-muted mb-1">
                            <asp:Label ID="lblKpiBloquesDisponibles" runat="server" CssClass="fw-semibold text-cl-primary" Text="45 bloques disponibles"></asp:Label>
                            <span>60 min c/u</span>
                        </div>
                        <div class="progress tt-progress">
                            <div id="barKpiBloques" runat="server" class="progress-bar tt-bar-teal" role="progressbar" style="width: 90%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===================== 3. TABLA + FORMULARIO ===================== -->
        <div class="row g-4 align-items-start">

            <!-- Columna izquierda: tabla -->
            <div class="col-12 col-lg-7 col-xl-8">
                <div class="card-custom p-3 p-lg-4">

                    <!-- Búsqueda y filtros -->
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 pb-3">
                        <div class="input-group tt-buscador">
                            <span class="input-group-text bg-light border-0"><span class="material-symbols-outlined text-muted icon-18">search</span></span>
                            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control bg-light border-0 fs-14" placeholder="Buscar turno por nombre u horario..."></asp:TextBox>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <%-- Estado: la tabla TURNOS_TRABAJO todavía no tiene columna Activo (CommandArgument = Activos | Inactivos | Todos) --%>
                            <div class="tt-tabs d-flex p-1 bg-light rounded-3" role="group">
                                <asp:LinkButton ID="btnTabActivos" runat="server" OnCommand="FiltroEstado_Command" CommandArgument="Activos" CssClass="tt-tab tt-tab-activa">
                                    <span>Activos (<asp:Label ID="lblCantActivos" runat="server" Text="5"></asp:Label>)</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnTabInactivos" runat="server" OnCommand="FiltroEstado_Command" CommandArgument="Inactivos" CssClass="tt-tab">
                                    <span>Inactivos (<asp:Label ID="lblCantInactivos" runat="server" Text="0"></asp:Label>)</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnTabTodos" runat="server" OnCommand="FiltroEstado_Command" CommandArgument="Todos" CssClass="tt-tab">
                                    <span>Todos</span>
                                </asp:LinkButton>
                            </div>
                            <asp:LinkButton ID="btnFiltrar" runat="server" OnClick="btnFiltrar_Click" CssClass="btn btn-light btn-sm p-2 rounded-3 d-flex" ToolTip="Buscar">
                                <span class="material-symbols-outlined icon-20">filter_list</span>
                            </asp:LinkButton>
                        </div>
                    </div>

                    <!-- Tabla -->
                    <div class="table-responsive">
                        <%--
                            Campos esperados por fila:
                              IdTurnoTrabajo, Nombre ("Turno Mañana"), Detalle ("Lunes a Sábado • Consultorios 1 al 8"),
                              ColorCss (tt-color-1 … tt-color-5), Entrada ("08:00 hs"), Salida ("14:00 hs"),
                              CantidadBloques (6), Bloques (lista con un elemento por bloque, para dibujar la barrita),
                              Medicos (lista de iniciales, máximo 3), MedicosTexto ("+8 méd." o "3 méd."),
                              EstadoTexto ("Activo")
                            Detalle y Estado no están en la base: por ahora son texto de ejemplo.
                        --%>
                        <asp:Repeater ID="rptTurnosTrabajo" runat="server" OnItemCommand="rptTurnosTrabajo_ItemCommand">
                            <HeaderTemplate>
                                <table class="tt-table table mb-0">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="py-3 px-3">Nombre del Turno</th>
                                            <th scope="col" class="py-3 px-2">Entrada</th>
                                            <th scope="col" class="py-3 px-2">Salida</th>
                                            <th scope="col" class="py-3 px-2">Bloques de 1 h</th>
                                            <th scope="col" class="py-3 px-2">Médicos Asignados</th>
                                            <th scope="col" class="py-3 px-2 text-center">Estado</th>
                                            <th scope="col" class="py-3 px-3 text-end">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                        <tr class='<%# Eval("ColorCss") %>'>
                                            <td class="py-3 px-3">
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="tt-punto rounded-circle flex-shrink-0"></span>
                                                    <div>
                                                        <div class="fw-semibold text-dark"><%#: Eval("Nombre") %></div>
                                                        <div class="fs-13 text-muted"><%#: Eval("Detalle") %></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="py-3 px-2"><span class="badge bg-light text-dark fw-semibold p-2 font-monospace"><%#: Eval("Entrada") %></span></td>
                                            <td class="py-3 px-2"><span class="badge bg-light text-dark fw-semibold p-2 font-monospace"><%#: Eval("Salida") %></span></td>
                                            <td class="py-3 px-2">
                                                <div class="fs-13 fw-semibold text-secondary mb-1"><%#: Eval("CantidadBloques") %> bloques (60 min)</div>
                                                <div class="tt-barra-bloques d-flex gap-1 p-1 bg-light rounded-pill">
                                                    <asp:Repeater ID="rptSegmentos" runat="server" DataSource='<%# Eval("Bloques") %>'>
                                                        <ItemTemplate><span class="tt-segmento flex-fill rounded"></span></ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </td>
                                            <td class="py-3 px-2">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="tt-avatar-grupo">
                                                        <asp:Repeater ID="rptMedicos" runat="server" DataSource='<%# Eval("Medicos") %>'>
                                                            <ItemTemplate><span class="tt-avatar"><%#: Container.DataItem %></span></ItemTemplate>
                                                        </asp:Repeater>
                                                    </div>
                                                    <span class="fs-13 fw-semibold text-secondary text-nowrap"><%#: Eval("MedicosTexto") %></span>
                                                </div>
                                            </td>
                                            <td class="py-3 px-2 text-center">
                                                <span class="tt-badge-activo"><span class="tt-badge-punto rounded-circle"></span> <%#: Eval("EstadoTexto") %></span>
                                            </td>
                                            <td class="py-3 px-3 text-end">
                                                <div class="d-inline-flex">
                                                    <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("IdTurnoTrabajo") %>'
                                                        CssClass="btn btn-link text-secondary p-1" ToolTip="Editar turno">
                                                        <span class="material-symbols-outlined icon-18">edit</span>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="btnVerMedicos" runat="server" CommandName="VerMedicos" CommandArgument='<%# Eval("IdTurnoTrabajo") %>'
                                                        CssClass="btn btn-link text-secondary p-1" ToolTip="Ver médicos asignados">
                                                        <span class="material-symbols-outlined icon-18">groups</span>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="btnDuplicar" runat="server" CommandName="Duplicar" CommandArgument='<%# Eval("IdTurnoTrabajo") %>'
                                                        CssClass="btn btn-link text-secondary p-1" ToolTip="Duplicar franja">
                                                        <span class="material-symbols-outlined icon-18">content_copy</span>
                                                    </asp:LinkButton>
                                                </div>
                                            </td>
                                        </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false" CssClass="text-center text-muted fs-14 py-4">
                            No se encontraron turnos de trabajo con los filtros seleccionados.
                        </asp:Panel>
                    </div>

                    <!-- Paginación -->
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2 pt-3 border-top mt-3 fs-13 text-muted">
                        <div class="d-flex align-items-center gap-3">
                            <span>
                                Mostrando <asp:Label ID="lblRangoMostrado" runat="server" CssClass="fw-bold text-dark" Text="1 - 5"></asp:Label>
                                de <asp:Label ID="lblTotalRegistros" runat="server" CssClass="fw-bold text-dark" Text="5"></asp:Label> turnos registrados
                            </span>
                            <div class="d-flex align-items-center gap-1">
                                <asp:Label ID="lblPorPagina" runat="server" AssociatedControlID="ddlPorPagina" Text="Filas:"></asp:Label>
                                <asp:DropDownList ID="ddlPorPagina" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPorPagina_SelectedIndexChanged"
                                    CssClass="select-filas form-select form-select-sm py-0">
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
                            <asp:LinkButton ID="btnPaginaSiguiente" runat="server" OnClick="btnPaginaSiguiente_Click" CssClass="btn-page text-secondary" ToolTip="Página siguiente">
                                <span class="material-symbols-outlined icon-18">chevron_right</span>
                            </asp:LinkButton>
                        </div>
                    </div>

                    <!-- Aviso informativo -->
                    <div class="tt-info d-flex gap-3 mt-3 p-3 rounded-3">
                        <span class="material-symbols-outlined icon-22 text-cl-primary">info</span>
                        <div class="fs-13">
                            <div class="fw-bold text-dark mb-1">Regla de asignación por consultorio</div>
                            <span class="text-muted">Los turnos configurados no generan superposición automática si se asignan a consultorios independientes. Al editar las horas de salida, se actualizarán las grillas del médico asignado a partir del día subsiguiente.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Columna derecha: formulario (alta y edición) -->
            <div class="col-12 col-lg-5 col-xl-4">
                <div id="formTurnoTrabajo" class="card-custom tt-formulario p-3 p-lg-4 shadow-sm">
                    <%-- Vacío = alta; con valor = edición del turno con ese Id --%>
                    <asp:HiddenField ID="hfIdTurnoTrabajo" runat="server" ClientIDMode="Static" />

                    <div class="d-flex justify-content-between align-items-start pb-3 border-bottom mb-3">
                        <div class="d-flex align-items-center gap-2">
                            <div class="tt-kpi-icono tt-kpi-icono-teal tt-icono-chico"><span class="material-symbols-outlined icon-20">more_time</span></div>
                            <div>
                                <asp:Label ID="lblFormTitulo" runat="server" ClientIDMode="Static" CssClass="h6 fw-bold mb-0 text-dark d-block" Text="Nuevo turno de trabajo"></asp:Label>
                                <span class="text-muted fs-13">Configurá los límites horarios para agendas médicas.</span>
                            </div>
                        </div>
                        <button type="button" class="btn btn-link text-muted p-1 text-decoration-none" onclick="ocultarFormulario();" aria-label="Cerrar">
                            <span class="material-symbols-outlined icon-20">close</span>
                        </button>
                    </div>

                    <div class="d-flex flex-column gap-3">
                        <div>
                            <label class="form-label fw-semibold fs-13 d-flex justify-content-between" for="txtNombre">
                                <span>Nombre del turno <span class="text-danger">*</span></span>
                                <span class="text-muted fw-normal">Identificador único</span>
                            </label>
                            <asp:TextBox ID="txtNombre" runat="server" ClientIDMode="Static" MaxLength="50" CssClass="form-control form-control-sm py-2"
                                placeholder="Ej. Turno Tarde B, Turno Especial Sábado..."></asp:TextBox>
                        </div>

                        <%-- En la base las horas son números enteros (8 = 08:00 hs): por eso se eligen de una lista de horas en punto --%>
                        <div class="row g-2">
                            <div class="col-6">
                                <asp:Label ID="lblHoraEntrada" runat="server" AssociatedControlID="ddlHoraEntrada" CssClass="form-label fw-semibold fs-13">Hora de entrada <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddlHoraEntrada" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlHora_SelectedIndexChanged"
                                    CssClass="form-select form-select-sm font-monospace"></asp:DropDownList>
                                <span class="text-muted fs-12">Inicio de atención</span>
                            </div>
                            <div class="col-6">
                                <asp:Label ID="lblHoraSalida" runat="server" AssociatedControlID="ddlHoraSalida" CssClass="form-label fw-semibold fs-13">Hora de salida <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddlHoraSalida" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlHora_SelectedIndexChanged"
                                    CssClass="form-select form-select-sm font-monospace"></asp:DropDownList>
                                <span class="text-muted fs-12">Cierre de agenda</span>
                            </div>
                        </div>

                        <!-- Vista previa de la franja -->
                        <div class="tt-preview p-3 rounded-3 border">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-semibold fs-13 d-flex align-items-center gap-1 text-dark">
                                    <span class="material-symbols-outlined icon-18 text-cl-primary">view_timeline</span>
                                    <span>Vista previa de la franja (<asp:Label ID="lblPreviewCantidad" runat="server" Text="6"></asp:Label> bloques de 1 hora)</span>
                                </span>
                                <span class="badge rounded-pill tt-badge-teal">60 min c/u</span>
                            </div>
                            <%-- Campos esperados: Rango ("14:00 - 15:00"), Numero (1) --%>
                            <div class="row g-2 my-1">
                                <asp:Repeater ID="rptPreviewBloques" runat="server">
                                    <ItemTemplate>
                                        <div class="col-4">
                                            <div class="tt-mini-bloque">
                                                <div class="fw-bold fs-13 text-cl-primary"><%#: Eval("Rango") %></div>
                                                <div class="text-muted fs-11">Bloque <%#: Eval("Numero") %></div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="d-flex align-items-center gap-1 pt-1 fs-12 text-muted">
                                <span class="material-symbols-outlined text-success icon-16">speed</span>
                                <span><strong>Duración total:</strong> <asp:Label ID="lblPreviewDuracion" runat="server" Text="6 horas continuas"></asp:Label></span>
                            </div>
                        </div>

                        <!-- Error de horario: se muestra desde el code-behind -->
                        <asp:Panel ID="pnlErrorHorario" runat="server" Visible="false" CssClass="alert alert-danger d-flex align-items-start gap-2 p-2 mb-0 rounded-3">
                            <span class="material-symbols-outlined text-danger icon-20">error</span>
                            <div class="fs-13">
                                <div class="fw-bold text-danger">Validación de inconsistencia horaria</div>
                                <asp:Label ID="lblErrorHorario" runat="server" Text="La hora de salida debe ser posterior a la de entrada."></asp:Label>
                            </div>
                        </asp:Panel>

                        <%-- Días y consultorios no están en la base: por ahora son solo de ejemplo --%>
                        <div class="form-check">
                            <asp:CheckBox ID="chkDiasHabiles" runat="server" ClientIDMode="Static" Checked="true" />
                            <label class="form-check-label fs-13 text-dark" for="chkDiasHabiles">Aplicar a días hábiles (Lunes a Viernes)</label>
                        </div>
                        <div>
                            <asp:Label ID="lblConsultorios" runat="server" AssociatedControlID="ddlConsultorios" CssClass="form-label fw-semibold fs-13" Text="Consultorios habilitados por defecto"></asp:Label>
                            <asp:DropDownList ID="ddlConsultorios" runat="server" CssClass="form-select form-select-sm py-2">
                                <asp:ListItem Value="Todos" Text="Todos los consultorios ambulatorios (1 al 12)" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="Norte" Text="Ala Norte: Consultorios 1 al 6"></asp:ListItem>
                                <asp:ListItem Value="Sur" Text="Ala Sur: Consultorios 7 al 12"></asp:ListItem>
                                <asp:ListItem Value="Guardia" Text="Módulos de Guardia (G1 - G3)"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                            <button type="button" class="btn btn-outline-secondary btn-sm px-3" onclick="ocultarFormulario();">Cancelar</button>
                            <asp:LinkButton ID="btnGuardar" runat="server" OnClick="btnGuardar_Click"
                                CssClass="btn btn-teal btn-sm px-3 d-flex align-items-center gap-1 shadow-sm">
                                <span class="material-symbols-outlined icon-18">save</span>
                                <span>Guardar turno de trabajo</span>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/turnos-trabajo.js") %>'></script>
</asp:Content>
