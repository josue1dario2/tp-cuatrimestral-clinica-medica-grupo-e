<%@ Page Title="Turno confirmado" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="TurnoConfirmado.aspx.cs" Inherits="Clinica_Medica_Grupo_e.TurnoConfirmado" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="turno-confirmado">
        
        <asp:HiddenField ID="hfIdTurno" runat="server" />
        
        <div class="container-fluid" style="max-width: 920px;">
            <!-- Estado y Nav -->
            <div class="d-flex align-items-center justify-content-between mb-3 no-print">
                <div class="d-flex align-items-center gap-2" style="font-size: 13px; font-weight: 500; color: var(--cl-text-secondary);">
                    <asp:HyperLink ID="lnkBreadcrumbTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="text-decoration-none d-flex align-items-center gap-1" Style="color: var(--cl-text-secondary);">
                        <span class="material-symbols-outlined" style="font-size: 16px;">calendar_month</span>
                        <span>Turnos</span>
                    </asp:HyperLink>

                    <span style="color: var(--cl-text-muted);">/</span>
                    <asp:HyperLink ID="lnkBreadcrumbNuevo" runat="server" NavigateUrl="~/NuevoTurno.aspx" CssClass="text-decoration-none" Style="color: var(--cl-text-secondary);" Text="Nuevo Turno"></asp:HyperLink>
                    <span style="color: var(--cl-text-muted);">/</span>
                    <span class="fw-semibold" style="color: var(--cl-text-main);">Confirmación</span>
                </div>
                <div class="d-flex align-items-center gap-2 px-3 py-1 rounded-pill" style="background-color: var(--cl-surface-container); font-size: 12px; color: var(--cl-text-secondary);">
                    <span class="rounded-circle" style="width: 8px; height: 8px; background-color: var(--cl-success);"></span>
                    <span>Transacción ID: #<asp:Label ID="lblTransaccion" runat="server" Text="SYS-882914-OK"></asp:Label></span>
                </div>
            </div>
            <!-- Contenedor principal central para tarjetas -->
            <div class="d-flex flex-column gap-4">
                <!-- Tarjeta Principal de Confirmación -->
                <div class="card-custom p-4 p-md-5 text-center position-relative overflow-hidden">
                    <!-- Brillo ambiental sutil -->
                    <div class="position-absolute top-0 start-50 translate-middle-x rounded-circle" style="width: 280px; height: 280px; background: rgba(0, 102, 42, 0.05); filter: blur(50px); pointer-events: none;"></div>
                    <!-- Icono de éxito animado -->
                    <div class="d-flex justify-content-center mb-3 position-relative">
                        <div class="rounded-circle d-flex align-items-center justify-content-center animate-badge-bounce" style="width: 80px; height: 80px; background-color: rgba(0, 102, 42, 0.1);">
                            <div class="rounded-circle d-flex align-items-center justify-content-center text-white shadow-sm" style="width: 56px; height: 56px; background-color: var(--cl-success);">
                                <span class="material-symbols-outlined" style="font-size: 34px; font-variation-settings: 'FILL' 1;">check</span>
                            </div>
                        </div>
                    </div>
                    <!-- Títulos de Éxito -->
                    <h1 class="fw-bold mb-2" style="font-size: 30px; letter-spacing: -0.02em; color: var(--cl-text-main);">¡Turno confirmado con éxito!
                    </h1>
                    <p class="mx-auto mb-4" style="max-width: 560px; font-size: 15px; color: var(--cl-text-secondary); line-height: 1.5;">
                        La cita médica ha sido agendada en el sistema asistencial y asignada en la agenda del profesional.
                    </p>
                    <!-- Área de identificadores y credenciales de turno -->
                    <div class="d-inline-flex flex-wrap align-items-center justify-content-center gap-2 px-3 py-2 rounded-3 mx-auto" style="background-color: var(--cl-surface-muted);">
                        <span class="text-uppercase text-muted" style="font-size: 11px; font-weight: 600; letter-spacing: 0.05em;">Código de Turno:</span>
                        <asp:Label ID="lblCodigoTurno" runat="server" ClientIDMode="Static" CssClass="font-monospace fw-bold px-1" Style="font-size: 18px; color: var(--cl-text-main); user-select: all;" Text="#1001"></asp:Label>
                        <button class="btn btn-sm btn-light border-0 d-flex align-items-center gap-1 py-1 px-2 rounded-2" id="copyCodeBtn" onclick="copyTurnCode()" title="Copiar identificador" type="button">
                            <span class="material-symbols-outlined" style="font-size: 16px;">content_copy</span>
                            <span id="copyFeedback" style="font-size: 12px; font-weight: 500;">Copiar</span>
                        </button>
                        <div class="mx-1" style="height: 16px; width: 1px; background-color: var(--cl-border);"></div>
                        <span class="badge rounded-pill d-inline-flex align-items-center gap-1" style="background-color: var(--cl-surface-container); color: var(--cl-text-main); font-size: 11px; font-weight: 600;">
                            <span class="rounded-circle" style="width: 6px; height: 6px; background-color: var(--cl-primary);"></span>
                            <asp:Label ID="lblEstado" runat="server" Text="NUEVO"></asp:Label>
                        </span>

                    </div>
                    <!-- Banner de aviso de éxito de color verde: se muestra solo si el paciente tiene email -->
                    <asp:Panel ID="pnlEmailEnviado" runat="server" CssClass="d-flex align-items-center gap-2 p-3 mt-3 mx-auto rounded-3 text-start" Style="max-width: 680px; background-color: var(--cl-success-light); color: var(--cl-success);">
                        <span class="material-symbols-outlined flex-shrink-0" style="font-size: 22px; font-variation-settings: 'FILL' 1;">mark_email_read</span>
                        <div style="font-size: 13.5px;">
                            Se envió la confirmación por correo electrónico a <strong>
                                <asp:Label ID="lblEmailConfirmacion" runat="server" Text="paciente@email.com"></asp:Label></strong> (con copia programada al recordatorio vía SMS).
                        </div>
                        </asp:Panel>
                        <!-- Ficha Resumen del Turno (2 Columnas) -->
                        <div class="mt-4 pt-2 text-start w-100">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <div class="d-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size: 20px; color: var(--cl-primary);">assignment</span>
                                    <span class="fw-bold text-uppercase" style="font-size: 13px; letter-spacing: 0.05em; color: var(--cl-text-main);">Ficha Resumen del Turno</span>
                                </div>
                                <span style="font-size: 12px; color: var(--cl-text-secondary);">Sede Central • Consultorios Externos</span>
                            </div>
                            <div class="row g-3">
                                <!-- Columna 1: Paciente Titular -->
                                <div class="col-12 col-md-6">
                                    <div class="p-3 rounded-3 h-100 d-flex flex-column justify-content-between" style="background-color: var(--cl-surface-muted);">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <span class="text-uppercase text-muted" style="font-size: 11px; font-weight: 600; letter-spacing: 0.05em;">Paciente Titular</span>
                                                <asp:Label ID="lblCobertura" runat="server" CssClass="badge" Style="background-color: var(--cl-surface-container); color: var(--cl-text-secondary); font-size: 11px;" Text="OSDE 210"></asp:Label>
                                            </div>
                                            <h3 class="fw-bold mb-3" style="font-size: 18px; color: var(--cl-text-main);">
                                                <asp:Label ID="lblPacienteNombre" runat="server" Text="González, Martín Nicolás"></asp:Label>
                                            </h3>

                                            <div class="d-flex flex-column gap-2" style="font-size: 13.5px; color: var(--cl-text-secondary);">
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">badge</span>
                                                    <span>DNI: <strong style="color: var(--cl-text-main);">
                                                        <asp:Label ID="lblPacienteDni" runat="server" Text="35.892.410"></asp:Label></strong></span>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">phone</span>
                                                    <span>Teléfono: <strong style="color: var(--cl-text-main);">
                                                        <asp:Label ID="lblPacienteTelefono" runat="server" Text="+54 11 4829-1122"></asp:Label></strong></span>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">shield</span>
                                                    <span>Nro Afiliado: <strong style="color: var(--cl-text-main);">
                                                        <asp:Label ID="lblNroAfiliado" runat="server" Text="490-28192801-01"></asp:Label></strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mt-3 p-2 rounded-2 d-flex align-items-center gap-2" style="background-color: rgba(255, 255, 255, 0.7); font-size: 11.5px; color: var(--cl-text-secondary);">
                                            <span class="material-symbols-outlined text-teal" style="font-size: 16px; color: var(--cl-primary);">verified_user</span>
                                            <span>Validación online de padrón y cobertura activa realizada.</span>
                                        </div>
                                    </div>
                                </div>
                                <!-- Columna 2: Profesional & Servicio -->
                                <div class="col-12 col-md-6">
                                    <div class="p-3 rounded-3 h-100 d-flex flex-column justify-content-between" style="background-color: var(--cl-surface-muted);">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <span class="text-uppercase text-muted" style="font-size: 11px; font-weight: 600; letter-spacing: 0.05em;">Profesional &amp; Servicio</span>
                                                <asp:Label ID="lblConsultorio" runat="server" CssClass="badge" Style="background-color: var(--cl-primary-light); color: var(--cl-primary); font-size: 11px; font-weight: 600;" Text="Turno Mañana"></asp:Label>
                                            </div>
                                            <h3 class="fw-bold mb-0" style="font-size: 18px; color: var(--cl-text-main);">
                                                <asp:Label ID="lblMedicoNombre" runat="server" Text="Dr. Martín Soria"></asp:Label>
                                            </h3>

                                            <div class="fw-semibold mb-3" style="font-size: 13px; color: var(--cl-primary);">
                                                <asp:Label ID="lblEspecialidad" runat="server" Text="Cardiología Clínica"></asp:Label>
                                                •
                                                <asp:Label ID="lblMatricula" runat="server" Text="MN 135.789"></asp:Label>
                                            </div>
                                            <div class="d-flex flex-column gap-2" style="font-size: 13.5px; color: var(--cl-text-secondary);">
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">event</span>
                                                    <span><strong style="color: var(--cl-text-main);">
                                                        <asp:Label ID="lblFecha" runat="server" Text="Lunes 26 de Mayo, 2025"></asp:Label></strong></span>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">schedule</span>
                                                    <span><strong style="color: var(--cl-text-main);">
                                                        <asp:Label ID="lblHora" runat="server" Text="10:00 hs"></asp:Label></strong> (Duración estimada:
                                                        <asp:Label ID="lblDuracion" runat="server" Text="60 min"></asp:Label>)</span>
                                                </div>
                                                <div class="d-flex align-items-center gap-2" style="font-size: 12px; color: var(--cl-text-muted);">
                                                    <span class="material-symbols-outlined" style="font-size: 16px;">medical_services</span>
                                                    <span>Prestación:
                                                        <asp:Label ID="lblPrestacion" runat="server" Text="Consulta clínica y electrocardiograma"></asp:Label></span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Motivo de la Consulta -->
                                        <div class="mt-3 p-2 rounded-2 bg-white" style="font-size: 12px;">
                                            <span class="text-uppercase text-muted d-block fw-semibold mb-1" style="font-size: 10px; letter-spacing: 0.05em;">Motivo de consulta:</span>
                                            <div style="color: var(--cl-text-main);">
                                                <asp:Label ID="lblMotivo" runat="server" Text="Chequeo cardiológico anual preventivo y solicitud de apto físico laboral."></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Barra de botones de acción -->
                        <div class="mt-4 pt-3 w-100 d-flex flex-wrap align-items-center justify-content-between gap-2 border-top no-print" style="border-color: var(--cl-border) !important;">
                            <!-- Acciones rápidas de la izquierda (WhatsApp / PDF) -->
                            <div class="d-flex align-items-center gap-2">
                                <asp:LinkButton ID="btnEnviarWhatsApp" runat="server" OnClick="btnEnviarWhatsApp_Click" CssClass="btn btn-secondary-light d-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-success);">chat</span>
                                    <span>Enviar por WhatsApp</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDescargarPdf" runat="server" OnClick="btnDescargarPdf_Click" CssClass="btn btn-secondary-light d-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-text-secondary);">download</span>
                                    <span>Descargar PDF</span>
                                </asp:LinkButton>

                            </div>
                            <!-- Acciones de navegación del panel central derecho -->
                            <div class="d-flex align-items-center gap-2">
                                <asp:HyperLink ID="lnkVerTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="btn btn-light d-flex align-items-center gap-1" Style="background: transparent; border: none; color: var(--cl-text-secondary); font-weight: 500;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">calendar_view_week</span>
                                    <span>Ver todos los turnos</span>
                                </asp:HyperLink>

                                <asp:HyperLink ID="lnkNuevoTurno" runat="server" NavigateUrl="~/NuevoTurno.aspx" CssClass="btn btn-secondary-light d-flex align-items-center gap-1">
                                <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
                                <span>Agendar nuevo turno</span>
                                </asp:HyperLink>

                                <button class="btn-teal-primary d-flex align-items-center gap-2 shadow-sm" onclick="window.print()" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">print</span>
                                    <span>Imprimir comprobante</span>
                                </button>
                            </div>
                        </div>
                </div>
                
                <!-- Aviso: paciente sin email. Se muestra solo cuando el paciente no tiene email (pnlSinEmail.Visible = true) -->
                <asp:Panel ID="pnlSinEmail" runat="server" Visible="false" CssClass="card-custom p-4 no-print">
                    <div class="p-3 rounded-3 d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3" style="background-color: rgba(186, 26, 26, 0.08); border-left: 4px solid var(--cl-error);">
                        <div class="d-flex align-items-start gap-2">
                            <span class="material-symbols-outlined flex-shrink-0" style="font-size: 22px; color: var(--cl-error);">warning</span>
                            <div style="font-size: 13.5px; color: #93000A;">
                                <strong class="d-block" style="color: var(--cl-error);">Paciente sin email:</strong>
                                El turno se guardó correctamente en el sistema, pero el paciente <strong>no tiene un email válido cargado</strong> en su ficha. Para habilitar los recordatorios automáticos de 24 hs previas es indispensable su actualización.
                            </div>
                        </div>
                        <button class="btn btn-danger btn-sm text-nowrap fw-semibold px-3 py-2 flex-shrink-0" data-bs-toggle="modal" data-bs-target="#emailUpdateModal" style="background-color: var(--cl-error); border: none; border-radius: 0.5rem;" type="button">
                            Cargar email ahora
                        </button>
                    </div>
                </asp:Panel>

                <!-- Instrucciones / Próximos pasos para el mostrador de recepción (tarjetas de 3 columnas) -->
                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <div class="card-custom p-3 h-100 d-flex align-items-start gap-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0" style="width: 32px; height: 32px; background-color: var(--cl-border); color: var(--cl-primary); font-size: 14px;">
                                1
                            </div>
                            <div>
                                <h4 class="fw-bold mb-1" style="font-size: 14px; color: var(--cl-text-main);">Horario de Ingreso</h4>
                                <p class="mb-0 text-muted" style="font-size: 12px; line-height: 1.4;">
                                    Indicar al paciente concurrir con <strong>15 minutos de anticipación</strong> para recepción administrativa y verificación de sala de espera.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card-custom p-3 h-100 d-flex align-items-start gap-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0" style="width: 32px; height: 32px; background-color: var(--cl-border); color: var(--cl-primary); font-size: 14px;">
                                2
                            </div>
                            <div>
                                <h4 class="fw-bold mb-1" style="font-size: 14px; color: var(--cl-text-main);">Documentación en Mano</h4>
                                <p class="mb-0 text-muted" style="font-size: 12px; line-height: 1.4;">
                                    Presentar físicamente en ventanilla el <strong>DNI argentino vigente</strong> y credencial digital o física de <strong>
                                        <asp:Label ID="lblCoberturaRecordatorio" runat="server" Text="OSDE"></asp:Label></strong> con token activo.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card-custom p-3 h-100 d-flex align-items-start gap-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0" style="width: 32px; height: 32px; background-color: var(--cl-border); color: var(--cl-primary); font-size: 14px;">
                                3
                            </div>
                            <div>
                                <h4 class="fw-bold mb-1" style="font-size: 14px; color: var(--cl-text-main);">Estudios Previos</h4>
                                <p class="mb-0 text-muted" style="font-size: 12px; line-height: 1.4;">
                                    Traer registros electrocardiográficos, análisis de laboratorio o ergometrías correspondientes a los últimos 12 meses.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Demostración del modal de Bootstrap para la actualización del correo electrónico -->
        <div aria-hidden="true" aria-labelledby="emailModalLabel" class="modal fade" id="emailUpdateModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 card-custom shadow-lg">
                    <div class="modal-header border-0 pb-0">
                        <div class="d-flex align-items-center gap-2" style="color: var(--cl-primary);">
                            <span class="material-symbols-outlined" style="font-size: 24px;">contact_mail</span>
                            <h5 class="modal-title fw-bold" id="emailModalLabel" style="font-size: 18px; color: var(--cl-text-main);">Cargar Correo Electrónico</h5>
                        </div>
                        <button aria-label="Close" class="btn-close" data-bs-dismiss="modal" type="button"></button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-3" style="font-size: 13.5px; color: var(--cl-text-secondary);">
                            Actualice la casilla de correo electrónico para el paciente <strong>
                                <asp:Label ID="lblModalPaciente" runat="server" Text="González, Martín Nicolás"></asp:Label></strong> (DNI:
                            <asp:Label ID="lblModalDni" runat="server" Text="35.892.410"></asp:Label>) para disparar recordatorios automáticos.
                        </p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold mb-1" for="txtEmailModal" style="font-size: 13px; color: var(--cl-text-main);">Correo Electrónico del Paciente</label>
                            <div class="position-relative">
                                <span class="material-symbols-outlined position-absolute top-50 translate-middle-y ms-2 text-muted" style="font-size: 18px;">mail</span>
                                <asp:TextBox ID="txtEmailModal" runat="server" ClientIDMode="Static" TextMode="Email" CssClass="form-control ps-4" Style="font-size: 14px; height: 42px; border-radius: 0.5rem; background-color: var(--cl-surface-muted);" placeholder="ejemplo@dominio.com.ar"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-check mb-3">
                            <asp:CheckBox ID="chkReenviarComprobante" runat="server" ClientIDMode="Static" Checked="true" />
                            <label class="form-check-label" for="chkReenviarComprobante" style="font-size: 12.5px; color: var(--cl-text-secondary);">
                                Reenviar inmediatamente el comprobante a este correo.
                            </label>

                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button class="btn btn-light" data-bs-dismiss="modal" style="font-size: 14px; font-weight: 500;" type="button">Cancelar</button>
                        <asp:LinkButton ID="btnGuardarEmail" runat="server" OnClick="btnGuardarEmail_Click" CssClass="btn-teal-primary text-decoration-none" Text="Guardar y Notificar"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    
        <div id="toastNotification">
            <span class="material-symbols-outlined" style="font-size: 20px; color: #7FFC97;">info</span>
            <span id="toastMessage">Acción completada.</span>
        </div>
    </div>
    
</asp:Content>
<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
    <script src='<%= ResolveUrl("~/Scripts/turno-confirmado.js") %>'></script>
</asp:Content>
