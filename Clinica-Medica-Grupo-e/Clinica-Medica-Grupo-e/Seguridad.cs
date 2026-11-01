using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using dominio;

namespace Clinica_Medica_Grupo_e
{
    public static class Seguridad
    {
        public static bool sesionActiva(object user)
        {
            Usuario usuario = user != null ? (Usuario)user : null;
            return usuario != null && usuario.Id != 0;
        }

        public static bool esAdmin(object user)
        {
            Usuario usuario = user != null ? (Usuario)user : null;
            return usuario != null && usuario.TipoUsuario == TipoUsuario.Admin;
        }
    }
}

