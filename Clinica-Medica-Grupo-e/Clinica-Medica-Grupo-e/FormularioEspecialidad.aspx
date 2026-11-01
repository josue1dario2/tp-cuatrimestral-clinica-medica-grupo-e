<%@ Page Title="Formulario Especialidad" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioEspecialidad.aspx.cs" Inherits="Clinica_Medica_Grupo_e.FormularioEspecialidad" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-bottom py-3">
                    <h3 class="h4 mb-0 text-primary">
                        <asp:Label ID="lblTitulo" runat="server" Text="Nueva Especialidad"></asp:Label>
                    </h3>
                </div>
                <div class="card-body p-4">
                    <div class="mb-4">
                        <label for="txtDescripcion" class="form-label fw-semibold">Descripción de la Especialidad <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" placeholder="Ej: Pediatría, Dermatología..." MaxLength="50"></asp:TextBox>
                        <asp:Label ID="lblErrorValidacion" runat="server" CssClass="text-danger small mt-1 d-block" Visible="false"></asp:Label>
                    </div>

                    <div class="d-flex gap-2">
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="btn btn-primary px-4" OnClick="btnAceptar_Click" />
                        <a href="EspecialidadesLista.aspx" class="btn btn-outline-secondary px-4">Cancelar</a>
                        <% if (Request.QueryString["id"] != null) { %>
                        <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger ms-auto" OnClick="btnEliminar_Click" />
                        <% } %>
                    </div>

                    <% if (ConfirmaEliminacion) { %>
                    <div class="alert alert-warning border mt-4 p-3 rounded">
                        <h5 class="h6 text-danger fw-bold mb-2">¿Está seguro de eliminar esta especialidad?</h5>
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
