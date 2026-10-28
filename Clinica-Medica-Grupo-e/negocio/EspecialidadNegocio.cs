using System.Collections.Generic;
using dominio;

namespace negocio
{
    /// <summary>
    /// Operaciones sobre la tabla ESPECIALIDADES.
    /// </summary>
    public class EspecialidadNegocio
    {
        /// <summary>
        /// Especialidades activas, usando el procedimiento almacenado storedListarEspecialidades.
        /// </summary>
        public List<Especialidad> listar()
        {
            List<Especialidad> lista = new List<Especialidad>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimientoAlmacenado("storedListarEspecialidades");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Especialidad especialidad = new Especialidad();
                    especialidad.Id = (int)datos.Lector["Id"];
                    especialidad.Descripcion = (string)datos.Lector["Descripcion"];
                    especialidad.Activo = (bool)datos.Lector["Activo"];
                    lista.Add(especialidad);
                }

                lista.Sort((a, b) => string.Compare(a.Descripcion, b.Descripcion, System.StringComparison.CurrentCulture));
                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
