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
        /// Busca un médico por Id con su turno de trabajo y sus especialidades.
        /// Devuelve null si no existe.
        public Medico buscarPorId(int id)
        {
            Medico medico = null;
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT M.Id, M.Nombre, M.Apellido, M.Matricula, M.Email, M.Telefono, M.IdUsuario, M.Activo, " +
                    "       TT.Id AS IdTurnoTrabajo, TT.Nombre AS TurnoNombre, TT.HoraEntrada, TT.HoraSalida " +
                    "FROM MEDICOS M " +
                    "INNER JOIN TURNOS_TRABAJO TT ON TT.Id = M.IdTurnoTrabajo " +
                    "WHERE M.Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    medico = new Medico();
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
                    medico.TurnoTrabajo.Nombre = (string)datos.Lector["TurnoNombre"];
                    medico.TurnoTrabajo.HoraEntrada = (int)datos.Lector["HoraEntrada"];
                    medico.TurnoTrabajo.HoraSalida = (int)datos.Lector["HoraSalida"];
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

            if (medico != null)
                medico.Especialidades = listarEspecialidades(medico.Id);

            return medico;
        }

        /// Lista los médicos ordenados por apellido (para combos y filtros).
        /// No trae especialidades ni turno de trabajo.
        public List<Medico> listar(bool soloActivos)
        {
            List<Medico> lista = new List<Medico>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT Id, Nombre, Apellido, Matricula, Activo FROM MEDICOS " +
                    (soloActivos ? "WHERE Activo = 1 " : "") +
                    "ORDER BY Apellido, Nombre");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Medico medico = new Medico();
                    medico.Id = (int)datos.Lector["Id"];
                    medico.Nombre = (string)datos.Lector["Nombre"];
                    medico.Apellido = (string)datos.Lector["Apellido"];
                    medico.Matricula = (string)datos.Lector["Matricula"];
                    medico.Activo = (bool)datos.Lector["Activo"];
                    lista.Add(medico);
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

        /// Especialidades asignadas a un médico (tabla MEDICOS_ESPECIALIDADES).
        public List<Especialidad> listarEspecialidades(int idMedico)
        {
            List<Especialidad> lista = new List<Especialidad>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT E.Id, E.Descripcion, E.Activo " +
                    "FROM MEDICOS_ESPECIALIDADES ME " +
                    "INNER JOIN ESPECIALIDADES E ON E.Id = ME.IdEspecialidad " +
                    "WHERE ME.IdMedico = @idMedico " +
                    "ORDER BY E.Descripcion");
                datos.setearParametro("@idMedico", idMedico);
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
    }
}
