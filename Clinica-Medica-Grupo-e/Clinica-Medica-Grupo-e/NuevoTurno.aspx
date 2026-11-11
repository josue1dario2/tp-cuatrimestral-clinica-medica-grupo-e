<%@ Page Title="Nuevo Turno" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="NuevoTurno.aspx.cs" Inherits="Clinica_Medica_Grupo_e.NuevoTurno" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .section-title {
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--cl-primary);
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 12px;
            padding-bottom: 6px;
            border-bottom: 1px solid var(--cl-border);
        }
        .summary-card {
            background-color: var(--cl-surface-muted);
            border: 1px solid var(--cl-border);
            border-radius: 10px;
            padding: 16px;
        }
        .summary-card .item-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--cl-text-secondary);
        }
        .summary-card .item-value {
            font-size: 14px;
            font-weight: 600;
            color: var(--cl-text-main);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid" style="max-width: 980px;">
        <div class="d-flex align-items-center gap-2 mb-3" style="font-size: 13px; font-weight: 500; color: var(--cl-text-secondary);">
            <asp:HyperLink ID="lnkBreadcrumbTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="text-decoration-none d-flex align-items-center gap-1" Style="color: var(--cl-text-secondary);">
                <span class="material-symbols-outlined" style="font-size: 16px;">calendar_month</span>
                <span>Turnos</span>
            </asp:HyperLink>
            <span style="color: var(--cl-text-muted);">/</span>
            <span class="fw-semibold" style="color: var(--cl-text-main);">Nuevo Turno</span>
        </div>

        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
            <div>
                <h1 class="page-title mb-1" style="font-size: 24px; font-weight: 700; color: var(--cl-text-main);">Agendar Nuevo Turno</h1>
                <p class="text-secondary small mb-0">Seleccione el paciente, la cobertura médica (obra social y plan) y el profesional para programar la cita.</p>
            </div>
            <a href="Turnos.aspx" class="btn btn-light border d-flex align-items-center gap-1 px-3 py-2 text-secondary" style="font-size: 13.5px;">
                <span class="material-symbols-outlined" style="font-size: 18px;">arrow_back</span>
                <span>Volver al listado</span>
            </a>
        </div>

        <%--<asp:ScriptManager ID="ScriptManager1" runat="server" />--%>

        <asp:UpdatePanel ID="updTurno" runat="server">
            <ContentTemplate>
                <asp:Label ID="lblMensajeError" runat="server" CssClass="alert alert-danger d-block mb-3 shadow-sm" Visible="false"></asp:Label>
                <asp:Label ID="lblMensajeExito" runat="server" CssClass="alert alert-success d-block mb-3 shadow-sm" Visible="false"></asp:Label>

                <div class="card card-custom p-4 p-md-5 mb-4 shadow-sm border-0">

                    <div class="mb-4">
                        <div class="section-title">
                            <span class="material-symbols-outlined" style="font-size: 18px;">personal_injury</span>
                            <span>1. Paciente Titular</span>
                        </div>
                        <div class="row g-3 align-items-end">
                            <div class="col-12 col-md-8">
                                <label for="<%= ddlPaciente.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Paciente <span class="text-danger">*</span>
                                </label>
                                <asp:DropDownList ID="ddlPaciente" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPaciente_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-12 col-md-4">
                                <a href="FormularioPaciente.aspx" class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center gap-1 py-2" style="font-size: 13px;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">person_add</span>
                                    <span>Registrar Nuevo Paciente</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="section-title">
                            <span class="material-symbols-outlined" style="font-size: 18px;">health_and_safety</span>
                            <span>2. Cobertura Médica</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-12 col-md-5">
                                <label for="<%= ddlObraSocial.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Obra Social / Prepaga <span class="text-danger">*</span>
                                </label>
                                <asp:DropDownList ID="ddlObraSocial" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlObraSocial_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    Al elegir la obra social se cargarán sus planes correspondientes.
                                </span>
                            </div>

                            <div class="col-12 col-md-4">
                                <label for="<%= ddlPlan.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Plan de Cobertura <span class="text-danger">*</span>
                                </label>
                                <asp:DropDownList ID="ddlPlan" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPlan_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    <asp:Label ID="lblCantidadPlanes" runat="server" Text=""></asp:Label>
                                </span>
                            </div>

                            <div class="col-12 col-md-3">
                                <label for="<%= txtNumeroAfiliado.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    N° de Afiliado
                                </label>
                                <asp:TextBox ID="txtNumeroAfiliado" runat="server" CssClass="form-control" placeholder="Ej: 01-12345678-00" MaxLength="50"></asp:TextBox>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    Opcional si es Particular.
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="section-title">
                            <span class="material-symbols-outlined" style="font-size: 18px;">stethoscope</span>
                            <span>3. Profesional Médico &amp; Especialidad</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label for="<%= ddlEspecialidad.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Especialidad Médica <span class="text-muted fw-normal" style="font-size: 12px;">(Opcional para filtrar)</span>
                                </label>
                                <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecialidad_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    Si no selecciona ninguna, se listarán todos los médicos disponibles.
                                </span>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="<%= ddlMedico.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Profesional Médico <span class="text-danger">*</span>
                                </label>
                                <asp:DropDownList ID="ddlMedico" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlMedico_SelectedIndexChanged">
                                </asp:DropDownList>
                                <div class="mt-1">
                                    <asp:Label ID="lblTurnoTrabajoInfo" runat="server" CssClass="badge rounded-pill bg-light text-secondary border" Visible="false"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="section-title">
                            <span class="material-symbols-outlined" style="font-size: 18px;">schedule</span>
                            <span>4. Fecha &amp; Horario</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label for="<%= txtFecha.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Fecha de la Cita <span class="text-danger">*</span>
                                </label>
                                <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtFecha_TextChanged"></asp:TextBox>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    Debe ser igual o posterior al día de hoy.
                                </span>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="<%= ddlHora.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                    Horario Disponible <span class="text-danger">*</span>
                                </label>
                                <asp:DropDownList ID="ddlHora" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlHora_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span class="text-muted d-block mt-1" style="font-size: 11.5px;">
                                    <asp:Label ID="lblEstadoHorario" runat="server" Text="Seleccione médico y fecha para ver los horarios disponibles."></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="section-title">
                            <span class="material-symbols-outlined" style="font-size: 18px;">notes</span>
                            <span>5. Motivo de Consulta</span>
                        </div>
                        <div>
                            <label for="<%= txtObservaciones.ClientID %>" class="form-label fw-semibold" style="font-size: 13.5px;">
                                Observaciones / Motivo de la Cita
                            </label>
                            <asp:TextBox ID="txtObservaciones" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Ej: Control general periódico, revisión de estudios o síntomas principales..."></asp:TextBox>
                        </div>
                    </div>

                    <div class="summary-card mb-4">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="material-symbols-outlined" style="font-size: 18px; color: var(--cl-primary);">preview</span>
                            <span class="fw-bold" style="font-size: 13px; color: var(--cl-text-main); text-transform: uppercase; letter-spacing: 0.04em;">Resumen de la Cita Médica</span>
                        </div>
                        <div class="row g-3 pt-1">
                            <div class="col-6 col-md-3">
                                <div class="item-label">Paciente</div>
                                <div class="item-value"><asp:Label ID="lblResumenPaciente" runat="server" Text="--"></asp:Label></div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="item-label">Cobertura</div>
                                <div class="item-value"><asp:Label ID="lblResumenCobertura" runat="server" Text="--"></asp:Label></div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="item-label">Profesional</div>
                                <div class="item-value"><asp:Label ID="lblResumenMedico" runat="server" Text="--"></asp:Label></div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="item-label">Fecha y Hora</div>
                                <div class="item-value"><asp:Label ID="lblResumenFechaHora" runat="server" Text="--"></asp:Label></div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 pt-3 border-top">
                        <a href="Turnos.aspx" class="btn btn-light border px-4 py-2 text-secondary" style="font-size: 14px;">
                            Cancelar
                        </a>
                        <asp:LinkButton ID="btnConfirmarTurno" runat="server" CssClass="btn btn-teal d-flex align-items-center gap-2 px-4 py-2 shadow-sm fw-semibold" OnClick="btnConfirmarTurno_Click">
                            <span class="material-symbols-outlined" style="font-size: 20px;">event_available</span>
                            <span>Confirmar y agendar turno</span>
                        </asp:LinkButton>
                    </div>

                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
