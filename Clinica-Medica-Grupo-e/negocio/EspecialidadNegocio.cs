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

        public void agregar(Especialidad nuevo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaEspecialidad");
                datos.setearParametro("@Descripcion", nuevo.Descripcion);
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
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarEspecialidad");
                datos.setearParametro("@Id", mod.Id);
                datos.setearParametro("@Descripcion", mod.Descripcion);
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
