<%@ Page Title="Especialidades" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="EspecialidadesLista.aspx.cs" Inherits="Clinica_Medica_Grupo_e.EspecialidadesLista" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <h1 class="fs-24 fw-semibold text-dark mb-1 tracking-tight">Especialidades Médicas</h1>
            <p class="fs-14 text-cl-secondary mb-0">Gestión de especialidades habilitadas en la clínica</p>
        </div>
        <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-primary shadow-sm px-3 d-inline-flex align-items-center gap-2" OnClick="btnAgregar_Click">
            <span class="material-symbols-outlined icon-20">add</span>
            <span>Nueva Especialidad</span>
        </asp:LinkButton>
    </div>

    <!-- Buscador Superior -->
    <div class="row g-2 mb-3">
        <div class="col-md-6 col-lg-5">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-white border-end-0 text-secondary">
                    <span class="material-symbols-outlined icon-18">search</span>
                </span>
                <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control border-start-0" placeholder="Buscar especialidad por nombre..." AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged"></asp:TextBox>
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />
            </div>
        </div>
    </div>

    <div class="card card-custom border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="dgvEspecialidades" runat="server"
                    DataKeyNames="Id"
                    AutoGenerateColumns="false"
                    AllowPaging="True"
                    PageSize="5"
                    OnPageIndexChanging="dgvEspecialidades_PageIndexChanging"
                    OnSelectedIndexChanged="dgvEspecialidades_SelectedIndexChanged"
                    CssClass="table table-hover align-middle mb-0">
                    <Columns>
                        <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                        <asp:CheckBoxField HeaderText="Activo" DataField="Activo" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="100px" />
                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Select" CssClass="btn btn-outline-primary btn-sm d-inline-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined icon-16">edit</span>
                                    <span>Editar</span>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-container py-3" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>