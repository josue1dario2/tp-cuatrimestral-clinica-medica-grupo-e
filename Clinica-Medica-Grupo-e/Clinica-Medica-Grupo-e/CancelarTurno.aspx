<%@ Page Title="Cancelar turno" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="CancelarTurno.aspx.cs" Inherits="Clinica_Medica_Grupo_e.CancelarTurno" %>

<asp:Content ID="cntHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="cntMain" ContentPlaceHolderID="MainContent" runat="server">

    <%-- Id del turno que se está cancelando (se carga en Page_Load desde ?id=) --%>
    <asp:HiddenField ID="hfIdTurno" runat="server" />

    <!--  1. ENCABEZADO  -->
    <div class="d-flex flex-column gap-2 mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1 fs-12">
                <li class="breadcrumb-item">
                    <asp:HyperLink ID="lnkBreadcrumbTurnos" runat="server" NavigateUrl="~/Turnos.aspx" CssClass="text-decoration-none text-secondary d-inline-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-16">calendar_month</span>
                        <span>Turnos</span>
                    </asp:HyperLink>
                </li>
                <li aria-current="page" class="breadcrumb-item active text-dark fw-semibold">
                    Cancelar Turno <asp:Label ID="lblBreadcrumbNumero" runat="server" Text="#1001"></asp:Label>
                </li>
            </ol>
        </nav>
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="modal-icon-circle modal-icon-danger rounded-circle d-flex align-items-center justify-content-center flex-shrink-0">
                    <span class="material-symbols-outlined">warning</span>
                </div>
                <div>
                    <h1 class="page-title h3 fw-bold text-dark mb-0">Cancelar Turno Médico</h1>
                    <span class="text-muted fs-13">Acción irrevocable • Liberación de cupo</span>
                </div>
            </div>
            <asp:HyperLink ID="lnkVolver" runat="server" NavigateUrl="~/Turnos.aspx"
                CssClass="btn btn-light border text-secondary d-inline-flex align-items-center gap-1 px-3 py-2 fw-medium fs-14 shadow-sm">
                <span class="material-symbols-outlined icon-18">arrow_back</span>
                <span>Volver al listado de turnos</span>
            </asp:HyperLink>
        </div>
    </div>

    <!--  MENSAJE DE ERROR  -->
    <%-- Turno inexistente, que ya no se puede cancelar, motivo inválido o error de base de datos --%>
    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger d-flex align-items-center gap-2 mb-4">
        <span class="material-symbols-outlined">error</span>
        <asp:Label ID="lblError" runat="server"></asp:Label>
    </asp:Panel>

    <!--  2. FORMULARIO DE CANCELACIÓN  -->
    <%-- Se oculta (Visible = false) si el turno no existe o no se puede cancelar --%>
    <asp:Panel ID="pnlFormulario" runat="server">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-9 col-xl-7">
                <div class="card-custom p-4">

                    <!-- Datos del turno -->
                    <div class="p-3 bg-light rounded-3 mb-3">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="modal-codigo font-monospace fw-bold bg-white px-2 rounded border">Código:
                                <asp:Label ID="lblCodigo" runat="server" Text="#1001"></asp:Label>
                            </span>
                            <asp:Label ID="lblEstado" runat="server" CssClass="badge-estado badge-estado-nuevo" Text="Nuevo"></asp:Label>
                        </div>
                        <div class="row g-3 mb-2 fs-13">
                            <div class="col-12 col-sm-6">
                                <span class="text-muted d-block">Paciente:</span>
                                <asp:Label ID="lblPaciente" runat="server" CssClass="fw-bold text-dark d-block" Text="Juan Ignacio López"></asp:Label>
                                <asp:Label ID="lblPacienteDetalle" runat="server" CssClass="text-muted fs-12" Text="DNI 34.892.104 • OSDE 310"></asp:Label>
                            </div>
                            <div class="col-12 col-sm-6">
                                <span class="text-muted d-block">Profesional:</span>
                                <asp:Label ID="lblMedico" runat="server" CssClass="fw-bold text-dark d-block" Text="Dr. Gómez Rossi, Alejandro"></asp:Label>
                                <asp:Label ID="lblMedicoDetalle" runat="server" CssClass="text-muted fs-12" Text="Dermatología"></asp:Label>
                            </div>
                        </div>
                        <div class="pt-2 border-top fs-13">
                            <span class="text-muted">Fecha y hora citada: </span>
                            <asp:Label ID="lblFecha" runat="server" CssClass="fw-bold text-dark" Text="Sábado 24 de mayo de 2025 - 16:00 hs"></asp:Label>
                        </div>
                    </div>

                    <!-- Aviso -->
                    <div class="modal-aviso d-flex align-items-start gap-2 p-3 rounded-2 mb-3">
                        <span class="material-symbols-outlined">info</span>
                        <div>Al cancelar este turno se liberará automáticamente el cupo en la agenda médica y se notificará al paciente por correo electrónico.</div>
                    </div>

                    <!-- Motivo -->
                    <div class="mb-3">
                        <asp:Label ID="lblMotivoCancelacion" runat="server" AssociatedControlID="txtMotivoCancelacion" CssClass="form-label fw-semibold text-dark mb-1 fs-13">
                            Motivo de cancelación <span class="text-danger">*</span>
                        </asp:Label>
                        <asp:TextBox ID="txtMotivoCancelacion" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control fs-13"></asp:TextBox>
                        <span class="text-muted d-block mt-1 fs-12">Este motivo quedará asentado en el historial de trazabilidad del paciente (entre 5 y 300 caracteres).</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 mb-4">
                        <asp:CheckBox ID="chkNotificarPaciente" runat="server" Checked="true" CssClass="chk-teal" />
                        <asp:Label ID="lblNotificarPaciente" runat="server" AssociatedControlID="chkNotificarPaciente" CssClass="text-dark fs-13 mb-0" Text="Notificar al paciente por email de inmediato"></asp:Label>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex flex-column-reverse flex-sm-row justify-content-end gap-2 pt-3 border-top">
                        <asp:HyperLink ID="lnkCancelarVolver" runat="server" NavigateUrl="~/Turnos.aspx"
                            CssClass="btn btn-light border text-secondary px-3 py-2 fw-medium fs-14" Text="Volver"></asp:HyperLink>
                        <asp:LinkButton ID="btnConfirmarCancelacion" runat="server" OnClick="btnConfirmarCancelacion_Click"
                            CssClass="btn btn-danger d-inline-flex align-items-center justify-content-center gap-1 px-3 py-2 fw-semibold shadow-sm fs-14">
                            <span class="material-symbols-outlined">check</span>
                            <span>Confirmar cancelación</span>
                        </asp:LinkButton>
                    </div>

                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="cntScripts" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
