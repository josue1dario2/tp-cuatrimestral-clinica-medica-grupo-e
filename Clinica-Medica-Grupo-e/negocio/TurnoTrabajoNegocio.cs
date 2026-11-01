using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class TurnoTrabajoNegocio
    {
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
    }
}

