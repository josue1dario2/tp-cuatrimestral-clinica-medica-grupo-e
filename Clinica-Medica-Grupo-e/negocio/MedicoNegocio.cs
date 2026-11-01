using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class MedicoNegocio
    {
        public List<Medico> listarConDetalle()
        {
            List<Medico> lista = new List<Medico>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarMedicosConDetalle");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Medico medico = new Medico();
                    medico.Id = (int)datos.Lector["Id"];
                    medico.Nombre = (string)datos.Lector["Nombre"];
                    medico.Apellido = (string)datos.Lector["Apellido"];
                    medico.Matricula = (string)datos.Lector["Matricula"];
                    if (!(datos.Lector["Email"] is DBNull))
                        medico.Email = (string)datos.Lector["Email"];
                    if (!(datos.Lector["Telefono"] is DBNull))
                        medico.Telefono = (string)datos.Lector["Telefono"];
                    if (!(datos.Lector["IdUsuario"] is DBNull))
                    {
                        medico.Usuario = new Usuario();
                        medico.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    }
                    medico.Activo = (bool)datos.Lector["Activo"];

                    medico.TurnoTrabajo = new TurnoTrabajo();
                    medico.TurnoTrabajo.Id = (int)datos.Lector["IdTurnoTrabajo"];
                    medico.TurnoTrabajo.Nombre = (string)datos.Lector["TurnoTrabajoNombre"];
                    medico.TurnoTrabajo.HoraEntrada = (int)datos.Lector["HoraEntrada"];
                    medico.TurnoTrabajo.HoraSalida = (int)datos.Lector["HoraSalida"];

                    lista.Add(medico);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }

            foreach (Medico m in lista)
            {
                m.Especialidades = listarEspecialidades(m.Id);
            }

            return lista;
        }

        public Medico buscarPorId(int id)
        {
            List<Medico> lista = listarConDetalle();
            return lista.FirstOrDefault(m => m.Id == id);
        }

        public List<Medico> listar(bool soloActivos = false)
        {
            List<Medico> lista = listarConDetalle();
            if (soloActivos)
                return lista.Where(m => m.Activo).ToList();
            return lista;
        }

        public List<Especialidad> listarEspecialidades(int idMedico)
        {
            List<Especialidad> lista = new List<Especialidad>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarEspecialidadesPorMedico");
                datos.setearParametro("@IdMedico", idMedico);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Especialidad especialidad = new Especialidad();
                    especialidad.Id = (int)datos.Lector["Id"];
                    especialidad.Descripcion = (string)datos.Lector["Descripcion"];
                    especialidad.Activo = (bool)datos.Lector["Activo"];
                    lista.Add(especialidad);
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

        public void agregar(Medico nuevo, int idEspecialidad)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaMedico");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Apellido", nuevo.Apellido);
                datos.setearParametro("@Matricula", nuevo.Matricula);
                datos.setearParametro("@Email", string.IsNullOrEmpty(nuevo.Email) ? (object)DBNull.Value : nuevo.Email);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(nuevo.Telefono) ? (object)DBNull.Value : nuevo.Telefono);
                datos.setearParametro("@IdTurnoTrabajo", nuevo.TurnoTrabajo != null ? nuevo.TurnoTrabajo.Id : 1);
                datos.setearParametro("@IdEspecialidad", idEspecialidad > 0 ? (object)idEspecialidad : DBNull.Value);
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

        public void modificar(Medico mod, int idEspecialidad)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarMedico");
                datos.setearParametro("@Id", mod.Id);
                datos.setearParametro("@Nombre", mod.Nombre);
                datos.setearParametro("@Apellido", mod.Apellido);
                datos.setearParametro("@Matricula", mod.Matricula);
                datos.setearParametro("@Email", string.IsNullOrEmpty(mod.Email) ? (object)DBNull.Value : mod.Email);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(mod.Telefono) ? (object)DBNull.Value : mod.Telefono);
                datos.setearParametro("@IdTurnoTrabajo", mod.TurnoTrabajo != null ? mod.TurnoTrabajo.Id : 1);
                datos.setearParametro("@IdEspecialidad", idEspecialidad > 0 ? (object)idEspecialidad : DBNull.Value);
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
                datos.setearProcedimiento("storedEliminarMedico");
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
