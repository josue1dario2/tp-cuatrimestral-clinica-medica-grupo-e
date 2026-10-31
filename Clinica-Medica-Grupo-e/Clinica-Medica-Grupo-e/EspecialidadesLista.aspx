<%@ Page Title="Especialidades" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EspecialidadesLista.aspx.cs" Inherits="Clinica_Medica_Grupo_e.EspecialidadesLista" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h3 text-primary mb-1">Especialidades Médicas</h2>
            <p class="text-muted mb-0">Gestión de especialidades habilitadas en la clínica</p>
        </div>
        <asp:Button ID="btnAgregar" runat="server" Text="➕ Nueva Especialidad" CssClass="btn btn-primary shadow-sm" OnClick="btnAgregar_Click" />
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="dgvEspecialidades" runat="server"
                    DataKeyNames="Id"
                    AutoGenerateColumns="false"
                    AllowPaging="True"
                    PageSize="5"
                    OnPageIndexChanging="dgvEspecialidades_PageIndexChanging"
                    OnSelectedIndexChanged="dgvEspecialidades_SelectedIndexChanged"
                    CssClass="table table-hover table-striped align-middle mb-0">
                    <Columns>
                        <asp:BoundField HeaderText="#" DataField="Id" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center fw-bold" ItemStyle-Width="80px" />
                        <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                        <asp:CheckBoxField HeaderText="Activo" DataField="Activo" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="100px" />
                        <asp:CommandField HeaderText="Acción" ShowSelectButton="True" SelectText="✍" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="100px" ControlStyle-CssClass="btn btn-outline-primary btn-sm fw-bold" />
                    </Columns>
                    <PagerStyle CssClass="p-3 text-center" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>

