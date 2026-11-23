<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="PlanesObraSocial.aspx.cs" Inherits="Clinica_Medica_Grupo_e.PlanesObraSocial" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <div class="container-fluid py-4">

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Administración de planes</h2>
                <p class="text-secondary mb-0">
                    Obra social:
                    <asp:Label ID="lblNombreObraSocial" runat="server" CssClass="fw-semibold text-dark" />
                </p>
            </div>

            <asp:LinkButton runat="server" ID="btnNuevoPlan"
                CssClass="btn btn-teal"
                 OnClick="btnNuevoPlan_Click"
                CausesValidation="false"
                    data-bs-toggle="offcanvas"
    data-bs-target="#drawerPlan"
                >
                <i class="bi bi-plus-lg me-2"></i>Nuevo plan
            </asp:LinkButton>
        </div>

        <!-- FILTROS -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">

                    <div class="col-md-7">
                        <label class="form-label">Buscar plan</label>
                        <asp:TextBox runat="server" ID="txtBuscarPlan"
                            CssClass="form-control"
                            placeholder="Buscar por nombre..."
                            AutoPostBack="true"
                             OnTextChanged="txtBuscarPlan_TextChanged" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Estado</label>
                        <asp:DropDownList runat="server" ID="ddlFiltroEstadoPlan"
                            CssClass="form-select"
                            AutoPostBack="true"
                             OnSelectedIndexChanged="ddlFiltroEstadoPlan_SelectedIndexChanged">
                            <asp:ListItem Text="Todos" Value="" />
                            <asp:ListItem Text="Activos" Value="1" />
                            <asp:ListItem Text="Inactivos" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <asp:LinkButton runat="server" ID="btnLimpiarFiltros"
                            CssClass="btn btn-outline-secondary w-100"
                             OnClick="btnLimpiarFiltros_Click"
                            CausesValidation="false">
                            Limpiar
                        </asp:LinkButton>
                    </div>

                </div>
            </div>
        </div>

        <!-- GRID -->
        <div class="card border-0 shadow-sm">
            <div class="card-body">

                <asp:UpdatePanel runat="server" ID="updPlanes" UpdateMode="Conditional">
                    <ContentTemplate>

                        <asp:GridView runat="server" ID="dgvPlanes"
                            CssClass="table table-hover align-middle"
                            AutoGenerateColumns="false"
                            DataKeyNames="IdPlan"
                            AllowPaging="true"
                            PageSize="5"
                             OnPageIndexChanging="dgvPlanes_PageIndexChanging"
                            EmptyDataText="No se encontraron planes."
                            GridLines="None">

                            <Columns>

                                <asp:BoundField DataField="IdPlan" HeaderText="ID" />

                                <asp:BoundField DataField="NombrePlan" HeaderText="Nombre del plan" />

                                <asp:TemplateField HeaderText="Estado">
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="chkEstadoPlan"
                                            Checked='<%# Convert.ToBoolean(Eval("Activo")) %>'
                                            AutoPostBack="true"
                                             OnCheckedChanged="chkEstadoPlan_CheckedChanged"/>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Acciones">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="btnEditarPlan"
                                            CssClass="btn btn-sm btn-outline-primary"
                                             OnClick="btnEditarPlan_Click"
                                            CausesValidation="false">
                                            <i class="bi bi-pencil"></i> Editar
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pagination-ys" />

                        </asp:GridView>

                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
        </div>

    </div>

    <!-- OFFCANVAS -->
    <div class="offcanvas offcanvas-end" tabindex="-1"
        id="drawerPlan" aria-labelledby="tituloDrawerPlan">

        <div class="offcanvas-header border-bottom">
            <h5 class="offcanvas-title fw-bold" id="tituloDrawerPlan">
                <asp:Label runat="server" ID="lblTituloFormulario" Text="Nuevo plan" />
            </h5>
            <button type="button" class="btn-close"
                data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
        </div>

        <div class="offcanvas-body">

            <asp:UpdatePanel runat="server" ID="updFormulario" UpdateMode="Conditional">
                <ContentTemplate>

                    <asp:HiddenField runat="server" ID="hfIdPlan" />

                    <div class="mb-3">
                        <label class="form-label">Obra social</label>
                        <asp:Label runat="server" ID="lblObraSocialFormulario"
                            CssClass="form-control bg-light" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nombre del plan</label>
                        <asp:TextBox runat="server" ID="txtNombrePlan"
                            CssClass="form-control"
                            MaxLength="100"
                            placeholder="Ej. Plan 210" />
                    </div>

                    <asp:Panel runat="server" ID="pnlMensaje"
                        Visible="false" CssClass="p-2 rounded-2 mb-3">
                        <asp:Label runat="server" ID="lblMensaje" />
                    </asp:Panel>

                    <div class="d-flex gap-2">
                        <asp:LinkButton runat="server" ID="btnGuardarPlan"
                            CssClass="btn btn-teal flex-grow-1"
                             OnClick="btnGuardarPlan_Click">
                            Guardar
                        </asp:LinkButton>

                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="offcanvas">
                            Cancelar
                        </button>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
