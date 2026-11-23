<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="GestionObraSociales.aspx.cs" Inherits="Clinica_Medica_Grupo_e.GestionObraSociales" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge-soft-teal p-1 rounded-2 d-inline-flex align-items-center justify-content-center"
                    style="width: 28px; height: 28px;">
                    <span class="material-symbols-outlined fs-6">health_and_safety</span>
                </span>
                <span class="text-uppercase fw-bold text-secondary tracking-wider" style="font-size: 11px;">
                    Administración
                </span>
            </div>

            <h1 class="h3 fw-bold text-dark mb-1 tracking-tight">Obras Sociales</h1>

            <p class="text-muted mb-0" style="font-size: 14px; max-width: 650px;">
                Administración de obras sociales y sus planes de cobertura médica.
            </p>
        </div>

                    <!-- Abrir formulario -->
        <button type="button" class="btn btn-teal"
            data-bs-toggle="offcanvas" data-bs-target="#drawerObraSocial">
            <span class="material-symbols-outlined fs-5">add</span>
            <span>Nueva obra social</span>
        </button>
    </div>

     <!-- Filtros -->

    <asp:UpdatePanel runat="server" ID="updFiltros" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="card-custom p-3 mb-3">
                <div class="row g-2 align-items-center">

                    <div class="col-12 col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0 text-secondary">
                                <span class="material-symbols-outlined fs-6">search</span>
                            </span>

                            <asp:TextBox runat="server" ID="txtBuscarObraSocial"
                                CssClass="form-control bg-light border-0"
                                Style="font-size: 14px;"
                                Placeholder="Buscar por nombre o sigla..."
                                 AutoPostBack="true"
                                 OnTextChanged="txtBuscarObraSocial_TextChanged" />
                        </div>
                    </div>

                    <div class="col-12 col-md-4 d-flex align-items-center justify-content-md-end gap-2">

                        <div class="d-flex align-items-center gap-2 bg-light px-2 py-1 rounded-3">
                            <span class="material-symbols-outlined fs-6 text-secondary">toggle_on</span>

                            <asp:DropDownList runat="server" ID="ddlFiltroEstado"
                                CssClass="form-select form-select-sm border-0 bg-transparent fw-medium"
                                AutoPostBack="true"
                                 OnSelectedIndexChanged="ddlFiltroEstado_SelectedIndexChanged">
                                <asp:ListItem Text="Todos" Value="" />
                                <asp:ListItem Text="Activos" Value="1" />
                                <asp:ListItem Text="Inactivos" Value="0" />
                            </asp:DropDownList>
                        </div>

                        <asp:LinkButton runat="server" ID="btnLimpiarFiltros"
                            CssClass="btn btn-light btn-sm d-flex align-items-center justify-content-center p-2 rounded-3 text-secondary"
                             OnClick="btnLimpiarFiltros_Click">
                            <span class="material-symbols-outlined fs-6">filter_alt_off</span>
                        </asp:LinkButton>

                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>


     <!-- Tabla de obras sociales -->
    <asp:UpdatePanel runat="server" ID="updObrasSociales" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="card-custom overflow-hidden mb-4">
                <div class="table-responsive">

                    <asp:GridView runat="server" ID="dgvObrasSociales"
                        AutoGenerateColumns="false"
                        DataKeyNames="IdObraSocial"
                        CssClass="table table-custom mb-0 table-hover align-middle"
                        AllowPaging="true"
                        PageSize="5"
                         OnPageIndexChanging="dgvObrasSociales_PageIndexChanging"
                        EmptyDataText="No se encontraron obras sociales.">

                        <Columns>

                            <asp:TemplateField HeaderText="Obra social">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-3">

                                        <div class="avatar-circle rounded-3"
                                            style="background-color: #dce9ff; color: #00626a;">
                                            <span class="material-symbols-outlined">health_and_safety</span>
                                        </div>

                                        <div class="d-flex flex-column">
                                            <span class="fw-semibold text-dark">
                                                <%# Eval("Nombre") %>
                                            </span>

                                            <span class="small text-muted">
                                                <%# Eval("Sigla") == DBNull.Value || Eval("Sigla").ToString() == "" ? "Sin sigla" : Eval("Sigla") %>
                                            </span>
                                        </div>

                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Sigla">
                                <ItemTemplate>
                                    <span class="small text-muted">
                                        <%# Eval("Sigla") == DBNull.Value || Eval("Sigla").ToString() == "" ? "—" : Eval("Sigla") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Estado">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="chkEstado"
                                        Checked='<%# Convert.ToBoolean(Eval("Activo")) %>'
                                        AutoPostBack="true"
                                         OnCheckedChanged="chkEstado_CheckedChanged" />
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <div class="d-inline-flex align-items-center gap-1">

                                        <asp:LinkButton runat="server" ID="btnEditar"
                                            CssClass="action-btn"
                                            ToolTip="Modificar obra social"
                                             OnClick="btnEditar_Click">
                                            <span class="material-symbols-outlined">edit</span>
                                        </asp:LinkButton>

                                        <asp:LinkButton runat="server" ID="btnDetalles"
                                            CssClass="action-btn"
                                            ToolTip="Administrar planes"
                                             OnClick="btnDetalles_Click">
                                            <span class="material-symbols-outlined">list_alt</span>
                                        </asp:LinkButton>

                                    </div>

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                        <PagerSettings Mode="Numeric" Position="Bottom" />
                        <PagerStyle CssClass="pagination-container" HorizontalAlign="Right" />

                    </asp:GridView>

                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="offcanvas offcanvas-end offcanvas-custom"
        tabindex="-1"
        id="drawerObraSocial"
        aria-labelledby="drawerObraSocialLabel">

        <asp:UpdatePanel runat="server" ID="updFormulario" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:HiddenField runat="server" ID="hfIdObraSocial" />

                <div class="offcanvas-header bg-light border-bottom p-4">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="material-symbols-outlined fs-4"
                                style="color: var(--cl-teal-primary);">health_and_safety</span>

                            <h5 class="offcanvas-title fw-bold text-dark" id="drawerObraSocialLabel">
                                <asp:Label runat="server" ID="lblTituloFormulario"
                                    Text="Nueva obra social" />
                            </h5>
                        </div>

                        <p class="text-muted small mb-0">
                            Completá los datos de la obra social.
                        </p>
                    </div>

                    <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
                </div>


                <div class="offcanvas-body p-4 d-flex flex-column gap-3">

                    <!-- Nombre -->
                    <div>
                        <label class="form-label fw-semibold text-dark small mb-1">
                            Nombre <span class="text-danger">*</span>
                        </label>

                        <asp:TextBox runat="server" ID="txtNombreObraSocial"
                            CssClass="form-control bg-light border-0"
                            MaxLength="100"
                            placeholder="Ej. Swiss Medical" />


                    </div>


                    <!-- Sigla -->
                    <div>
                        <label class="form-label fw-semibold text-dark small mb-1">
                            Sigla
                        </label>

                        <asp:TextBox runat="server" ID="txtSiglaObraSocial"
                            CssClass="form-control bg-light border-0"
                            MaxLength="30"
                            placeholder="Ej. SMG" />

                        <span class="text-muted d-block mt-1" style="font-size: 11px;">
                            Campo opcional.
                        </span>
                    </div>


                    <!-- Mensaje -->
                    <asp:Panel runat="server" ID="pnlMensaje"
                        Visible="false"
                        CssClass="d-flex align-items-center gap-2 p-2 rounded-2 mt-2">

                        <span class="material-symbols-outlined fs-6">info</span>

                        <asp:Label runat="server" ID="lblMensaje"
                            CssClass="fw-semibold"
                            Style="font-size: 12px;" />

                    </asp:Panel>

                </div>


                <div class="offcanvas-footer bg-light border-top p-3 d-flex justify-content-end gap-2">

                    <button type="button" class="btn btn-outline-secondary btn-sm px-3"
                        data-bs-dismiss="offcanvas">
                        Cancelar
                    </button>

                    <asp:LinkButton runat="server" ID="btnGuardarObraSocial"
                        CssClass="btn btn-teal btn-sm px-4"
                        
                         OnClick="btnGuardarObraSocial_Click">
                        <span class="material-symbols-outlined fs-6">save</span>
                        <span>Guardar</span>
                    </asp:LinkButton>

                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>







</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
