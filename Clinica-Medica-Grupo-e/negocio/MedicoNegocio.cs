using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    /// <summary>
    /// Operaciones sobre la tabla MEDICOS.
    /// </summary>
    public class MedicoNegocio
    {
        /// <summary>
        /// Busca un médico por Id con su turno de trabajo y sus especialidades.
        /// Devuelve null si no existe.
        /// </summary>
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
            finally
            {
                datos.cerrarConexion();
            }

            if (medico != null)
                medico.Especialidades = listarEspecialidades(medico.Id);

            return medico;
        }

        /// <summary>
        /// Especialidades asignadas a un médico (tabla MEDICOS_ESPECIALIDADES).
        /// </summary>
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
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
