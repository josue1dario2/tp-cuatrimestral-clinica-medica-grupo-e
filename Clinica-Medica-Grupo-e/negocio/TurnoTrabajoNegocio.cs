using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class TurnoTrabajoNegocio
    {
        // Solo los turnos activos. Lo usa, por ejemplo, la lista de turnos de FormularioMedico.
        public List<TurnoTrabajo> listar()
        {
            List<TurnoTrabajo> lista = new List<TurnoTrabajo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarTurnosTrabajo");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    TurnoTrabajo turno = new TurnoTrabajo();
                    turno.Id = (int)datos.Lector["Id"];
                    turno.Nombre = (string)datos.Lector["Nombre"];
                    turno.HoraEntrada = (int)datos.Lector["HoraEntrada"];
                    turno.HoraSalida = (int)datos.Lector["HoraSalida"];
                    turno.Activo = true;
                    lista.Add(turno);
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

        // Todos los turnos (activos e inactivos) con la cantidad de médicos asignados. Lo usa TurnosTrabajo.aspx.
        public List<TurnoTrabajo> listarParaGestion()
        {
            List<TurnoTrabajo> lista = new List<TurnoTrabajo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarTurnosTrabajoGestion");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    TurnoTrabajo turno = new TurnoTrabajo();
                    turno.Id = (int)datos.Lector["Id"];
                    turno.Nombre = (string)datos.Lector["Nombre"];
                    turno.HoraEntrada = (int)datos.Lector["HoraEntrada"];
                    turno.HoraSalida = (int)datos.Lector["HoraSalida"];
                    turno.Activo = (bool)datos.Lector["Activo"];
                    turno.CantidadMedicos = (int)datos.Lector["CantidadMedicos"];
                    lista.Add(turno);
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

        public TurnoTrabajo buscarPorId(int id)
        {
            foreach (TurnoTrabajo turno in listarParaGestion())
            {
                if (turno.Id == id)
                    return turno;
            }
            return null;
        }

        public void agregar(TurnoTrabajo nuevo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaTurnoTrabajo");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@HoraEntrada", nuevo.HoraEntrada);
                datos.setearParametro("@HoraSalida", nuevo.HoraSalida);
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

        public void modificar(TurnoTrabajo mod)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarTurnoTrabajo");
                datos.setearParametro("@Id", mod.Id);
                datos.setearParametro("@Nombre", mod.Nombre);
                datos.setearParametro("@HoraEntrada", mod.HoraEntrada);
                datos.setearParametro("@HoraSalida", mod.HoraSalida);
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

        // Baja lógica: Activo = 0.
        public void eliminar(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedEliminarTurnoTrabajo");
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

        // Vuelve a activar un turno dado de baja: Activo = 1.
        public void reactivar(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedReactivarTurnoTrabajo");
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
