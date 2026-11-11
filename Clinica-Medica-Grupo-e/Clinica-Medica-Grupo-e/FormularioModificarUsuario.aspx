<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="FormularioModificarUsuario.aspx.cs" Inherits="Clinica_Medica_Grupo_e.FormularioModificarUsuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

        <div class="row justify-content-center">
        <div class="col-md-9 col-lg-8">
            <div class="card card-custom border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3 px-4">
                    <h2 class="fs-20 fw-semibold text-dark mb-0 tracking-tight">
                        <asp:Label ID="lblTitulo" runat="server" Text=""></asp:Label>
                    </h2>
                </div>
                <div class="card-body p-4">
                    <asp:Label ID="lblErrorValidacion" runat="server" CssClass="alert alert-danger d-block mb-3" Visible="false"></asp:Label>

                    <div class="row g-3 mb-3" runat="server" id="divContraseñas">
                        <div class="col-md-6">
                            <label for="txtContraseña" class="form-label fw-semibold fs-14 text-dark">Contraseña <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtContraseña" runat="server" CssClass="form-control"  MaxLength="50" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtConfirmarContraseña" class="form-label fw-semibold fs-14 text-dark">Confirmar contraseña <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtConfirmarContraseña" runat="server" CssClass="form-control"  MaxLength="50" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row g-3 mb-3" runat="server" id="divNombreUsuario">
                        <div class="col-md-6">
                            <label for="txtNombreUsuario" class="form-label fw-semibold fs-14 text-dark">Nombre de usuario <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"  MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-6">

                        </div>
                    </div>

                    <div class="row g-3 mb-3">

                    </div>

                    <div class="mb-4" runat="server" id="divMail">
                        <label for="txtEmail" class="form-label fw-semibold fs-14 text-dark">Correo Electrónico</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ej: doctor@clinica.com" MaxLength="50" TextMode="Email"></asp:TextBox>
                    </div>

                    <div class="d-flex align-items-center gap-2 pt-2 border-top">
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="btn btn-teal px-4 fw-semibold shadow-sm" OnClick="btnAceptar_Click"/>
                        <a href="GestionUsuariosAdmin.aspx" class="btn btn-light border px-4 text-secondary">Cancelar</a>
                        <% if (Request.QueryString["id"] != null) { %>
                  
                        <% } %>
                    </div>

                   <div class="alert alert-warning border mt-4 p-3 rounded">
    <h5 class="h6 text-danger fw-bold mb-2">
        ¿Está seguro de modificar este usuario?
    </h5>

    <p class="small text-muted mb-3">
        Esta acción modificará los datos del usuario.
    </p>

    <div class="mb-3">
        <asp:CheckBox
            ID="chkConfirmarCambios"
            runat="server"
            Text="Confirmo que deseo guardar los cambios."
            CssClass="form-check-label text-dark fw-semibold" />
    </div>
</div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
