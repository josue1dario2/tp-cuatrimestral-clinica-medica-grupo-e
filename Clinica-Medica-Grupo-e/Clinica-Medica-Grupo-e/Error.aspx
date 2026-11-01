<%@ Page Title="Error" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Error" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card border-danger shadow-sm">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0">Hubo un problema</h4>
                    </div>
                    <div class="card-body">
                        <p class="card-text text-danger">Se ha producido un error inesperado en la aplicación:</p>
                        <div class="alert alert-light border">
                            <asp:Label ID="lblError" runat="server" CssClass="text-dark font-monospace small" Text="No se especificó un detalle del error."></asp:Label>
                        </div>
                        <a href="EspecialidadesLista.aspx" class="btn btn-primary">Volver a Especialidades</a>
                        <a href="InicioAdmin.aspx" class="btn btn-outline-secondary">Ir al Inicio</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

