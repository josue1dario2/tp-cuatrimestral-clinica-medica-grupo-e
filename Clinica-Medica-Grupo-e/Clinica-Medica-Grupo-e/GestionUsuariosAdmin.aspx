<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRecep.Master" AutoEventWireup="true" CodeBehind="GestionUsuariosAdmin.aspx.cs" Inherits="Clinica_Medica_Grupo_e.GestionUsuariosAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Titulo-->
    <div class="d-flex flex-column gap-3 mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge-soft-teal p-1 rounded-2 d-inline-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">
                        <span class="material-symbols-outlined fs-6">manage_accounts</span>
                    </span>
                    <span class="text-uppercase fw-bold text-secondary tracking-wider" style="font-size: 11px;">Seguridad &amp; Acceso</span>
                </div>
                <h1 class="h3 fw-bold text-dark mb-1 tracking-tight">Gestión de Usuarios</h1>
                <p class="text-muted mb-0" style="font-size: 14px; max-width: 650px;">
                    Administración de cuentas de acceso, roles del personal y asignación de profesionales médicos a consultorios y agendas de turnos.
                </p>
            </div>

                <!-- Botón que activa el Offcanvas / Drawer -->
                <button aria-controls="drawerNuevoUsuario" class="btn btn-teal" data-bs-target="#drawerNuevoUsuario" data-bs-toggle="offcanvas" id="btnNuevoUsuario" type="button">
                    <span class="material-symbols-outlined fs-5">person_add</span>
                    <span>+ Nuevo usuario</span>
                </button>
            </div>
        </div>

        <asp:UpdatePanel runat="server" ID="updFiltros" UpdateMode="Conditional">
        <ContentTemplate>

        <!-- Barra de Filtros Rápidos -->
        <div class="card-custom p-3">
            <div class="row g-2 align-items-center">
                <!-- Search box -->
                <div class="col-12 col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-0 text-secondary">
                            <span class="material-symbols-outlined fs-6">search</span>
                        </span>

                        <asp:TextBox runat="server" ID="txtBuscarUsuario" CssClass="form-control bg-light border-0" Style="font-size: 14px;" Placeholder="Buscar por usuario, nombre o email.."  OnTextChanged="txtBuscarUsuario_TextChanged" AutoPostBack="true"/>
                    </div>
                </div>
                <!-- Filtros select -->
                <div class="col-12 col-md-7 d-flex align-items-center justify-content-md-end gap-2 flex-wrap">
                    <div class="d-flex align-items-center gap-2 bg-light px-2.5 py-1 rounded-3">
                        <span class="material-symbols-outlined fs-6 text-secondary">badge</span>

                        <asp:DropDownList runat="server" ID="ddlfiltrobuscarrol" CssClass="form-select form-select-sm border-0 bg-transparent fw-medium" AutoPostBack="true" OnSelectedIndexChanged="ddlfiltrobuscarrol_SelectedIndexChanged">
                            <asp:ListItem Text="Todos los roles" Value="" />
                            <asp:ListItem Text="Administradores" Value="1" />
                            <asp:ListItem Text="Recepcionistas" Value="2" />
                            <asp:ListItem Text="Médicos" Value="3" />
                        </asp:DropDownList>


                    </div>

                    <div class="d-flex align-items-center gap-2 bg-light px-2.5 py-1 rounded-3">
                        <span class="material-symbols-outlined fs-6 text-secondary">toggle_on</span>

                        <asp:DropDownList runat="server" ID="ddlFiltroActividad" CssClass="form-select form-select-sm border-0 bg-transparent fw-medium" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroActividad_SelectedIndexChanged">
                            <asp:ListItem Text="Todos" Value="" />
                            <asp:ListItem Text="Activos" Value="1" />
                            <asp:ListItem Text="Inactivos" Value="0" />
                        </asp:DropDownList>

                    </div>



                    <asp:LinkButton runat="server" ID="BotonRestablecerFiltro" CssClass="btn btn-light btn-sm d-flex align-items-center justify-content-center p-2 rounded-3 text-secondary" OnClick="BotonRestablecerFiltro_Click"> 
        <span class="material-symbols-outlined fs-6">filter_alt_off</span>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
                            

            </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 2. Tarjetas de Métricas / Resumen Operativo -->
    <div class="row g-3 mb-4">
        <!-- Total Usuarios -->
        <div class="col-12 col-sm-6 col-lg-3">
            <div class="card-custom p-3 d-flex flex-row align-items-center justify-content-between h-100">
                <div class="d-flex flex-column gap-1">
                    <span class="text-uppercase fw-semibold text-secondary" style="font-size: 11px;">Total Usuarios</span>
                    <span class="h4 fw-bold text-dark mb-0">28</span>
                    <span class="small text-success fw-medium d-flex align-items-center gap-1" style="font-size: 12px;">
                        <span class="material-symbols-outlined fs-6">check_circle</span> 100% verificados
                    </span>
                </div>
                <div class="avatar-circle rounded-3" style="background-color: #dce9ff; color: #00626a; width: 48px; height: 48px;">
                    <span class="material-symbols-outlined fs-4">groups</span>
                </div>
            </div>
        </div>
        <!-- Médicos Activos -->
        <div class="col-12 col-sm-6 col-lg-3">
            <div class="card-custom p-3 d-flex flex-row align-items-center justify-content-between h-100">
                <div class="d-flex flex-column gap-1">
                    <span class="text-uppercase fw-semibold text-secondary" style="font-size: 11px;">Médicos Activos</span>
                    <span class="h4 fw-bold text-dark mb-0">14</span>
                    <span class="small text-muted d-flex align-items-center gap-1" style="font-size: 12px;">
                        <span class="rounded-circle" style="width: 6px; height: 6px; background-color: var(--cl-teal-primary);"></span>Vinculados a consultorio
                    </span>
                </div>
                <div class="avatar-circle rounded-3" style="background-color: #98f0fb; color: #004f56; width: 48px; height: 48px;">
                    <span class="material-symbols-outlined fs-4">stethoscope</span>
                </div>
            </div>
        </div>
        <!-- Personal de Recepción -->
        <div class="col-12 col-sm-6 col-lg-3">
            <div class="card-custom p-3 d-flex flex-row align-items-center justify-content-between h-100">
                <div class="d-flex flex-column gap-1">
                    <span class="text-uppercase fw-semibold text-secondary" style="font-size: 11px;">Recepción</span>
                    <span class="h4 fw-bold text-dark mb-0">8</span>
                    <span class="small text-muted d-flex align-items-center gap-1" style="font-size: 12px;">
                        <span class="rounded-circle" style="width: 6px; height: 6px; background-color: #4d5f7b;"></span>3 turnos rotativos
                    </span>
                </div>
                <div class="avatar-circle rounded-3" style="background-color: #d4e3ff; color: #061c35; width: 48px; height: 48px;">
                    <span class="material-symbols-outlined fs-4">support_agent</span>
                </div>
            </div>
        </div>
        <!-- Administradores -->
        <div class="col-12 col-sm-6 col-lg-3">
            <div class="card-custom p-3 d-flex flex-row align-items-center justify-content-between h-100">
                <div class="d-flex flex-column gap-1">
                    <span class="text-uppercase fw-semibold text-secondary" style="font-size: 11px;">Administradores</span>
                    <span class="h4 fw-bold text-dark mb-0">6</span>
                    <span class="small text-success fw-medium d-flex align-items-center gap-1" style="font-size: 12px;">
                        <span class="material-symbols-outlined fs-6">shield</span> Acceso con 2FA
                    </span>
                </div>
                <div class="avatar-circle rounded-3" style="background-color: #d3e4fe; color: #213145; width: 48px; height: 48px;">
                    <span class="material-symbols-outlined fs-4">admin_panel_settings</span>
                </div>
            </div>
        </div>
    </div>


    <asp:UpdatePanel runat="server" ID="updUsuarios" UpdateMode="Conditional" >
        <ContentTemplate>
    
    <!-- 3. Tabla Principal de Usuarios -->
    <div class="card-custom overflow-hidden mb-4">
        <div class="table-responsive">


            <asp:GridView ID="dgvUsuarios" runat="server"
                AutoGenerateColumns="false" DataKeyNames="Id"
                CssClass="table table-custom mb-0 table-hover align-middle"
                AllowPaging="true" PageSize="5"
                  OnPageIndexChanging="dgvUsuarios_PageIndexChanging">

                <Columns>
                    <asp:TemplateField HeaderText="Usuario / Contacto"><%-- agregar el data field despues, tambien a usuario --%>
                        <ItemTemplate>

                            <div class="d-flex align-items-center gap-3">

                                <%-- Foto de perfil genérica --%>
                                <div class="avatar-circle bg-dark text-white">
                                    <span class="material-symbols-outlined">person</span>
                                </div>

                                <div class="d-flex flex-column min-w-0">

                                    <%-- Nombre de usuario --%>
                                    <span class="small text-secondary font-monospace">
                                        <%# Eval("NombreUsuario") %>
                </span>

                                    <%-- Correo electrónico --%>
                                    <span class="small text-muted text-truncate">
                                        <%# Eval("Email") %>
                </span>

                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Rol Asignado">
                        <ItemTemplate>
                            <span class="small text-muted text-truncate">
                                <%# Eval("TipoUsuario") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                     <asp:TemplateField HeaderText="Médico asociado">
                        <ItemTemplate>
                            <span class="small text-muted text-truncate">
                            <%# Eval("Nombre") %> <%# Eval("Apellido") %>
                              </span>
                        </ItemTemplate>
                    </asp:TemplateField>


                     <asp:TemplateField HeaderText="Último acceso">
                        <ItemTemplate>
                            <%# Eval("UltimaConexion") == null ? "..." : Eval("UltimaConexion", "{0:dd/MM/yyyy HH:mm}") %>
                        </ItemTemplate>
                    </asp:TemplateField>




                    <asp:TemplateField HeaderText="Estado">

                        <ItemTemplate>
                            <asp:CheckBox  runat="server" ID="chkEstado" 
                                Checked='<%#Convert.ToBoolean(Eval("Activo")) %>' 
                                 AutoPostBack="true"
                                 OnCheckedChanged="chkEstado_CheckedChanged"/>

                         </ItemTemplate>

                     </asp:TemplateField>



                    <asp:TemplateField HeaderText="Acciones">

                        <ItemTemplate>

                            <div class="d-inline-flex gap-1">
                                <asp:LinkButton runat="server" ID="btnEditar" CssClass="action-btn" OnClick="btnEditar_Click">
                 <span class="material-symbols-outlined">edit</span>
                                </asp:LinkButton>

                                <asp:LinkButton runat="server" ID="btnRestablecer" CssClass="action-btn" OnClick="btnRestablecer_Click">
                 <span class="material-symbols-outlined">key</span>
                                </asp:LinkButton>

                                <asp:LinkButton runat="server" ID="btnEliminar" CssClass="action-btn">
                 <span class="material-symbols-outlined">delete</span>
                                </asp:LinkButton>
                            </div>

                        </ItemTemplate>

                    </asp:TemplateField>



                </Columns>

                <PagerSettings Mode="Numeric" Position="Bottom" />
                <PagerStyle CssClass="pagination-container" HorizontalAlign="Right" />
            </asp:GridView>




        </div>
        <!-- Paginación de Tabla -->

    </div>
            </ContentTemplate>
            </asp:UpdatePanel>
    <!-- 4. Drawer / Modal Lateral de "Nuevo Usuario" usando Offcanvas de Bootstrap 5.3.8 -->
    <div aria-labelledby="drawerNuevoUsuarioLabel" class="offcanvas offcanvas-end offcanvas-custom" id="drawerNuevoUsuario" tabindex="-1">
                    <asp:UpdatePanel runat="server" ID="updAltaUsuario">
                             <ContentTemplate>
        <div class="offcanvas-header bg-light border-bottom p-4">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="material-symbols-outlined fs-4" style="color: var(--cl-teal-primary);">person_add</span>
                    <h5 class="offcanvas-title fw-bold text-dark" id="drawerNuevoUsuarioLabel">Nuevo usuario</h5>
                </div>
                <p class="text-muted small mb-0">Completá los datos para crear una nueva cuenta en el sistema de la clínica.</p>
            </div>
            <button aria-label="Close" class="btn-close" data-bs-dismiss="offcanvas" type="button"></button>
        </div>
        <div class="offcanvas-body p-4 d-flex flex-column gap-3">
            <!-- Nombre Completo -->
            <div>
                <label class="form-label fw-semibold text-dark small mb-1" for="txtNombreCompleto">
                    Nombre completo <span class="text-danger">*</span>
                </label>

                <asp:TextBox runat="server" ID="txtNombreAgregar" CssClass="form-control bg-light border-0" />
            </div>
            <!-- Nombre de Usuario -->
            <div>
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label class="form-label fw-semibold text-dark small mb-0" for="txtNombreUsuario">
                        Nombre de usuario <span class="text-danger">*</span>
                    </label>
                    <span class="text-muted" style="font-size: 11px;">Identificador único</span>
                </div>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0 font-monospace text-secondary fw-bold">@</span>


                    <asp:TextBox runat="server" ID="txtNonbreUsuarioAgregar" CssClass="form-control bg-light border-0 font-monospace" />

                </div>
                <span class="text-muted d-block mt-1" style="font-size: 11px;">Se usará para iniciar sesión en computadoras y terminales.</span>
            </div>
            <!-- Correo electrónico -->
            <div>
                <label class="form-label fw-semibold text-dark small mb-1" for="txtEmailInstitucional">
                    Correo electrónico institucional <span class="text-danger">*</span>
                </label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0 text-secondary">
                        <span class="material-symbols-outlined fs-6">mail</span>
                    </span>

                    <asp:TextBox runat="server" ID="txtCorreoAgregar" CssClass="form-control bg-light border-0" />

                </div>
            </div>

                        
            <!-- Rol del Usuario -->
            <div>
                <label class="form-label fw-semibold text-dark small mb-1" for="ddlRolUsuario">
                    Rol en el sistema <span class="text-danger">*</span>
                </label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0 text-secondary">
                        <span class="material-symbols-outlined fs-6">verified_user</span>
                    </span>

                    <asp:DropDownList runat="server" ID="ddlRolUsuarioAgregar" CssClass="form-select bg-light border-0" AutoPostBack="true" OnSelectedIndexChanged="ddlRolUsuarioAgregar_SelectedIndexChanged">
                        <asp:ListItem Text="Administrador"  Value="1"/>
                        <asp:ListItem Text="Recepcionista"  Value="2"/>
                        <asp:ListItem Text="Médico"  Value="3"/>
                    </asp:DropDownList>

                </div>
            </div>
            <!-- Campo Condicional: Médico Asociado (Destacado) -->
            <div class="p-3 rounded-3" style="background-color: #e5f6f8; border: 1px solid #c2ebef;" runat="server" id="condicionalMedicoDDL" visible="false">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="material-symbols-outlined fs-5" style="color: var(--cl-teal-primary);">link</span>
                    <label class="form-label fw-bold mb-0 small" for="ddlMedicoAsociado" style="color: var(--cl-teal-primary);">
                        Médico asociado a la cuenta
                    </label>
                </div>

                <asp:DropDownList runat="server" ID="ddlMedicosAasociar" AutoPostBack="true" OnSelectedIndexChanged="ddlMedicosAasociar_SelectedIndexChanged" >
                </asp:DropDownList>




                <div class="d-flex align-items-start gap-1 text-secondary" style="font-size: 11px;">
                    <span class="material-symbols-outlined fs-6 mt-0.5" style="color: var(--cl-teal-primary);">info</span>
                    <span>Vincula esta cuenta con la agenda de turnos, firma digital y consultorio del profesional.</span>
                </div>
            </div>



            <!-- Contraseña y Seguridad -->
            <div class="row g-2">
                <div class="col-12 col-sm-6">
                    <label class="form-label fw-semibold text-dark small mb-1" for="txtPassword">
                        Contraseña <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">


                        <asp:TextBox runat="server" ID="txtPassword" TextMode="Password" CssClass="form-control bg-light border-0" />

                        <button class="btn btn-light border-0 text-secondary" type="button">
                            <span class="material-symbols-outlined fs-6">visibility</span>
                        </button>
                    </div>
                </div>
                <div class="col-12 col-sm-6">
                    <label class="form-label fw-semibold text-dark small mb-1" for="txtPasswordConfirm">
                        Repetir contraseña <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox runat="server" ID="txtConfirmarPassword" TextMode="Password" CssClass="form-control bg-light border-0" />

                </div>
            </div>

            <!-- Validación  -->

                <asp:Panel runat="server" ID="pnlMensajeUsuario"
                    Visible="false"
                    CssClass="d-flex align-items-center gap-2 p-2 rounded-2 mt-2">

                    <span class="material-symbols-outlined fs-6">
                        check_circle
                    </span>

                    <asp:Label runat="server" ID="lblmensajefinal"
                        CssClass="fw-semibold"
                        Style="font-size: 12px;" />

                </asp:Panel>


            <!-- Casilla Enviar Notificación -->
            <div class="form-check mt-1">

                <asp:CheckBox runat="server" ID="chkEnviarCredenciales" CssClass="form-check-input" />
                <label class="form-check-label small" for="chkEnviarCredenciales">
                    <strong class="d-block text-dark">Enviar credenciales por correo electrónico</strong>
                    <span class="text-muted" style="font-size: 11px;">Se enviará un enlace temporal seguro para la confirmación de la cuenta.</span>
                </label>
            </div>
        </div>
        <div class="offcanvas-footer bg-light border-top p-3 d-flex justify-content-end gap-2">
            <button class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="offcanvas" type="button">Cancelar</button>

            <asp:LinkButton runat="server" ID="btnGuardarUsuario" CssClass="btn btn-teal btn-sm px-4" OnClick="btnGuardarUsuario_Click">
<span class="material-symbols-outlined fs-6">save</span>
<span>Guardar usuario</span>
            </asp:LinkButton>




        </div>


                        </ContentTemplate>
                 </asp:UpdatePanel>
    </div>








</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>