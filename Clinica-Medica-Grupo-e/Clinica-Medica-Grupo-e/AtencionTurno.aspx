<%@ Page Title="Atención del turno - Panel Médico" Language="C#" MasterPageFile="~/Medico.Master" AutoEventWireup="true" CodeBehind="AtencionTurno.aspx.cs" Inherits="Clinica_Medica_Grupo_e.AtencionTurno" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntTitulo" ContentPlaceHolderID="TituloHeader" runat="server">
    <div class="cl-header-title fw-semibold text-dark lh-sm">Atención del turno</div>
    <div class="cl-header-subtitle text-secondary small">Registro de la consulta médica</div>
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">

    <%-- Error al cargar la página (sin turno elegido, turno de otro médico, etc.) --%>
    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-2">
        <asp:Label ID="lblError" runat="server"></asp:Label>
        <asp:HyperLink ID="hlVolverError" runat="server" NavigateUrl="~/MisTurnos.aspx" CssClass="btn btn-sm btn-light border">
            <i class="bi bi-arrow-left"></i> Volver a mis turnos
        </asp:HyperLink>
    </asp:Panel>

    <asp:PlaceHolder ID="phContenido" runat="server">

        <!-- RUTA Y VOLVER -->
        <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-2 mb-3">
            <nav aria-label="Ruta de navegación" class="cl-atencion-breadcrumb d-flex align-items-center gap-1">
                <asp:HyperLink ID="hlBreadcrumbMisTurnos" runat="server" NavigateUrl="~/MisTurnos.aspx" CssClass="text-decoration-none d-flex align-items-center gap-1">
                    <i class="bi bi-calendar3"></i>
                    <span>Mis turnos</span>
                </asp:HyperLink>
                <i class="bi bi-chevron-right text-muted cl-atencion-text-10"></i>
                <asp:Label ID="lblTurnoBreadcrumb" runat="server" CssClass="fw-semibold cl-atencion-color-primario" Text="Atención del turno #0"></asp:Label>
            </nav>
            <asp:HyperLink ID="hlVolverMisTurnos" runat="server" NavigateUrl="~/MisTurnos.aspx" CssClass="cl-card cl-atencion-btn-volver btn btn-sm d-inline-flex align-items-center gap-1 text-decoration-none px-3 py-1">
                <i class="bi bi-arrow-left"></i>
                <span>Volver a mis turnos</span>
            </asp:HyperLink>
        </div>

        <!-- CABECERA -->
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3 mb-4">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <h1 class="cl-atencion-titulo h3 fw-bold mb-0 text-dark">Atención de Consulta Médica</h1>
                <asp:Label ID="lblEstadoCabecera" runat="server" CssClass="cl-estado cl-estado-nuevo text-uppercase" Text="En atención"></asp:Label>
                <span class="cl-atencion-pill-numero badge rounded-pill d-inline-flex align-items-center gap-1 py-1 px-3">
                    <i class="bi bi-hash"></i>
                    <asp:Label ID="lblNumeroTurno" runat="server" Text="0"></asp:Label>
                </span>
            </div>

            <%-- Sin datos en la base: el cronómetro queda oculto (Visible="false"). --%>
            <asp:Panel ID="pnlCronometro" runat="server" Visible="false" CssClass="cl-card d-inline-flex align-items-center gap-2 px-3 py-2">
                <div class="cl-atencion-box cl-atencion-color-primario d-flex align-items-center justify-content-center p-2">
                    <i class="bi bi-stopwatch fs-5"></i>
                </div>
                <div>
                    <div class="cl-atencion-caption lh-1">Duración activa</div>
                    <div class="fw-semibold text-dark font-monospace cl-text-14">00:00 min</div>
                </div>
            </asp:Panel>
        </div>

        <!-- RESULTADO DE LA ÚLTIMA ACCIÓN -->
        <asp:Panel ID="pnlMensajeExito" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center gap-2">
            <i class="bi bi-check-circle-fill"></i>
            <asp:Label ID="lblMensajeExito" runat="server"></asp:Label>
        </asp:Panel>
        <asp:Panel ID="pnlMensajeAviso" runat="server" Visible="false" CssClass="alert alert-warning d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <asp:Label ID="lblMensajeAviso" runat="server"></asp:Label>
        </asp:Panel>

        <!-- AVISO: DATOS ADMINISTRATIVOS DE SOLO LECTURA -->
        <div class="cl-card cl-atencion-box p-3 mb-4 border-0 d-flex align-items-start align-items-sm-center gap-3">
            <div class="cl-atencion-banner-icon rounded-3 d-flex align-items-center justify-content-center p-2 text-white flex-shrink-0">
                <i class="bi bi-shield-check fs-5"></i>
            </div>
            <div class="flex-grow-1">
                <span class="cl-atencion-banner-title fw-semibold">Modo consulta</span>
                <p class="cl-atencion-banner-text mb-0 text-secondary mt-1">
                    Los datos administrativos y del turno son de solo lectura. Cualquier corrección de los datos del paciente debe hacerse desde Recepción.
                </p>
            </div>
        </div>

        <div class="row g-4 align-items-start">

            <!-- ============ COLUMNA IZQUIERDA: SOLO LECTURA ============ -->
            <div class="col-lg-5 d-flex flex-column gap-4">

                <!-- 1. PACIENTE -->
                <section class="cl-card p-4">
                    <div class="d-flex align-items-center justify-content-between pb-3 border-bottom mb-3">
                        <div class="d-flex align-items-center gap-3">
                            <asp:Label ID="lblAvatarIniciales" runat="server" CssClass="cl-atencion-avatar" Text="--"></asp:Label>
                            <div>
                                <div class="cl-atencion-caption">Paciente asignado</div>
                                <h2 class="h6 fw-bold mb-0 text-dark">
                                    <asp:Label ID="lblPacienteNombre" runat="server" Text="Apellido, Nombre"></asp:Label>
                                </h2>
                            </div>
                        </div>
                        <span class="cl-atencion-lock">
                            <i class="bi bi-lock"></i>
                            Solo lectura
                        </span>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">DNI / Documento</div>
                            <asp:Label ID="lblPacienteDni" runat="server" CssClass="d-block fw-semibold font-monospace cl-text-14" Text="-"></asp:Label>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Edad y nacimiento</div>
                            <div class="cl-text-13 text-dark">
                                <asp:Label ID="lblPacienteEdad" runat="server" Text="-"></asp:Label>
                                <asp:Label ID="lblPacienteNacimiento" runat="server" CssClass="text-muted cl-text-12"></asp:Label>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Teléfono de contacto</div>
                            <asp:Label ID="lblPacienteTelefono" runat="server" CssClass="d-block text-dark font-monospace cl-text-13" Text="-"></asp:Label>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Correo electrónico</div>
                            <asp:Label ID="lblPacienteEmail" runat="server" CssClass="d-block text-dark text-truncate cl-text-13" Text="-"></asp:Label>
                        </div>
                    </div>

                    <div class="cl-atencion-box p-3 mb-2 d-flex align-items-start gap-2">
                        <i class="bi bi-patch-check-fill text-success fs-5"></i>
                        <div>
                            <div class="cl-atencion-caption">Cobertura médica</div>
                            <asp:Label ID="lblPacienteCobertura" runat="server" CssClass="d-block fw-semibold text-dark cl-text-13" Text="Particular"></asp:Label>
                            <asp:Label ID="lblPacienteAfiliado" runat="server" CssClass="d-block text-muted cl-atencion-dato-label"></asp:Label>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-1 text-muted cl-atencion-dato-label">
                        <i class="bi bi-shield-lock"></i>
                        <span>Datos del paciente gestionados por Recepción</span>
                    </div>
                </section>

                <!-- 2. TURNO -->
                <section class="cl-card p-4">
                    <div class="d-flex align-items-center justify-content-between pb-3 border-bottom mb-3">
                        <div class="d-flex align-items-center gap-2 text-dark">
                            <i class="bi bi-calendar-check cl-atencion-color-primario"></i>
                            <h3 class="h6 fw-bold mb-0">Detalle del turno programado</h3>
                        </div>
                        <asp:Label ID="lblEstadoTurno" runat="server" CssClass="cl-estado cl-estado-nuevo" Text="Nuevo"></asp:Label>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Fecha de atención</div>
                            <asp:Label ID="lblTurnoFecha" runat="server" CssClass="d-block fw-semibold text-dark cl-text-13" Text="-"></asp:Label>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Horario programado</div>
                            <asp:Label ID="lblTurnoHora" runat="server" CssClass="d-block fw-semibold text-dark font-monospace cl-text-13" Text="-"></asp:Label>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Especialidad</div>
                            <asp:Label ID="lblTurnoEspecialidad" runat="server" CssClass="d-block text-dark cl-text-13" Text="-"></asp:Label>
                        </div>
                        <div class="col-6">
                            <div class="cl-atencion-dato-label">Médico</div>
                            <asp:Label ID="lblTurnoMedico" runat="server" CssClass="d-block text-dark cl-text-13" Text="-"></asp:Label>
                        </div>

                        <%-- Sin datos en la base (no hay consultorio ni sede): queda oculto. --%>
                        <asp:PlaceHolder ID="phConsultorioSede" runat="server" Visible="false">
                            <div class="col-6">
                                <div class="cl-atencion-dato-label">Consultorio asignado</div>
                                <div class="text-dark cl-text-13">-</div>
                            </div>
                            <div class="col-6">
                                <div class="cl-atencion-dato-label">Sede clínica</div>
                                <div class="text-dark cl-text-13">-</div>
                            </div>
                        </asp:PlaceHolder>
                    </div>

                    <div class="p-2 cl-atencion-box d-flex align-items-center gap-2 text-secondary cl-atencion-dato-label">
                        <i class="bi bi-info-circle text-muted"></i>
                        <span>La fecha, hora y datos del paciente no pueden modificarse desde el módulo médico.</span>
                    </div>
                </section>

                <!-- 3. MOTIVO (RECEPCIÓN) -->
                <section class="cl-card p-4">
                    <div class="d-flex align-items-center gap-2 mb-2 cl-atencion-color-primario">
                        <i class="bi bi-chat-left-quote"></i>
                        <span class="cl-atencion-caption fw-semibold cl-atencion-color-primario">Cargado en recepción</span>
                    </div>
                    <div class="cl-atencion-motivo p-3 rounded-2">
                        <div class="fw-semibold text-dark mb-1 cl-text-13">Motivo informado en recepción:</div>
                        <asp:Label ID="lblMotivoRecepcion" runat="server" CssClass="d-block mb-0 text-secondary cl-atencion-texto-largo" Text="Sin motivo informado."></asp:Label>
                    </div>
                </section>

                <!-- 4. CONSULTAS ANTERIORES CON ESTE MÉDICO -->
                <section class="cl-card p-4">
                    <div class="d-flex align-items-center justify-content-between pb-2 mb-2">
                        <div class="d-flex align-items-center gap-2 text-dark">
                            <i class="bi bi-clock-history cl-atencion-color-primario"></i>
                            <h3 class="h6 fw-bold mb-0">
                                <asp:Label ID="lblTituloHistorial" runat="server" Text="Consultas anteriores (0)"></asp:Label>
                            </h3>
                        </div>
                        <span class="badge rounded-pill bg-light text-secondary border cl-atencion-dato-label">Historial</span>
                    </div>
                    <p class="text-muted mb-3 cl-text-12">Evoluciones clínicas registradas previamente en este centro:</p>

                    <div class="d-flex flex-column gap-2">
                        <%--
                            Repeater rptConsultasAnteriores: una fila por atención anterior.
                            Campos: Fecha, Motivo, Evolucion, SignosTexto, TieneSignos, Prescripcion, TienePrescripcion, Firma.
                            La primera consulta (la más reciente) se muestra abierta.
                        --%>
                        <asp:Repeater ID="rptConsultasAnteriores" runat="server">
                            <ItemTemplate>
                                <details class="cl-atencion-box cl-atencion-historial p-2 rounded-2" <%# Container.ItemIndex == 0 ? "open" : "" %>>
                                    <summary class="d-flex align-items-center justify-content-between py-1">
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="bi bi-caret-right-fill text-muted cl-atencion-dato-label"></i>
                                            <span class="fw-semibold text-dark cl-text-13"><%#: Eval("Fecha") %></span>
                                            <span class="text-muted cl-text-12">· <%#: Eval("Motivo") %></span>
                                        </div>
                                        <span class="cl-estado cl-estado-cerrado">
                                            <i class="bi bi-check-circle"></i>Cerrado
                                        </span>
                                    </summary>
                                    <div class="pt-2 ps-3 border-top mt-1 cl-text-12">
                                        <p class="mb-1 text-dark cl-atencion-texto-largo"><strong>Diagnóstico:</strong> <%#: Eval("Evolucion") %></p>
                                        <asp:PlaceHolder ID="phSignos" runat="server" Visible='<%# (bool)Eval("TieneSignos") %>'>
                                            <p class="mb-1 text-secondary"><strong>Signos vitales:</strong> <%#: Eval("SignosTexto") %></p>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phPrescripcion" runat="server" Visible='<%# (bool)Eval("TienePrescripcion") %>'>
                                            <p class="mb-1 text-secondary cl-atencion-texto-largo"><strong>Indicaciones:</strong> <%#: Eval("Prescripcion") %></p>
                                        </asp:PlaceHolder>
                                        <span class="text-muted cl-atencion-dato-label"><%#: Eval("Firma") %></span>
                                    </div>
                                </details>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlSinHistorial" runat="server" Visible="false" CssClass="cl-atencion-box p-3 text-muted cl-text-12">
                            No hay consultas anteriores registradas de este paciente con este médico.
                        </asp:Panel>
                    </div>

                    <%-- Sin historia clínica en el sistema: queda oculto. --%>
                    <asp:LinkButton ID="btnVerHistoriaClinica" runat="server" Visible="false" OnClick="btnVerHistoriaClinica_Click"
                        CssClass="btn btn-link w-100 text-decoration-none mt-2 p-0 d-flex align-items-center justify-content-center gap-1 cl-atencion-color-primario cl-text-13">
                        <i class="bi bi-folder2-open"></i>
                        <span>Ver historia clínica completa del paciente</span>
                    </asp:LinkButton>
                </section>
            </div>

            <!-- ============ COLUMNA DERECHA: ATENCIÓN DEL MÉDICO ============ -->
            <div class="col-lg-7 d-flex flex-column gap-4">

                <%-- EDICIÓN: solo para turnos pendientes (Nuevo o Reprogramado) de hoy o de días anteriores. --%>
                <asp:PlaceHolder ID="phEdicion" runat="server">
                    <%-- data-paciente y data-numero los usa Scripts/atencion-turno.js para armar los mensajes. --%>
                    <asp:Panel ID="pnlFormularioAtencion" runat="server" ClientIDMode="Static" CssClass="cl-card p-4">

                        <div class="d-flex align-items-center justify-content-between gap-2 pb-2 border-bottom mb-3">
                            <div>
                                <h2 class="h5 fw-bold mb-1 text-dark">Evolución de la consulta y acto médico</h2>
                                <p class="text-secondary mb-0 cl-text-13">
                                    Ingrese el diagnóstico, las indicaciones y las notas clínicas para incorporarlas a la historia del paciente.
                                </p>
                            </div>
                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1 cl-atencion-dato-label">
                                <i class="bi bi-pencil-square me-1"></i>Edición habilitada
                            </span>
                        </div>

                        <!-- Signos vitales (opcionales) -->
                        <div class="mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="cl-atencion-caption fw-semibold">Signos vitales y mediciones rápidas</span>
                                <span class="text-muted cl-text-12">Opcionales</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-6 col-sm-3">
                                    <div class="cl-atencion-box p-2">
                                        <label for="<%= txtTensionArterial.ClientID %>" class="cl-atencion-vital-label text-muted d-block">Tensión arterial</label>
                                        <div class="d-flex align-items-center justify-content-between mt-1 gap-1">
                                            <asp:TextBox ID="txtTensionArterial" runat="server" MaxLength="7" placeholder="120/80"
                                                CssClass="cl-atencion-vital-input form-control form-control-sm border-0 bg-transparent p-0 fw-semibold text-dark shadow-none"></asp:TextBox>
                                            <span class="cl-atencion-vital-label text-muted">mmHg</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-sm-3">
                                    <div class="cl-atencion-box p-2">
                                        <label for="<%= txtFrecuenciaCardiaca.ClientID %>" class="cl-atencion-vital-label text-muted d-block">Frecuencia cardíaca</label>
                                        <div class="d-flex align-items-center justify-content-between mt-1 gap-1">
                                            <asp:TextBox ID="txtFrecuenciaCardiaca" runat="server" MaxLength="3" placeholder="72"
                                                CssClass="cl-atencion-vital-input form-control form-control-sm border-0 bg-transparent p-0 fw-semibold text-dark shadow-none"></asp:TextBox>
                                            <span class="cl-atencion-vital-label text-muted">lpm</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-sm-3">
                                    <div class="cl-atencion-box p-2">
                                        <label for="<%= txtSaturacionOxigeno.ClientID %>" class="cl-atencion-vital-label text-muted d-block">Saturación O2</label>
                                        <div class="d-flex align-items-center justify-content-between mt-1 gap-1">
                                            <asp:TextBox ID="txtSaturacionOxigeno" runat="server" MaxLength="3" placeholder="98"
                                                CssClass="cl-atencion-vital-input form-control form-control-sm border-0 bg-transparent p-0 fw-semibold text-dark shadow-none"></asp:TextBox>
                                            <span class="cl-atencion-vital-label text-muted">%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6 col-sm-3">
                                    <div class="cl-atencion-box p-2">
                                        <label for="<%= txtPesoCorporal.ClientID %>" class="cl-atencion-vital-label text-muted d-block">Peso corporal</label>
                                        <div class="d-flex align-items-center justify-content-between mt-1 gap-1">
                                            <asp:TextBox ID="txtPesoCorporal" runat="server" MaxLength="6" placeholder="78,5"
                                                CssClass="cl-atencion-vital-input form-control form-control-sm border-0 bg-transparent p-0 fw-semibold text-dark shadow-none"></asp:TextBox>
                                            <span class="cl-atencion-vital-label text-muted">kg</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Evolución (obligatoria para cerrar) -->
                        <div class="mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <label for="txtEvolucionClinica" class="form-label fw-semibold text-dark mb-0 cl-text-14">
                                    Observaciones y diagnóstico clínico <span id="spanEvolucionObligatoria" class="text-danger">*</span>
                                </label>
                                <span class="text-muted cl-atencion-dato-label">
                                    <span id="lblContadorCaracteres">0</span> / 2000 caracteres
                                </span>
                            </div>

                            <!-- Frases rápidas: las inserta Scripts/atencion-turno.js -->
                            <div class="d-flex flex-wrap align-items-center gap-1 p-2 bg-light rounded-top border border-bottom-0">
                                <button type="button" class="cl-atencion-snippet" data-snippet="TA regular. ">+ TA regular</button>
                                <button type="button" class="cl-atencion-snippet" data-snippet="R1-R2 normofonéticos, sin soplos audibles. ">+ R1-R2 normofonéticos</button>
                                <button type="button" class="cl-atencion-snippet" data-snippet="ECG de 12 derivaciones sin hallazgos patológicos. ">+ ECG normal</button>
                                <button type="button" class="cl-atencion-snippet" data-snippet="Apto médico otorgado por 12 meses. ">+ Apto otorgado</button>
                            </div>

                            <asp:TextBox ID="txtEvolucionClinica" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="8" MaxLength="2000"
                                CssClass="cl-atencion-textarea form-control rounded-bottom rounded-top-0 border shadow-none"
                                placeholder="Describa el examen físico, los hallazgos, el diagnóstico presuntivo o de certeza y el plan terapéutico..."></asp:TextBox>
                            <div id="lblErrorEvolucionCliente" class="text-danger small mt-1 d-none">Complete la evolución clínica antes de cerrar el turno.</div>
                            <asp:Label ID="lblErrorEvolucion" runat="server" Visible="false" CssClass="d-block text-danger small mt-1"></asp:Label>
                        </div>

                        <!-- Prescripción (opcional) -->
                        <div class="mb-4">
                            <label for="<%= txtPrescripcion.ClientID %>" class="form-label fw-semibold text-dark mb-1 cl-text-14">
                                Prescripción / indicaciones farmacológicas o estudios <span class="text-muted fw-normal cl-text-12">(opcional)</span>
                            </label>
                            <asp:TextBox ID="txtPrescripcion" runat="server" TextMode="MultiLine" Rows="3" MaxLength="1000"
                                CssClass="cl-atencion-textarea cl-atencion-box form-control border-0 shadow-none"
                                placeholder="Sin medicación farmacológica requerida en este acto médico."></asp:TextBox>
                        </div>

                        <!-- Resolución del turno -->
                        <div class="mb-4">
                            <span class="form-label d-block fw-semibold text-dark mb-2 cl-text-14">
                                Resolución y estado final del turno <span class="text-danger">*</span>
                            </span>

                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <div id="pnlOpcionCerrado" class="cl-atencion-radio-card activo-cerrado h-100">
                                        <div class="form-check p-0 d-flex align-items-start gap-2">
                                            <asp:RadioButton ID="rdoCerrado" runat="server" ClientIDMode="Static" GroupName="ResolucionTurno" Checked="true" />
                                            <label class="form-check-label w-100" for="rdoCerrado" role="button">
                                                <span class="cl-estado cl-estado-cerrado mb-1">
                                                    <i class="bi bi-check-circle"></i>Cerrado
                                                </span>
                                                <span class="d-block text-secondary mt-1 cl-atencion-texto-chico">
                                                    Consulta finalizada con registro en la historia clínica del paciente.
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div id="pnlOpcionNoAsistio" class="cl-atencion-radio-card h-100">
                                        <div class="form-check p-0 d-flex align-items-start gap-2">
                                            <asp:RadioButton ID="rdoNoAsistio" runat="server" ClientIDMode="Static" GroupName="ResolucionTurno" />
                                            <label class="form-check-label w-100" for="rdoNoAsistio" role="button">
                                                <span class="cl-estado cl-estado-noasistio mb-1">
                                                    <i class="bi bi-person-x"></i>No asistió
                                                </span>
                                                <span class="d-block text-secondary mt-1 cl-atencion-texto-chico">
                                                    El paciente no se presentó al consultorio.
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- El texto lo cambia Scripts/atencion-turno.js según la opción elegida -->
                            <div id="lblMensajeEstadoResolucion" class="p-2 cl-atencion-box rounded-2 mt-2 d-flex align-items-center gap-2 text-secondary cl-text-12">
                                <i class="bi bi-check-circle-fill text-success fs-6"></i>
                                <span>Al marcar como <strong>"Cerrado"</strong>, el turno finaliza y la consulta queda registrada en la ficha del paciente.</span>
                            </div>
                        </div>

                        <asp:Panel ID="pnlErrorAccion" runat="server" Visible="false" CssClass="alert alert-danger py-2 cl-text-13">
                            <asp:Label ID="lblErrorAccion" runat="server"></asp:Label>
                        </asp:Panel>

                        <!-- Botones -->
                        <div class="d-flex flex-column flex-sm-row align-items-stretch align-items-sm-center justify-content-between gap-3 pt-3 border-top">
                            <div class="d-flex align-items-center gap-2">
                                <%-- Sin certificado ni borradores en el sistema: quedan ocultos. --%>
                                <asp:LinkButton ID="btnImprimirCertificado" runat="server" Visible="false" OnClick="btnImprimirCertificado_Click"
                                    CssClass="btn btn-light text-secondary d-inline-flex align-items-center gap-1 border cl-text-13">
                                    <i class="bi bi-printer"></i>
                                    <span>Imprimir certificado</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnGuardarBorrador" runat="server" Visible="false" OnClick="btnGuardarBorrador_Click"
                                    CssClass="btn btn-light text-secondary d-inline-flex align-items-center gap-1 border cl-text-13">
                                    <i class="bi bi-floppy"></i>
                                    <span>Guardar borrador</span>
                                </asp:LinkButton>
                            </div>

                            <div class="d-flex align-items-center gap-2 justify-content-end">
                                <asp:HyperLink ID="hlCancelar" runat="server" NavigateUrl="~/MisTurnos.aspx" CssClass="btn btn-link text-secondary text-decoration-none cl-text-13">
                                    Cancelar
                                </asp:HyperLink>
                                <%-- Abre el modal de confirmación (Scripts/atencion-turno.js valida la evolución antes). --%>
                                <button type="button" id="btnGuardarFinal" class="btn cl-atencion-btn-primario d-inline-flex align-items-center gap-2 px-4 py-2">
                                    <i class="bi bi-check2-circle fs-5"></i>
                                    <span>Guardar atención y finalizar turno</span>
                                </button>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- MODAL DE CONFIRMACIÓN -->
                    <div class="modal fade" id="modalConfirmacionCierre" tabindex="-1" aria-labelledby="lblModalTitulo" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content cl-card border-0 p-3 shadow-lg">
                                <div class="modal-body text-center p-3">
                                    <div class="cl-atencion-modal-icon rounded-circle d-inline-flex align-items-center justify-content-center p-3 mb-3">
                                        <i class="bi bi-check-circle fs-2"></i>
                                    </div>
                                    <h3 class="h5 fw-bold text-dark mb-2" id="lblModalTitulo">¿Confirmar cierre de la consulta?</h3>
                                    <p id="lblModalTexto" class="text-secondary mb-4 cl-text-13">
                                        El turno será registrado como <strong>Cerrado</strong>.
                                    </p>
                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                        <button type="button" class="btn btn-light border px-3 cl-text-13" data-bs-dismiss="modal">Revisar notas</button>
                                        <asp:Button ID="btnConfirmarCierreTurno" runat="server" Text="Confirmar y guardar"
                                            OnClick="btnConfirmarCierreTurno_Click" CssClass="btn cl-atencion-btn-primario px-4" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <%-- LECTURA: turnos ya resueltos (Cerrado / No asistió), cancelados o de un día futuro. --%>
                <asp:PlaceHolder ID="phLectura" runat="server" Visible="false">
                    <section class="cl-card p-4">
                        <div class="d-flex align-items-center justify-content-between gap-2 pb-2 border-bottom mb-3">
                            <div>
                                <h2 class="h5 fw-bold mb-1 text-dark">Registro de la consulta</h2>
                                <p class="text-secondary mb-0 cl-text-13">Este turno no se puede editar: se muestra en modo de solo lectura.</p>
                            </div>
                            <span class="cl-atencion-lock">
                                <i class="bi bi-lock"></i>
                                Solo lectura
                            </span>
                        </div>

                        <div class="cl-atencion-box p-3 mb-3 d-flex align-items-center gap-2 text-secondary cl-text-13">
                            <i class="bi bi-info-circle"></i>
                            <asp:Label ID="lblLecturaMensaje" runat="server"></asp:Label>
                        </div>

                        <asp:PlaceHolder ID="phAtencionRegistrada" runat="server" Visible="false">
                            <div class="mb-4">
                                <span class="cl-atencion-caption fw-semibold d-block mb-2">Signos vitales</span>
                                <div class="row g-2">
                                    <div class="col-6 col-sm-3">
                                        <div class="cl-atencion-box p-2">
                                            <span class="cl-atencion-vital-label text-muted d-block">Tensión arterial</span>
                                            <asp:Label ID="lblLecturaTension" runat="server" CssClass="fw-semibold text-dark" Text="-"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-6 col-sm-3">
                                        <div class="cl-atencion-box p-2">
                                            <span class="cl-atencion-vital-label text-muted d-block">Frecuencia cardíaca</span>
                                            <asp:Label ID="lblLecturaFrecuencia" runat="server" CssClass="fw-semibold text-dark" Text="-"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-6 col-sm-3">
                                        <div class="cl-atencion-box p-2">
                                            <span class="cl-atencion-vital-label text-muted d-block">Saturación O2</span>
                                            <asp:Label ID="lblLecturaSaturacion" runat="server" CssClass="fw-semibold text-dark" Text="-"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-6 col-sm-3">
                                        <div class="cl-atencion-box p-2">
                                            <span class="cl-atencion-vital-label text-muted d-block">Peso corporal</span>
                                            <asp:Label ID="lblLecturaPeso" runat="server" CssClass="fw-semibold text-dark" Text="-"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <span class="fw-semibold text-dark d-block mb-1 cl-text-14">Observaciones y diagnóstico clínico</span>
                                <asp:Label ID="lblLecturaEvolucion" runat="server" CssClass="d-block cl-atencion-box p-3 text-dark cl-atencion-texto-largo"></asp:Label>
                            </div>

                            <div class="mb-3">
                                <span class="fw-semibold text-dark d-block mb-1 cl-text-14">Prescripción / indicaciones</span>
                                <asp:Label ID="lblLecturaPrescripcion" runat="server" CssClass="d-block cl-atencion-box p-3 text-secondary cl-atencion-texto-largo"></asp:Label>
                            </div>

                            <div class="text-muted cl-atencion-dato-label d-flex align-items-center gap-1">
                                <i class="bi bi-clock-history"></i>
                                <asp:Label ID="lblLecturaFechaRegistro" runat="server"></asp:Label>
                            </div>
                        </asp:PlaceHolder>
                    </section>
                </asp:PlaceHolder>

                <!-- NOTA LEGAL -->
                <div class="d-flex align-items-center justify-content-between px-2 text-muted cl-atencion-dato-label">
                    <%-- Sin borradores en el sistema: queda oculto. --%>
                    <asp:PlaceHolder ID="phUltimoBorrador" runat="server" Visible="false">
                        <span class="d-flex align-items-center gap-1">
                            <i class="bi bi-clock-history"></i>
                            Última actualización de borrador: -
                        </span>
                    </asp:PlaceHolder>
                    <span class="d-flex align-items-center gap-1 ms-auto">
                        <i class="bi bi-shield-lock"></i>
                        Registro auditable conforme Ley 26.529 de Derechos del Paciente
                    </span>
                </div>
            </div>
        </div>
    </asp:PlaceHolder>
</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/atencion-turno.js") %>'></script>
</asp:Content>
