using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    /// <summary>
    /// Operaciones sobre la tabla TURNOS.
    /// </summary>
    public class TurnoNegocio
    {
        /// <summary>
        /// Devuelve los turnos de un médico entre dos fechas (inclusive),
        /// ordenados por fecha y hora, con los datos del paciente y la especialidad.
        /// </summary>
        public List<Turno> listarPorMedico(int idMedico, DateTime desde, DateTime hasta)
        {
            List<Turno> lista = new List<Turno>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT T.Id, T.NumeroTurno, T.Fecha, T.Hora, T.Observaciones, T.Estado, T.IdMedico, " +
                    "       P.Id AS IdPaciente, P.Nombre AS PacienteNombre, P.Apellido AS PacienteApellido, " +
                    "       P.Dni, P.FechaNacimiento, P.Email AS PacienteEmail, P.Telefono AS PacienteTelefono, " +
                    "       E.Id AS IdEspecialidad, E.Descripcion AS Especialidad " +
                    "FROM TURNOS T " +
                    "INNER JOIN PACIENTES P ON P.Id = T.IdPaciente " +
                    "INNER JOIN ESPECIALIDADES E ON E.Id = T.IdEspecialidad " +
                    "WHERE T.IdMedico = @idMedico AND T.Fecha BETWEEN @desde AND @hasta " +
                    "ORDER BY T.Fecha, T.Hora");
                datos.setearParametro("@idMedico", idMedico);
                datos.setearParametro("@desde", desde.Date);
                datos.setearParametro("@hasta", hasta.Date);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Turno turno = new Turno();
                    turno.Id = (int)datos.Lector["Id"];
                    turno.NumeroTurno = (int)datos.Lector["NumeroTurno"];
                    turno.Fecha = (DateTime)datos.Lector["Fecha"];
                    turno.Hora = (int)datos.Lector["Hora"];
                    turno.Estado = (EstadoTurno)(int)datos.Lector["Estado"];
                    if (!(datos.Lector["Observaciones"] is DBNull))
                        turno.Observaciones = (string)datos.Lector["Observaciones"];

                    turno.Medico = new Medico();
                    turno.Medico.Id = (int)datos.Lector["IdMedico"];

                    turno.Paciente = new Paciente();
                    turno.Paciente.Id = (int)datos.Lector["IdPaciente"];
                    turno.Paciente.Nombre = (string)datos.Lector["PacienteNombre"];
                    turno.Paciente.Apellido = (string)datos.Lector["PacienteApellido"];
                    turno.Paciente.Dni = (string)datos.Lector["Dni"];
                    turno.Paciente.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];
                    turno.Paciente.Email = (string)datos.Lector["PacienteEmail"];
                    if (!(datos.Lector["PacienteTelefono"] is DBNull))
                        turno.Paciente.Telefono = (string)datos.Lector["PacienteTelefono"];

                    turno.Especialidad = new Especialidad();
                    turno.Especialidad.Id = (int)datos.Lector["IdEspecialidad"];
                    turno.Especialidad.Descripcion = (string)datos.Lector["Especialidad"];

                    lista.Add(turno);
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
