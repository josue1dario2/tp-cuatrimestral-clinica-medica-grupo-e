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
        /// SELECT común a todas las consultas de turnos: trae el turno con su paciente,
        /// médico (y turno de trabajo) y especialidad. Cada método le agrega su WHERE.
        /// </summary>
        private const string SELECT_TURNOS =
            "SELECT T.Id, T.NumeroTurno, T.Fecha, T.Hora, T.Observaciones, T.Estado, " +
            "       P.Id AS IdPaciente, P.Nombre AS PacienteNombre, P.Apellido AS PacienteApellido, " +
            "       P.Dni, P.FechaNacimiento, P.Email AS PacienteEmail, P.Telefono AS PacienteTelefono, " +
            "       P.Direccion AS PacienteDireccion, " +
            "       M.Id AS IdMedico, M.Nombre AS MedicoNombre, M.Apellido AS MedicoApellido, M.Matricula, " +
            "       TT.Id AS IdTurnoTrabajo, TT.Nombre AS TurnoTrabajoNombre, TT.HoraEntrada, TT.HoraSalida, " +
            "       E.Id AS IdEspecialidad, E.Descripcion AS Especialidad " +
            "FROM TURNOS T " +
            "INNER JOIN PACIENTES P ON P.Id = T.IdPaciente " +
            "INNER JOIN MEDICOS M ON M.Id = T.IdMedico " +
            "INNER JOIN TURNOS_TRABAJO TT ON TT.Id = M.IdTurnoTrabajo " +
            "INNER JOIN ESPECIALIDADES E ON E.Id = T.IdEspecialidad ";

        /// <summary>
        /// Devuelve los turnos de un médico entre dos fechas (inclusive),
        /// ordenados por fecha y hora.
        /// </summary>
        public List<Turno> listarPorMedico(int idMedico, DateTime desde, DateTime hasta)
        {
            FiltroTurnos filtro = new FiltroTurnos();
            filtro.IdMedico = idMedico;
            filtro.Desde = desde;
            filtro.Hasta = hasta;
            return buscar(filtro);
        }

        /// <summary>
        /// Búsqueda avanzada: aplica solo los filtros que vienen cargados.
        /// </summary>
        public List<Turno> buscar(FiltroTurnos filtro)
        {
            List<Turno> lista = new List<Turno>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string where = "WHERE 1 = 1 ";

                if (filtro.Desde.HasValue)
                {
                    where += "AND T.Fecha >= @desde ";
                    datos.setearParametro("@desde", filtro.Desde.Value.Date);
                }
                if (filtro.Hasta.HasValue)
                {
                    where += "AND T.Fecha <= @hasta ";
                    datos.setearParametro("@hasta", filtro.Hasta.Value.Date);
                }
                if (filtro.IdMedico > 0)
                {
                    where += "AND T.IdMedico = @idMedico ";
                    datos.setearParametro("@idMedico", filtro.IdMedico);
                }
                if (filtro.IdEspecialidad > 0)
                {
                    where += "AND T.IdEspecialidad = @idEspecialidad ";
                    datos.setearParametro("@idEspecialidad", filtro.IdEspecialidad);
                }
                if (filtro.Estado.HasValue)
                {
                    where += "AND T.Estado = @estado ";
                    datos.setearParametro("@estado", (int)filtro.Estado.Value);
                }
                if (filtro.NumeroTurno.HasValue)
                {
                    where += "AND T.NumeroTurno = @numeroTurno ";
                    datos.setearParametro("@numeroTurno", filtro.NumeroTurno.Value);
                }
                if (!string.IsNullOrWhiteSpace(filtro.Paciente))
                {
                    // Busca por apellido, nombre o DNI (el DNI se compara sin puntos).
                    where += "AND (P.Apellido LIKE @paciente OR P.Nombre LIKE @paciente " +
                             "OR (P.Apellido + ', ' + P.Nombre) LIKE @paciente OR P.Dni LIKE @dni) ";
                    datos.setearParametro("@paciente", "%" + filtro.Paciente.Trim() + "%");
                    datos.setearParametro("@dni", "%" + filtro.Paciente.Trim().Replace(".", "") + "%");
                }

                datos.setearConsulta(SELECT_TURNOS + where + "ORDER BY T.Fecha, T.Hora, M.Apellido");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                    lista.Add(armarTurno(datos));

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// <summary>
        /// Busca un turno por Id. Devuelve null si no existe.
        /// </summary>
        public Turno buscarPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(SELECT_TURNOS + "WHERE T.Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                return datos.Lector.Read() ? armarTurno(datos) : null;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// <summary>
        /// Arma un Turno con la fila actual del lector (columnas de SELECT_TURNOS).
        /// </summary>
        private Turno armarTurno(AccesoDatos datos)
        {
            Turno turno = new Turno();
            turno.Id = (int)datos.Lector["Id"];
            turno.NumeroTurno = (int)datos.Lector["NumeroTurno"];
            turno.Fecha = (DateTime)datos.Lector["Fecha"];
            turno.Hora = (int)datos.Lector["Hora"];
            turno.Estado = (EstadoTurno)(int)datos.Lector["Estado"];
            if (!(datos.Lector["Observaciones"] is DBNull))
                turno.Observaciones = (string)datos.Lector["Observaciones"];

            turno.Paciente = new Paciente();
            turno.Paciente.Id = (int)datos.Lector["IdPaciente"];
            turno.Paciente.Nombre = (string)datos.Lector["PacienteNombre"];
            turno.Paciente.Apellido = (string)datos.Lector["PacienteApellido"];
            turno.Paciente.Dni = (string)datos.Lector["Dni"];
            turno.Paciente.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];
            turno.Paciente.Email = (string)datos.Lector["PacienteEmail"];
            if (!(datos.Lector["PacienteTelefono"] is DBNull))
                turno.Paciente.Telefono = (string)datos.Lector["PacienteTelefono"];
            if (!(datos.Lector["PacienteDireccion"] is DBNull))
                turno.Paciente.Direccion = (string)datos.Lector["PacienteDireccion"];

            turno.Medico = new Medico();
            turno.Medico.Id = (int)datos.Lector["IdMedico"];
            turno.Medico.Nombre = (string)datos.Lector["MedicoNombre"];
            turno.Medico.Apellido = (string)datos.Lector["MedicoApellido"];
            turno.Medico.Matricula = (string)datos.Lector["Matricula"];
            turno.Medico.TurnoTrabajo = new TurnoTrabajo();
            turno.Medico.TurnoTrabajo.Id = (int)datos.Lector["IdTurnoTrabajo"];
            turno.Medico.TurnoTrabajo.Nombre = (string)datos.Lector["TurnoTrabajoNombre"];
            turno.Medico.TurnoTrabajo.HoraEntrada = (int)datos.Lector["HoraEntrada"];
            turno.Medico.TurnoTrabajo.HoraSalida = (int)datos.Lector["HoraSalida"];

            turno.Especialidad = new Especialidad();
            turno.Especialidad.Id = (int)datos.Lector["IdEspecialidad"];
            turno.Especialidad.Descripcion = (string)datos.Lector["Especialidad"];

            return turno;
        }
    }

    /// <summary>
    /// Criterios de la búsqueda avanzada de turnos. Los que quedan en null / 0 / vacío no filtran.
    /// </summary>
    public class FiltroTurnos
    {
        public DateTime? Desde { get; set; }
        public DateTime? Hasta { get; set; }
        public int IdMedico { get; set; }
        public int IdEspecialidad { get; set; }
        public string Paciente { get; set; }
        public EstadoTurno? Estado { get; set; }
        public int? NumeroTurno { get; set; }
    }
}
