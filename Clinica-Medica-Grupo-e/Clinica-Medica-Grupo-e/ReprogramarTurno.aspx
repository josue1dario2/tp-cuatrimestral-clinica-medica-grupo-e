<%@ Page Title="Reprogramar turno" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="ReprogramarTurno.aspx.cs" Inherits="Clinica_Medica_Grupo_e.ReprogramarTurno" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="reprogramar-turno">
        <%-- Id del turno que se está reprogramando (lo carga el code-behind) --%>
        <asp:HiddenField ID="hfIdTurno" runat="server" />

        <%-- ===== PEGAR AQUÍ el contenido copiado del HTML (paso 3.0) ===== --%>
        <div class="d-flex flex-column w-100">
            <!-- 1. Breadcrumb y Encabezado Superior -->
            <div class="d-flex flex-column gap-2 pt-3 mb-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1" style="font-size: 12px;">
                        <li class="breadcrumb-item">
                            <asp:HyperLink ID="lnkBreadcrumbTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="text-decoration-none d-inline-flex align-items-center gap-1" Style="color: var(--cl-text-variant);">
                                <span class="material-symbols-outlined" style="font-size: 16px;">calendar_month</span>
                            <span>Turnos</span>
                            </asp:HyperLink>

                        </li>
                        <li class="breadcrumb-item">
                            <asp:HyperLink ID="lnkBreadcrumbGestion" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="text-decoration-none" Style="color: var(--cl-text-variant);" Text="Gestión de Citas"></asp:HyperLink>
                        </li>
                        <li aria-current="page" class="breadcrumb-item active text-dark fw-semibold">Reprogramar Turno #<asp:Label ID="lblBreadcrumbNumero" runat="server" Text="1001"></asp:Label></li>
                    </ol>
                </nav>
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <h1 class="h3 mb-0 fw-bold text-dark tracking-tight">Reprogramar Turno <span style="color: var(--cl-teal-container);">#<asp:Label ID="lblNumeroTurno" runat="server" Text="1001"></asp:Label></span>
                        </h1>

                        <span class="badge-amber-state d-inline-flex align-items-center gap-1">
                            <span class="rounded-circle d-inline-block"
                                style="width: 6px; height: 6px; background-color: var(--cl-warning-text);"></span>
                            <asp:Label ID="lblEstadoTurno" runat="server" Text="Turno Activo / Requiere cambio de fecha"></asp:Label>
                        </span>
                    </div>
                    <asp:HyperLink ID="lnkVolver" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="btn btn-sm card-hospital-panel d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold text-decoration-none shadow-sm" Style="color: var(--cl-teal-primary); font-size: 14px;">
                      <span class="material-symbols-outlined" style="font-size: 18px;">arrow_back</span>
                      <span>Volver al listado de turnos</span>
                    </asp:HyperLink>

                </div>
            </div>
            <!-- 2. Grid Principal en 2 Columnas -->
            <div class="row g-4 align-items-start">
                <!-- COLUMNA IZQUIERDA: Turno actual (Solo Lectura) -->
                <div class="col-12 col-lg-5 d-flex flex-column gap-3">
                    <div class="card-hospital-low p-4 shadow-sm position-relative">
                        <!-- Indicador de Sólo Lectura -->
                        <div
                            class="d-flex align-items-center justify-content-between pb-3 mb-3 border-bottom border-light-subtle">
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-secondary" style="font-size: 20px;">lock</span>
                                <span class="fw-bold text-dark" style="font-size: 16px;">Turno Actual (a modificar)</span>
                            </div>
                            <span class="badge-blue-state d-inline-flex align-items-center gap-1">
                                <span class="material-symbols-outlined" style="font-size: 13px;">event_available</span>
                                <asp:Label ID="lblEstadoActual" runat="server" Text="Agendado"></asp:Label>
                            </span>

                        </div>
                        <!-- Paciente -->
                        <div class="card-hospital-panel p-3 shadow-sm mb-3">
                            <div class="d-flex align-items-start gap-3">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0" style="width: 48px; height: 48px; background-color: #D4E3FF; color: #061C35; font-size: 16px;">
                                    <asp:Label ID="lblPacienteIniciales" runat="server" Text="GN"></asp:Label>
                                </div>

                                <asp:Label ID="lblPacienteNombre" runat="server" CssClass="fw-bold text-dark text-truncate" Style="font-size: 16px;" Text="Martín Nicolás González"></asp:Label>
                                <div class="d-flex align-items-center gap-1 mt-1"
                                    style="font-size: 12px; color: var(--cl-text-variant);">
                                    <span class="fw-semibold text-uppercase text-muted" style="font-size: 11px;">DNI</span>
                                    <asp:Label ID="lblPacienteDni" runat="server" CssClass="fw-medium font-monospace text-dark" Text="35.892.410"></asp:Label>
                                    <span class="text-secondary mx-1">•</span>
                                    <asp:Label ID="lblPacienteEdad" runat="server" Text="34 años"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row g-2 mt-3 pt-2 p-2 rounded-2"
                            style="background-color: rgba(239, 244, 255, 0.7); font-size: 12px;">
                            <div class="col-12 col-sm-6 d-flex flex-column">
                                <span style="font-size: 11px; color: var(--cl-text-variant);">Teléfono de contacto</span>
                                <asp:Label ID="lblPacienteTelefono" runat="server" CssClass="fw-semibold text-dark font-monospace" Text="+54 11 4829-1122"></asp:Label>
                            </div>
                            <div class="col-12 col-sm-6 d-flex flex-column">
                                <span style="font-size: 11px; color: var(--cl-text-variant);">Cobertura médica</span>
                                <asp:Label ID="lblPacienteCobertura" runat="server" CssClass="fw-semibold text-dark text-truncate" Text="OSDE 210"></asp:Label>
                                <asp:Label ID="lblPacienteCredencial" runat="server" CssClass="text-muted font-monospace" Style="font-size: 11px;" Text="Cred: 490-28192801-01"></asp:Label>

                            </div>
                            <div class="col-12 d-flex flex-column pt-1">
                                <span style="font-size: 11px; color: var(--cl-text-variant);">Email registrado</span>
                                <asp:Label ID="lblPacienteEmail" runat="server" CssClass="fw-semibold text-truncate" Style="color: var(--cl-teal-primary);" Text="paciente@email.com"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <!-- Profesional y Especialidad -->
                    <div class="d-flex flex-column gap-3 mb-3">
                        <div class="d-flex align-items-start gap-2">
                            <div class="rounded-2 d-flex align-items-center justify-content-center flex-shrink-0 mt-1"
                                style="width: 32px; height: 32px; background-color: rgba(124, 212, 223, 0.35); color: var(--cl-teal-primary);">
                                <span class="material-symbols-outlined" style="font-size: 18px;">stethoscope</span>
                            </div>
                            <div class="d-flex flex-column">
                                <span class="fw-bold text-uppercase text-muted"
                                    style="font-size: 11px; letter-spacing: 0.05em;">Profesional Asignado</span>
                                <span class="fw-bold text-dark" style="font-size: 14px;">
                                    <asp:Label ID="lblMedicoActual" runat="server" Text="Dr. Martín Soria"></asp:Label>
                                    <asp:Label ID="lblMatriculaActual" runat="server" CssClass="fw-normal text-muted" Style="font-size: 12px;" Text="(MN 135.789)"></asp:Label></span>
                                <asp:Label ID="lblEspecialidadActual" runat="server" Style="font-size: 13px; color: var(--cl-text-variant);" Text="Cardiología Clínica — Consultorio 07 (Pabellón A)"></asp:Label>
                            </div>
                        </div>
                        <div class="d-flex align-items-start gap-2">
                            <div class="rounded-2 d-flex align-items-center justify-content-center flex-shrink-0 mt-1"
                                style="width: 32px; height: 32px; background-color: var(--cl-card-highest); color: #4D5F7B;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">medical_services</span>
                            </div>
                            <div class="d-flex flex-column">
                                <span class="fw-bold text-uppercase text-muted"
                                    style="font-size: 11px; letter-spacing: 0.05em;">Prestación</span>
                                <asp:Label ID="lblPrestacion" runat="server" CssClass="fw-semibold text-dark" Style="font-size: 14px;" Text="Consulta Cardiológica + Electrocardiograma"></asp:Label>
                            </div>
                        </div>
                        <!-- Fecha y Hora Agendada Actual -->
                        <div
                            class="p-3 rounded-2 card-hospital-panel shadow-sm d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined"
                                    style="font-size: 22px; color: var(--cl-danger);">schedule</span>
                                <div class="d-flex flex-column">
                                    <span class="text-muted" style="font-size: 11px;">Fecha &amp; Horario reservado</span>
                                    <asp:Label ID="lblFechaActual" runat="server" CssClass="fw-bold text-dark font-monospace" Style="font-size: 14px;" Text="Lunes 26 de Mayo, 2025"></asp:Label>
                                </div>
                            </div>
                            <div class="text-end">
                                <asp:Label ID="lblHoraActual" runat="server" CssClass="fw-bold font-monospace d-block" Style="font-size: 16px; color: var(--cl-danger);" Text="10:00 hs"></asp:Label>
                                <asp:Label ID="lblDuracionActual" runat="server" CssClass="text-muted" Style="font-size: 11px;" Text="60 minutos"></asp:Label>
                            </div>
                        </div>
                        <!-- Motivo Original -->
                        <div class="mb-3">
                            <span class="d-block mb-1 text-muted" style="font-size: 12px;">Motivo original registrado:</span>
                            <p class="fst-italic p-2 rounded-2 card-hospital-panel mb-0 text-dark"
                                style="font-size: 12px; background-color: rgba(255, 255, 255, 0.85);">
                                <asp:Label ID="lblMotivoOriginal" runat="server" Text="Chequeo cardiológico anual preventivo y solicitud de apto físico laboral"></asp:Label>
                            </p>
                        </div>
                        <!-- Advertencia de Liberación -->
                        <div class="d-flex align-items-start gap-2 p-3 rounded-2"
                            style="background-color: var(--cl-danger-bg); color: #93000A;">
                            <span class="material-symbols-outlined flex-shrink-0 mt-1"
                                style="font-size: 20px; color: var(--cl-danger);">warning</span>
                            <p class="mb-0 lh-base" style="font-size: 12px;">
                                <strong class="fw-semibold">Importante:</strong> Al confirmar el nuevo horario, el cupo del <strong class="font-monospace">
                                    <asp:Label ID="lblCupoALiberar" runat="server" Text="Lunes 26/05 a las 10:00 hs"></asp:Label></strong> quedará inmediatamente liberado para otros pacientes en el sistema central de turnos.
                            </p>
                        </div>
                    </div>
                    <!-- Resumen comparativo de cambio rápido -->
                    <div class="card-hospital-panel p-3 shadow-sm d-flex align-items-center justify-content-between gap-2">
                        <div class="d-flex align-items-center gap-3">
                            <span class="material-symbols-outlined"
                                style="font-size: 24px; color: var(--cl-teal-container);">sync_alt</span>
                            <div class="d-flex flex-column">
                                <span class="text-uppercase text-muted fw-semibold" style="font-size: 11px;">Modificación
                      solicitada</span>
                                <div class="d-flex align-items-center gap-2 mt-1" style="font-size: 13px;">
                                    <asp:Label ID="lblResumenAnterior" runat="server" CssClass="text-decoration-line-through text-muted font-monospace fw-medium" Text="Lun 26 10:00 hs"></asp:Label>
                                    <span class="material-symbols-outlined" style="font-size: 14px; color: var(--cl-teal-primary);">arrow_forward</span>
                                    <asp:Label ID="lblResumenNuevo" runat="server" CssClass="fw-bold font-monospace" Style="color: var(--cl-teal-container); font-size: 14px;" Text="Jue 29 11:00 hs"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblDiferencia" runat="server" CssClass="badge rounded-pill px-3 py-2" Style="background-color: rgba(127, 252, 151, 0.3); color: var(--cl-success); font-size: 12px; font-weight: 600;" Text="+72 hs"></asp:Label>
                    </div>
                </div>
                <!-- COLUMNA DERECHA: Selección de Nuevo Horario (Interactiva) -->
                <div class="col-12 col-lg-7 d-flex flex-column gap-3">
                    <div class="card-hospital-panel p-4 shadow-sm">
                        <!-- Header de Selección -->
                        <div
                            class="d-flex align-items-center justify-content-between pb-3 mb-4 border-bottom border-light-subtle">
                            <div class="d-flex align-items-center gap-2">
                                <div class="rounded-2 d-flex align-items-center justify-content-center text-white flex-shrink-0"
                                    style="width: 36px; height: 36px; background-color: var(--cl-teal-container);">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">edit_calendar</span>
                                </div>
                                <div>
                                    <h2 class="h6 mb-0 fw-bold text-dark">Selección de Nuevo Horario</h2>
                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                        Seleccione profesional, fecha en calendario y
                        franja disponible
                                    </p>
                                </div>
                            </div>
                            <span class="badge"
                                style="background-color: var(--cl-card-container); color: #4F627E; font-size: 11px; padding: 6px 10px;">Paso
                    1 de 2</span>
                        </div>
                        <!-- Selector de Médico -->
                        <div class="mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <label class="form-label fw-bold mb-0 text-dark" for="ddlMedico" style="font-size: 14px;">
                                    Médico asignado
                                    <asp:Label ID="lblMismaEspecialidad" runat="server" CssClass="fw-normal text-muted" Style="font-size: 12px;" Text="(Misma especialidad: Cardiología Clínica)"></asp:Label>
                                </label>
                                <span class="d-flex align-items-center gap-1 fw-semibold" style="font-size: 11px; color: var(--cl-success);">
                                    <span class="rounded-circle d-inline-block" style="width: 7px; height: 7px; background-color: var(--cl-success);"></span>
                                    <asp:Label ID="lblMedicosDisponibles" runat="server" Text="3 médicos con agenda abierta"></asp:Label>
                                </span>
                            </div>
                            <div class="position-relative">
                                <span class="material-symbols-outlined position-absolute top-50 translate-middle-y ms-3" style="font-size: 20px; color: var(--cl-text-muted);">person_check</span>
                                <asp:DropDownList ID="ddlMedico" runat="server" ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlMedico_SelectedIndexChanged" CssClass="form-select ps-5 py-2 shadow-sm" Style="font-size: 14px; border-color: #E5EEFF;">
                                    <asp:ListItem Value="1" Text="Dr. Martín Soria — Disponible (Médico de cabecera actual)"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Dra. Lucía Valenzuela — Disponible"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Dr. Esteban Quirós — Disponible"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Calendario Mensual -->
                        <div class="p-3 rounded-3 mb-4" style="background-color: rgba(239, 244, 255, 0.65);">
                            <!-- Controles de Mes -->
                            <div class="d-flex align-items-center justify-content-between mb-3 px-1">
                                <div class="d-flex align-items-center gap-2">
                                    <asp:Label ID="lblMesCalendario" runat="server" CssClass="fw-bold text-dark" Style="font-size: 16px;" Text="Mayo 2025"></asp:Label>
                                    <asp:Label ID="lblDetalleCalendario" runat="server" CssClass="text-muted" Style="font-size: 13px;" Text="/ Turno Mañana"></asp:Label>
                                </div>
                                <div class="d-flex align-items-center gap-1">
                                    <asp:LinkButton ID="btnMesAnterior" runat="server" OnClick="btnMesAnterior_Click" CssClass="btn btn-sm card-hospital-panel p-1 px-2 text-muted shadow-sm" ToolTip="Mes anterior">
<span class="material-symbols-outlined" style="font-size: 18px;">chevron_left</span>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnMesHoy" runat="server" OnClick="btnMesHoy_Click" CssClass="btn btn-sm card-hospital-panel px-3 py-1 fw-bold shadow-sm" Style="color: var(--cl-teal-container); font-size: 12px;" Text="Hoy"></asp:LinkButton>
                                    <asp:LinkButton ID="btnMesSiguiente" runat="server" OnClick="btnMesSiguiente_Click" CssClass="btn btn-sm card-hospital-panel p-1 px-2 text-dark shadow-sm" ToolTip="Mes siguiente">
<span class="material-symbols-outlined" style="font-size: 18px;">chevron_right</span>
                                    </asp:LinkButton>
                                </div>
                            </div>
                            <!-- Cabecera de días -->
                            <div class="calendar-grid text-center fw-semibold text-muted text-uppercase mb-2" style="font-size: 11px; letter-spacing: 0.05em;">
                                <div>Lun</div>
                                <div>Mar</div>
                                <div>Mié</div>
                                <div>Jue</div>
                                <div>Vie</div>
                                <div>Sáb</div>
                                <div>Dom</div>
                            </div>
                            <!-- Días del mes: un ítem del Repeater por casilla (siempre múltiplo de 7, empezando en lunes) -->
                            <%--
    Campos que espera el Repeater (los carga el code-behind):
      Fecha (texto "yyyy-MM-dd"), Numero (día del mes), Titulo (texto al pasar el mouse),
      Habilitado (bool), Css (cell-disabled | cell-active-available | cell-current-release | cell-selected | cell-today),
      PuntoCss (d-none | dot-libre | dot-actual | dot-seleccionado | dot-hoy)
                            --%>
                            <div class="calendar-grid text-center font-monospace">
                                <asp:Repeater ID="rptDias" runat="server" OnItemCommand="rptDias_ItemCommand">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkDia" runat="server" CssClass='<%# "calendar-cell text-decoration-none " + Eval("Css") %>'
                                            CommandName="SeleccionarDia" CommandArgument='<%# Eval("Fecha") %>'
                                            Enabled='<%# (bool)Eval("Habilitado") %>' ToolTip='<%# Eval("Titulo") %>'>
<span><%# Eval("Numero") %></span>
<span class='calendar-dot <%# Eval("PuntoCss") %>'></span>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <!-- Leyenda del Calendario -->
                            <div class="d-flex flex-wrap align-items-center justify-content-center gap-3 mt-3 pt-2 text-muted" style="font-size: 11px;">
                                <span class="d-flex align-items-center gap-1">
                                    <span class="rounded-circle d-inline-block" style="width: 9px; height: 9px; background-color: var(--cl-teal-container);"></span>
                                    <asp:Label ID="lblLeyendaSeleccionado" runat="server" Text="Seleccionado (29/05)"></asp:Label>
                                </span>
                                <span class="d-flex align-items-center gap-1">
                                    <span class="rounded-circle d-inline-block" style="width: 9px; height: 9px; background-color: var(--cl-success);"></span>
                                    Turnos disponibles
                                </span>
                                <span class="d-flex align-items-center gap-1">
                                    <span class="rounded-circle d-inline-block" style="width: 9px; height: 9px; background-color: var(--cl-danger);"></span>
                                    <asp:Label ID="lblLeyendaActual" runat="server" Text="Turno actual a liberar (26/05)"></asp:Label>
                                </span>
                            </div>
                        </div>
                        <!-- Grilla de Horarios / Bloques tipo chip -->
                        <div class="mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="fw-bold text-dark d-flex align-items-center gap-1" style="font-size: 14px;">
                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-teal-primary);">schedule</span>
                                    <span>Horarios disponibles para
                                        <asp:Label ID="lblFechaHorarios" runat="server" Text="Jueves 29 de Mayo"></asp:Label>:</span>
                                </span>
                                <span class="text-muted" style="font-size: 12px;">Bloques de 60 min</span>
                            </div>
                            <%--
    Campos que espera el Repeater (los carga el code-behind):
      Hora (int, ej: 9), Texto ("09:00 hs"), Titulo (texto al pasar el mouse), Disponible (bool),
      Css ("shadow-sm" | "slot-selected" | "time-slot-locked"),
      IndicadorCss ("slot-dot" | "material-symbols-outlined slot-icon"), IndicadorTexto ("" | "lock" | "check")
                            --%>
                            <div class="row g-2">
                                <asp:Repeater ID="rptHorarios" runat="server" OnItemCommand="rptHorarios_ItemCommand">
                                    <ItemTemplate>
                                        <div class="col-6 col-sm-3">
                                            <asp:LinkButton ID="lnkHorario" runat="server" CssClass='<%# "time-slot-btn text-decoration-none " + Eval("Css") %>'
                                                CommandName="SeleccionarHorario" CommandArgument='<%# Eval("Hora") %>'
                                                Enabled='<%# (bool)Eval("Disponible") %>' ToolTip='<%# Eval("Titulo") %>'>
                                                <span class="font-monospace"><%# Eval("Texto") %></span>
                                                <span class='<%# Eval("IndicadorCss") %>'><%# Eval("IndicadorTexto") %></span>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>

                        <!-- Campo Obligatorio: Motivo de la Reprogramación -->
                        <div class="mb-1">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <label class="form-label fw-bold mb-0 text-dark" for="txtMotivoReprogramacion"
                                    style="font-size: 14px;">
                                    Motivo de la reprogramación <span class="text-danger fw-bold">*</span>
                                </label>
                                <span class="text-muted font-monospace" id="char-counter" style="font-size: 11px;">0 / 500 caracteres</span>
                            </div>
                            <asp:TextBox ID="txtMotivoReprogramacion" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="3" CssClass="form-control shadow-sm" Style="font-size: 14px; border-color: #E5EEFF;" placeholder="Indique la causa del cambio de turno: solicitud del paciente, reprogramación médica, cambio de guardia, etc."></asp:TextBox>
                            <div class="d-flex align-items-center gap-1 mt-1 text-muted" style="font-size: 12px;">
                                <span class="material-symbols-outlined" style="font-size: 15px;">info</span>
                                <span>Este texto se guardará en el historial de auditoría clínica del turno.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 3. Bloque Inferior Informativo y Barra de Acciones -->
            <div class="mt-4 d-flex flex-column gap-3">
                <!-- Alerta informativa en azul suave (#EFF6FF) -->
                <div class="p-3 rounded-3 shadow-sm d-flex align-items-start gap-3"
                    style="background-color: var(--cl-info-bg); color: var(--cl-info-text);">
                    <div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0 mt-1"
                        style="width: 32px; height: 32px; background-color: rgba(37, 99, 235, 0.12); color: var(--cl-info-accent);">
                        <span class="material-symbols-outlined" style="font-size: 20px;">mark_email_read</span>
                    </div>
                    <div class="d-flex flex-column flex-grow-1">
                        <span class="fw-bold" style="font-size: 14px; color: var(--cl-info-text);">Notificación automática
                  programada</span>
                        <p class="mb-0 mt-1 lh-base" style="font-size: 14px; color: rgba(30, 58, 138, 0.95);">
                            El número de identificador se mantiene <strong class="fw-bold font-monospace" style="color: var(--cl-info-text);">(#<asp:Label ID="lblNotifNumero" runat="server" Text="1001"></asp:Label>)</strong> y se enviará un correo electrónico de confirmación inmediata al paciente (<asp:Label ID="lblNotifEmail" runat="server" CssClass="fw-semibold text-decoration-underline" Text="paciente@email.com"></asp:Label>) y recordatorio por WhatsApp avisando la nueva fecha y horario con el bono de atención actualizado.
                        </p>
                    </div>
                </div>
                <!-- Barra de Acciones y Guardado -->
                <div
                    class="card-hospital-panel p-3 shadow-sm d-flex flex-column flex-sm-row align-items-center justify-content-between gap-3">
                    <!-- Resumen diferencial en pastilla -->
                    <div class="d-flex align-items-center gap-2 p-2 px-3 rounded-2 w-100 w-sm-auto"
                        style="background-color: var(--cl-card-low);">
                        <span class="material-symbols-outlined"
                            style="font-size: 20px; color: var(--cl-teal-primary);">swap_horiz</span>
                        <div class="d-flex align-items-center gap-2 flex-wrap" style="font-size: 13px;">
                            <asp:Label ID="lblBarraAnterior" runat="server" CssClass="text-muted text-decoration-line-through font-monospace" Text="Lun 26 Mayo 10:00 hs"></asp:Label>
                            <span class="fw-bold" style="color: var(--cl-teal-primary);">➔</span>
                            <asp:Label ID="lblBarraNuevo" runat="server" CssClass="fw-bold font-monospace" Style="color: var(--cl-teal-container); font-size: 14px;" Text="Jueves 29 Mayo 11:00 hs"></asp:Label>
                        </div>
                    </div>
                    <!-- Botonera -->
                    <div class="d-flex align-items-center gap-3 w-100 w-sm-auto justify-content-end">
                        <asp:HyperLink ID="lnkCancelar" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="btn btn-cancel-custom shadow-sm" Text="Cancelar"></asp:HyperLink>
                        <asp:LinkButton ID="btnGuardarCambios" runat="server" OnClick="btnGuardarCambios_Click" CssClass="btn btn-teal-action shadow">
                            <span class="material-symbols-outlined" style="font-size: 19px;">check_circle</span>
                            <span>Guardar cambios</span>
                        </asp:LinkButton>

                    </div>
                </div>
            </div>
        </div>
        <%-- ===== FIN del contenido pegado ===== --%>
    </div>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/reprogramar-turno.js") %>'></script>
</asp:Content>
