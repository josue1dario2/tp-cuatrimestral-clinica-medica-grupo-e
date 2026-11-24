<%@ Page Title="Iniciar sesión" Language="C#" MasterPageFile="~/MasterInicio.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Clinica_Medica_Grupo_e.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="<%= ResolveUrl("~/Content/login.css") %>" rel="stylesheet" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid p-0">
        <div class="row g-0 min-vh-100">

            <!-- PANEL IZQUIERDO -->
            <div class="col-lg-6 cl-hero-side">

                <div class="cl-hero-circle-1"></div>
                <div class="cl-hero-circle-2"></div>

                <!-- LOGO Y NOMBRE -->
                <div class="position-relative" style="z-index: 2;">

                    <div class="d-flex align-items-center gap-3 mb-5">

                        <div class="cl-icon-box">
                            <i class="fa-solid fa-heart-pulse"></i>
                        </div>

                        <div>
                            <h4 class="mb-0 fw-bold">Clínica Moderna Salud</h4>
                            <small class="text-white-50">Sistema de gestión médica</small>
                        </div>

                    </div>

                    <div class="mt-5 pt-4">

                        <span class="cl-tag-portal mb-4">
                            <i class="fa-solid fa-shield-heart"></i>
                            PORTAL DE ACCESO
                        </span>

                        <h1 class="display-5 fw-bold mt-4 mb-3">
                            Tu salud, nuestra prioridad.
                        </h1>

                        <p class="fs-5 text-white-50 mb-5">
                            Gestioná tus turnos y accedé a la información
                            de manera simple, segura y organizada.
                        </p>

                    </div>

                </div>

                <!-- TARJETA VISUAL -->
                <div class="position-relative mt-4" style="z-index: 2;">

                    <div class="cl-preview-card">

                        <img
                            src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=1000&q=80"
                            class="cl-preview-img"
                            alt="Profesionales de la salud" />

                        <div class="cl-preview-gradient"></div>

                        <div class="position-absolute bottom-0 start-0 p-4 text-white">

                            <h5 class="fw-bold mb-2">
                                Atención médica organizada
                            </h5>

                            <p class="mb-0 small text-white-50">
                                Una plataforma diseñada para facilitar
                                el trabajo de nuestros profesionales.
                            </p>

                        </div>

                    </div>

                </div>

                <!-- PIE DEL PANEL -->
                <div class="position-relative mt-4 text-white-50 small" style="z-index: 2;">
                    <i class="fa-solid fa-lock me-2"></i>
                    Acceso seguro para personal autorizado
                </div>

            </div>

            <!-- PANEL DERECHO -->
            <div class="col-lg-6 d-flex align-items-center justify-content-center p-3 p-md-5">

                <div class="cl-login-card">

                    <!-- ENCABEZADO -->
                    <div class="mb-4">

                        <div class="d-lg-none d-flex align-items-center gap-2 mb-5">

                            <div class="cl-icon-box">
                                <i class="fa-solid fa-heart-pulse"></i>
                            </div>

                            <div>
                                <h5 class="mb-0 fw-bold">Clínica Moderna Salud</h5>
                                <small class="text-muted">Sistema de gestión médica</small>
                            </div>

                        </div>

                        <span class="text-uppercase fw-bold small" style="color: var(--cl-teal-primary);">
                            Bienvenido
                        </span>

                        <h2 class="fw-bold mt-2 mb-2">
                            Iniciar sesión
                        </h2>

                        <p class="text-muted mb-0">
                            Ingresá tus credenciales para acceder al sistema.
                        </p>

                    </div>

                    <!-- FORMULARIO -->
                    <div>

                        <!-- USUARIO -->
                        <div class="mb-4">

                            <label for="<%= txtUsuario.ClientID %>" class="form-label fw-semibold small">
                                Nombre de usuario
                            </label>

                            <div class="cl-input-group-icon">

                                <i class="fa-solid fa-user"></i>

                                <asp:TextBox
                                    ID="txtUsuario"
                                    runat="server"
                                    CssClass="cl-form-control-custom"
                                    placeholder="Ingresá tu usuario"
                                    MaxLength="50">
                                </asp:TextBox>

                            </div>

                        </div>

                        <!-- CONTRASEÑA -->
                        <div class="mb-3">

                            <label for="<%= txtContrasena.ClientID %>" class="form-label fw-semibold small">
                                Contraseña
                            </label>

                            <div class="cl-input-group-icon">

                                <i class="fa-solid fa-lock"></i>

                                <asp:TextBox
                                    ID="txtContrasena"
                                    runat="server"
                                    TextMode="Password"
                                    CssClass="cl-form-control-custom"
                                    placeholder="Ingresá tu contraseña">
                                </asp:TextBox>

                                <button
                                    type="button"
                                    id="btnToggleContrasena"
                                    class="cl-toggle-password-btn"
                                    aria-label="Mostrar contraseña">

                                    <i class="fa-solid fa-eye"></i>

                                </button>

                            </div>

                        </div>

                        <!-- RECORDAR Y RECUPERAR -->
                        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">

                            <div class="form-check">

                                <asp:CheckBox
                                    ID="chkRecordar"
                                    runat="server"
                                    CssClass="form-check-input" />

                                <label class="form-check-label small" for="<%= chkRecordar.ClientID %>">
                                    Recordarme
                                </label>

                            </div>

                            <a href="#" class="small fw-semibold">
                                ¿Olvidaste tu contraseña?
                            </a>

                        </div>

                        <!-- MENSAJE DE ERROR -->
                        <asp:Panel
                            ID="pnlError"
                            runat="server"
                            Visible="false"
                            CssClass="cl-alert-error mb-4">

                            <div class="cl-error-icon-box">
                                <i class="fa-solid fa-circle-exclamation"></i>
                            </div>

                            <asp:Label
                                ID="lblError"
                                runat="server">
                            </asp:Label>

                        </asp:Panel>

                        <!-- BOTÓN INGRESAR -->
                        <asp:Button
                            ID="btnIngresar"
                            runat="server"
                            Text="Ingresar"
                            CssClass="cl-btn-primary-custom"
                             OnClick="btnIngresar_Click" />

                    </div>

                    <!-- ROLES -->
                    <div class="mt-5">

                        <div class="text-center mb-3">
                            <small class="text-muted">
                                Plataforma de uso interno
                            </small>
                        </div>

                        <div class="d-flex justify-content-center flex-wrap gap-2">

                            <span class="cl-role-tag">
                                <i class="fa-solid fa-user-shield"></i>
                                Administrador
                            </span>

                            <span class="cl-role-tag">
                                <i class="fa-solid fa-headset"></i>
                                Recepcionista
                            </span>

                            <span class="cl-role-tag">
                                <i class="fa-solid fa-user-doctor"></i>
                                Médico
                            </span>

                        </div>

                    </div>

                    <!-- PIE -->
                    <div class="text-center mt-5">

                        <small class="text-muted">
                            ¿Necesitás ayuda?
                            <a href="mailto:soporte@clinicamedica.com" class="fw-semibold">
                                Contactá a soporte
                            </a>
                        </small>

                    </div>

                </div>

            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">

    <script>

        document.addEventListener("DOMContentLoaded", function () {

            const inputContrasena = document.getElementById('<%= txtContrasena.ClientID %>');
            const botonToggle = document.getElementById('btnToggleContrasena');

            if (inputContrasena && botonToggle) {

                botonToggle.addEventListener("click", function () {

                    const icono = botonToggle.querySelector("i");

                    if (inputContrasena.type === "password") {

                        inputContrasena.type = "text";
                        icono.classList.remove("fa-eye");
                        icono.classList.add("fa-eye-slash");
                        botonToggle.setAttribute("aria-label", "Ocultar contraseña");

                    } else {

                        inputContrasena.type = "password";
                        icono.classList.remove("fa-eye-slash");
                        icono.classList.add("fa-eye");
                        botonToggle.setAttribute("aria-label", "Mostrar contraseña");

                    }

                });

            }

        });

    </script>

</asp:Content>