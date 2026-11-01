<%@ Page Title="Médicos" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="Medicos.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Medicos" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge page-tag rounded-pill px-2 py-1 fw-semibold">Gestión Médica</span>
                <span class="text-muted fs-11">•</span>
                <span class="text-muted fw-semibold fs-12">Cuerpo Profesional</span>
            </div>
            <h1 class="page-title h3 fw-bold text-dark mb-1">Gestión y Listado de Médicos</h1>
            <p class="text-muted mb-0 fs-14">Administración del equipo médico, especialidades asignadas y horarios asistenciales.</p>
        </div>
        <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-teal d-flex align-items-center gap-2 shadow-sm px-3 py-2 fw-semibold" OnClick="btnAgregar_Click">
            <span class="material-symbols-outlined icon-20">add</span>
            <span>Nuevo médico</span>
        </asp:LinkButton>
    </div>

    <!-- ===================== FILTROS DE BÚSQUEDA ===================== -->
    <asp:Panel ID="pnlFiltros" runat="server" DefaultButton="btnBuscar" CssClass="card-custom p-3 p-xl-4 mb-4">
        <div class="row g-3">
            <div class="col-12 col-md-6 col-lg-4 col-xl-3">
                <asp:Label ID="lblFiltroEspecialidad" runat="server" AssociatedControlID="ddlFiltroEspecialidad" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Especialidad"></asp:Label>
                <asp:DropDownList ID="ddlFiltroEspecialidad" runat="server" CssClass="filter-input form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroEspecialidad_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="col-12 col-md-6 col-lg-5 col-xl-4">
                <asp:Label ID="lblFiltroNombre" runat="server" AssociatedControlID="txtFiltro" CssClass="filter-label form-label text-muted fw-medium mb-1" Text="Médico (Nombre, apellido o matrícula)"></asp:Label>
                <asp:TextBox ID="txtFiltro" runat="server" CssClass="filter-input form-control form-control-sm" placeholder="Ej: Pérez o MN-10455"></asp:TextBox>
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
                <span>Buscar médicos</span>
            </asp:LinkButton>
        </div>
    </asp:Panel>

    <!-- ===================== TABLA DE MÉDICOS ===================== -->
    <div class="card-custom overflow-hidden mb-4 shadow-sm border-0">
        <div class="table-responsive">
            <asp:GridView ID="dgvMedicos" runat="server"
                DataKeyNames="Id"
                AutoGenerateColumns="false"
                AllowPaging="True"
                PageSize="5"
                OnPageIndexChanging="dgvMedicos_PageIndexChanging"
                OnSelectedIndexChanged="dgvMedicos_SelectedIndexChanged"
                CssClass="table table-hover align-middle mb-0">
                <Columns>
                    <asp:BoundField HeaderText="Médico" DataField="NombreCompleto" />
                    <asp:BoundField HeaderText="Matrícula" DataField="Matricula" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="Especialidad" DataField="EspecialidadesTexto" />
                    <asp:BoundField HeaderText="Turno" DataField="TurnoTrabajo.Nombre" ItemStyle-Width="110px" />
                    <asp:TemplateField HeaderText="Contacto">
                        <ItemTemplate>
                            <div class="small">
                                <%# !string.IsNullOrEmpty(Eval("Email") as string) ? "<div><i class='bi bi-envelope me-1 text-muted'></i>" + Eval("Email") + "</div>" : "" %>
                                <%# !string.IsNullOrEmpty(Eval("Telefono") as string) ? "<div><i class='bi bi-telephone me-1 text-muted'></i>" + Eval("Telefono") + "</div>" : "" %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                <PagerStyle CssClass="pagination-container" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>