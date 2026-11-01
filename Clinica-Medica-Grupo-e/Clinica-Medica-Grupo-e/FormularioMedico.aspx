<%@ Page Title="Formulario Médico" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="FormularioMedico.aspx.cs" Inherits="Clinica_Medica_Grupo_e.FormularioMedico" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-9 col-lg-8">
            <div class="card card-custom border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3 px-4">
                    <h2 class="fs-20 fw-semibold text-dark mb-0 tracking-tight">
                        <asp:Label ID="lblTitulo" runat="server" Text="Nuevo Médico"></asp:Label>
                    </h2>
                </div>
                <div class="card-body p-4">
                    <asp:Label ID="lblErrorValidacion" runat="server" CssClass="alert alert-danger d-block mb-3" Visible="false"></asp:Label>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="txtNombre" class="form-label fw-semibold fs-14 text-dark">Nombre <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Juan" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtApellido" class="form-label fw-semibold fs-14 text-dark">Apellido <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Pérez" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="txtMatricula" class="form-label fw-semibold fs-14 text-dark">Matrícula <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtMatricula" runat="server" CssClass="form-control" placeholder="Ej: MN-12345" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="ddlEspecialidad" class="form-label fw-semibold fs-14 text-dark">Especialidad <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="form-select">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="ddlTurnoTrabajo" class="form-label fw-semibold fs-14 text-dark">Turno de Trabajo <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlTurnoTrabajo" runat="server" CssClass="form-select">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label for="txtTelefono" class="form-label fw-semibold fs-14 text-dark">Teléfono</label>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ej: 11-4567-8900" MaxLength="30"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="txtEmail" class="form-label fw-semibold fs-14 text-dark">Correo Electrónico</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ej: doctor@clinica.com" MaxLength="50" TextMode="Email"></asp:TextBox>
                    </div>

                    <div class="d-flex align-items-center gap-2 pt-2 border-top">
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="btn btn-teal px-4 fw-semibold shadow-sm" OnClick="btnAceptar_Click" />
                        <a href="Medicos.aspx" class="btn btn-light border px-4 text-secondary">Cancelar</a>
                        <% if (Request.QueryString["id"] != null) { %>
                        <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger ms-auto px-3" OnClick="btnEliminar_Click" />
                        <% } %>
                    </div>

                    <% if (ConfirmaEliminacion) { %>
                    <div class="alert alert-warning border mt-4 p-3 rounded">
                        <h5 class="h6 text-danger fw-bold mb-2">¿Está seguro de eliminar a este médico?</h5>
                        <p class="small text-muted mb-3">Esta acción dará de baja lógica al profesional en el sistema.</p>
                        <div class="mb-3">
                            <asp:CheckBox ID="chkConfirmarEliminar" runat="server" Text="Confirmo la eliminación del registro" AutoPostBack="true" OnCheckedChanged="chkConfirmarEliminar_CheckedChanged" CssClass="form-check-label text-dark fw-semibold" />
                        </div>
                        <asp:Button ID="btnConfirmarEliminar" runat="server" Text="Confirmar Eliminación" CssClass="btn btn-outline-danger btn-sm" Enabled="false" OnClick="btnConfirmarEliminar_Click" />
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>