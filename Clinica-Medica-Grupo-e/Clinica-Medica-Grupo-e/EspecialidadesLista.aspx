<%@ Page Title="Especialidades" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EspecialidadesLista.aspx.cs" Inherits="Clinica_Medica_Grupo_e.EspecialidadesLista" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h3 text-primary mb-1">Especialidades Médicas</h2>
            <p class="text-muted mb-0">Gestión de especialidades habilitadas en la clínica</p>
        </div>
        <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-primary shadow-sm px-3" OnClick="btnAgregar_Click">
            <i class="bi bi-plus-lg me-1"></i>Nueva Especialidad
        </asp:LinkButton>
    </div>

    <!-- Buscador Superior -->
    <div class="row mb-3">
        <div class="col-md-6 col-lg-5">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-white border-end-0 text-muted">
                    <i class="bi bi-search"></i>
                </span>
                <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control border-start-0" placeholder="Buscar especialidad por nombre..." AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged"></asp:TextBox>
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />
            </div>
        </div>
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
                        <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                        <asp:CheckBoxField HeaderText="Activo" DataField="Activo" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="100px" />
                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Select" CssClass="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-pencil-square me-1"></i>Editar
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-container" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
