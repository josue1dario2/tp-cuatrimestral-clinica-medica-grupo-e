<%@ Page Title="Error" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Error" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-custom border-danger shadow-sm">
                <div class="card-header bg-danger text-white py-3">
                    <h4 class="mb-0 fs-18">Hubo un problema</h4>
                </div>
                <div class="card-body p-4">
                    <p class="card-text text-danger fw-semibold">Se ha producido un error inesperado en la aplicación:</p>
                    <div class="alert alert-light border p-3 rounded">
                        <asp:Label ID="lblError" runat="server" CssClass="text-dark font-monospace small" Text="No se especificó un detalle del error."></asp:Label>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="EspecialidadesLista.aspx" class="btn btn-primary">Volver a Especialidades</a>
                        <a href="InicioAdmin.aspx" class="btn btn-outline-secondary">Ir al Inicio</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>