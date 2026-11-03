<%@ Page Title="Pacientes" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="Pacientes.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Pacientes" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge page-tag rounded-pill px-2 py-1 fw-semibold">Gestión Pacientes</span>
                <span class="text-muted fs-11">•</span>
                <span class="text-muted fw-semibold fs-12">Padrón Asistencial</span>
            </div>
            <h1 class="page-title h3 fw-bold text-dark mb-1">Gestión y Listado de Pacientes</h1>
            <p class="text-muted mb-0 fs-14">Administración del padrón de pacientes, datos de filiación, contacto y estado activo.</p>
        </div>
        <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-teal d-flex align-items-center gap-2 shadow-sm px-3 py-2 fw-semibold" OnClick="btnAgregar_Click">
            <span class="material-symbols-outlined icon-20">add</span>
            <span>Nuevo paciente</span>
        </asp:LinkButton>
    </div>

    <!-- ===================== FILTROS DE BÚSQUEDA ===================== -->
    <asp:Panel ID="pnlFiltros" runat="server" DefaultButton="btnBuscar" CssClass="card-custom p-3 p-xl-4 mb-4">
        <div class="row g-3">
            <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                <asp:Label ID="lblFiltroNombre" runat="server" AssociatedControlID="txtFiltro" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Paciente (Nombre, apellido o DNI)"></asp:Label>
                <asp:TextBox ID="txtFiltro" runat="server" CssClass="filter-input form-control form-control-sm" placeholder="Ej: Pérez o 35111222"></asp:TextBox>
            </div>
        </div>

        <div class="d-flex align-items-center justify-content-end gap-2 mt-3 pt-2">
            <asp:LinkButton ID="btnLimpiar" runat="server" OnClick="btnLimpiar_Click"
                CssClass="btn-limpiar btn btn-light d-flex align-items-center gap-1 border text-secondary px-3">
                <span class="material-symbols-outlined icon-18">restart_alt</span>
                <span>Limpiar filtros</span>
            </asp:LinkButton>
            <asp:LinkButton ID="btnBuscar" runat="server" OnClick="btnBuscar_Click"
                CssClass="btn btn-teal d-flex align-items-center gap-1 px-4 fw-semibold shadow-sm fs-13">
                <span class="material-symbols-outlined icon-18">search</span>
                <span>Buscar pacientes</span>
            </asp:LinkButton>
        </div>
    </asp:Panel>

    <!-- ===================== TABLA DE PACIENTES ===================== -->
    <div class="card-custom overflow-hidden mb-4 shadow-sm border-0">
        <div class="table-responsive">
            <asp:GridView ID="dgvPacientes" runat="server"
                DataKeyNames="Id"
                AutoGenerateColumns="false"
                AllowPaging="True"
                PageSize="5"
                OnPageIndexChanging="dgvPacientes_PageIndexChanging"
                OnSelectedIndexChanged="dgvPacientes_SelectedIndexChanged"
                CssClass="table table-hover align-middle mb-0">
                <Columns>
                    <asp:BoundField HeaderText="Paciente" DataField="NombreCompleto" />
                    <asp:BoundField HeaderText="DNI" DataField="Dni" ItemStyle-Width="120px" />
                    <asp:TemplateField HeaderText="F. Nacimiento (Edad)" ItemStyle-Width="190px">
                        <ItemTemplate>
                            <div><%# ((DateTime)Eval("FechaNacimiento")).ToString("dd/MM/yyyy") %></div>
                            <small class="text-muted"><%# Eval("Edad") %> años</small>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Contacto">
                        <ItemTemplate>
                            <div class="small">
                                <%# !string.IsNullOrEmpty(Eval("Email") as string) ? "<div><i class='bi bi-envelope me-1 text-muted'></i>" + Eval("Email") + "</div>" : "" %>
                                <%# !string.IsNullOrEmpty(Eval("Telefono") as string) ? "<div><i class='bi bi-telephone me-1 text-muted'></i>" + Eval("Telefono") + "</div>" : "" %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Dirección" DataField="Direccion" NullDisplayText="-" />
                    <asp:CheckBoxField HeaderText="Activo" DataField="Activo" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="80px" />
                    <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEditar" runat="server" CommandName="Select" CssClass="btn-action-outline d-inline-flex align-items-center gap-1">
                                <span class="material-symbols-outlined icon-16">edit</span>
                                <span>Editar</span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerSettings Mode="Numeric" Position="Bottom" />
                <PagerStyle CssClass="pagination-container" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
