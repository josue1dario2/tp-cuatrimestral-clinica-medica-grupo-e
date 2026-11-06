using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class EspecialidadNegocio
    {
        public List<Especialidad> listar(string id = "")
        {
            List<Especialidad> lista = new List<Especialidad>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarEspecialidades");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Especialidad especialidad = new Especialidad();
                    especialidad.Id = (int)datos.Lector["Id"];
                    especialidad.Descripcion = (string)datos.Lector["Descripcion"];
                    especialidad.Activo = (bool)datos.Lector["Activo"];

                    if (string.IsNullOrEmpty(id) || especialidad.Id.ToString() == id)
                    {
                        lista.Add(especialidad);
                    }
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Especialidad buscarPorId(int id)
        {
            List<Especialidad> lista = listar(id.ToString());
            return lista.Count > 0 ? lista[0] : null;
        }

        public bool existe(string descripcion, int id = 0)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "SELECT COUNT(1) FROM ESPECIALIDADES WHERE LTRIM(RTRIM(LOWER(Descripcion))) = LTRIM(RTRIM(LOWER(@Descripcion)))";
                if (id > 0)
                {
                    consulta += " AND Id <> @Id";
                    datos.setearParametro("@Id", id);
                }

                datos.setearConsulta(consulta);
                datos.setearParametro("@Descripcion", descripcion.Trim());
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return Convert.ToInt32(datos.Lector[0]) > 0;
                }
                return false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Especialidad nuevo)
        {
            if (existe(nuevo.Descripcion))
            {
                throw new Exception("Ya existe una especialidad registrada con la descripción '" + nuevo.Descripcion.Trim() + "'.");
            }

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaEspecialidad");
                datos.setearParametro("@Descripcion", nuevo.Descripcion.Trim());
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void modificar(Especialidad mod)
        {
            if (existe(mod.Descripcion, mod.Id))
            {
                throw new Exception("Ya existe otra especialidad registrada con la descripción '" + mod.Descripcion.Trim() + "'.");
            }

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarEspecialidad");
                datos.setearParametro("@Id", mod.Id);
                datos.setearParametro("@Descripcion", mod.Descripcion.Trim());
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void eliminar(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedEliminarEspecialidad");
                datos.setearParametro("@Id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
