using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{

    public class TurnoNegocio
    {
        /// SELECT común a todas las consultas de turnos: trae el turno con su paciente,
        /// médico (y turno de trabajo) y especialidad. Cada método le agrega su WHERE.
        private const string SELECT_TURNOS =
            "SELECT T.Id, T.NumeroTurno, T.Fecha, T.Hora, T.Observaciones, T.Estado, " +
            "       P.Id AS IdPaciente, P.Nombre AS PacienteNombre, P.Apellido AS PacienteApellido, " +
            "       P.Dni, P.FechaNacimiento, P.Email AS PacienteEmail, P.Telefono AS PacienteTelefono, " +
            "       P.Direccion AS PacienteDireccion, " +
            "       M.Id AS IdMedico, M.Nombre AS MedicoNombre, M.Apellido AS MedicoApellido, M.Matricula, " +
            "       TT.Id AS IdTurnoTrabajo, TT.Nombre AS TurnoTrabajoNombre, TT.HoraEntrada, TT.HoraSalida, " +
            "       E.Id AS IdEspecialidad, E.Descripcion AS Especialidad, " +
            "       T.IdObraSocial, OS.Nombre AS ObraSocialNombre, OS.Sigla AS ObraSocialSigla, " +
            "       T.IdPlan, POS.NombrePlan AS PlanNombre, T.NumeroAfiliado " +
            "FROM TURNOS T " +
            "INNER JOIN PACIENTES P ON P.Id = T.IdPaciente " +
            "INNER JOIN MEDICOS M ON M.Id = T.IdMedico " +
            "INNER JOIN TURNOS_TRABAJO TT ON TT.Id = M.IdTurnoTrabajo " +
            "INNER JOIN ESPECIALIDADES E ON E.Id = T.IdEspecialidad " +
            "LEFT JOIN ObrasSociales OS ON OS.IdObraSocial = T.IdObraSocial " +
            "LEFT JOIN PlanesObraSocial POS ON POS.IdPlan = T.IdPlan ";

        /// Devuelve los turnos de un médico entre dos fechas (inclusive),
        /// ordenados por fecha y hora.
        public List<Turno> listarPorMedico(int idMedico, DateTime desde, DateTime hasta)
        {
            FiltroTurnos filtro = new FiltroTurnos();
            filtro.IdMedico = idMedico;
            filtro.Desde = desde;
            filtro.Hasta = hasta;
            return buscar(filtro);
        }

        /// Búsqueda avanzada: aplica solo los filtros que vienen cargados.
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
            catch (Exception ex) 
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Busca un turno por Id. Devuelve null si no existe.
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
            catch (Exception ex) 
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Registra un nuevo turno y devuelve el Id asignado.
        public int agregar(Turno nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // 1. Obtener siguiente número correlativo de turno
                datos.setearConsulta("SELECT ISNULL(MAX(NumeroTurno), 1000) + 1 FROM TURNOS;");
                datos.ejecutarLectura();
                int proximoNumero = 1001;
                if (datos.Lector.Read() && !(datos.Lector[0] is DBNull))
                    proximoNumero = Convert.ToInt32(datos.Lector[0]);
                datos.cerrarConexion();

                // 2. Insertar nuevo turno
                datos = new AccesoDatos();
                string consulta = @"
                    INSERT INTO TURNOS (NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, IdObraSocial, IdPlan, NumeroAfiliado, Observaciones, Estado)
                    OUTPUT INSERTED.Id
                    VALUES (@NumeroTurno, @Fecha, @Hora, @IdPaciente, @IdMedico, @IdEspecialidad, @IdObraSocial, @IdPlan, @NumeroAfiliado, @Observaciones, @Estado);";

                datos.setearConsulta(consulta);
                datos.setearParametro("@NumeroTurno", proximoNumero);
                datos.setearParametro("@Fecha", nuevo.Fecha.Date);
                datos.setearParametro("@Hora", nuevo.Hora);
                datos.setearParametro("@IdPaciente", nuevo.Paciente.Id);
                datos.setearParametro("@IdMedico", nuevo.Medico.Id);
                datos.setearParametro("@IdEspecialidad", nuevo.Especialidad.Id);
                datos.setearParametro("@IdObraSocial", (nuevo.ObraSocial != null && nuevo.ObraSocial.IdObraSocial > 0) ? (object)nuevo.ObraSocial.IdObraSocial : DBNull.Value);
                datos.setearParametro("@IdPlan", (nuevo.Plan != null && nuevo.Plan.IdPlan > 0) ? (object)nuevo.Plan.IdPlan : DBNull.Value);
                datos.setearParametro("@NumeroAfiliado", !string.IsNullOrWhiteSpace(nuevo.NumeroAfiliado) ? (object)nuevo.NumeroAfiliado : DBNull.Value);
                datos.setearParametro("@Observaciones", !string.IsNullOrWhiteSpace(nuevo.Observaciones) ? (object)nuevo.Observaciones : DBNull.Value);
                datos.setearParametro("@Estado", nuevo.Estado != 0 ? (int)nuevo.Estado : 1);

                return datos.ejecutarAccionScalar();
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("Invalid column name 'IdObraSocial'") || ex.Message.Contains("Invalid column name 'IdPlan'"))
                {
                    datos.cerrarConexion();
                    datos = new AccesoDatos();
                    datos.setearConsulta(@"
                        INSERT INTO TURNOS (NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, Observaciones, Estado)
                        OUTPUT INSERTED.Id
                        VALUES (@NumeroTurno, @Fecha, @Hora, @IdPaciente, @IdMedico, @IdEspecialidad, @Observaciones, @Estado);");
                    datos.setearParametro("@NumeroTurno", nuevo.NumeroTurno > 0 ? nuevo.NumeroTurno : 1001);
                    datos.setearParametro("@Fecha", nuevo.Fecha.Date);
                    datos.setearParametro("@Hora", nuevo.Hora);
                    datos.setearParametro("@IdPaciente", nuevo.Paciente.Id);
                    datos.setearParametro("@IdMedico", nuevo.Medico.Id);
                    datos.setearParametro("@IdEspecialidad", nuevo.Especialidad.Id);
                    datos.setearParametro("@Observaciones", !string.IsNullOrWhiteSpace(nuevo.Observaciones) ? (object)nuevo.Observaciones : DBNull.Value);
                    datos.setearParametro("@Estado", 1);
                    return datos.ejecutarAccionScalar();
                }
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Verifica si el médico ya tiene un turno reservado en esa fecha y horario.
        public bool existeTurno(int idMedico, DateTime fecha, int hora)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Estado 3 es Cancelado; no bloquea el turno si fue cancelado
                datos.setearConsulta("SELECT COUNT(1) FROM TURNOS WHERE IdMedico = @IdMedico AND Fecha = @Fecha AND Hora = @Hora AND Estado <> 3;");
                datos.setearParametro("@IdMedico", idMedico);
                datos.setearParametro("@Fecha", fecha.Date);
                datos.setearParametro("@Hora", hora);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                    return Convert.ToInt32(datos.Lector[0]) > 0;

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

        /// Devuelve la lista de horas (ej: 8, 9, 10...) ya ocupadas para un médico en una fecha.
        public List<int> listarHorasOcupadas(int idMedico, DateTime fecha)
        {
            List<int> horas = new List<int>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Hora FROM TURNOS WHERE IdMedico = @IdMedico AND Fecha = @Fecha AND Estado <> 3;");
                datos.setearParametro("@IdMedico", idMedico);
                datos.setearParametro("@Fecha", fecha.Date);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    horas.Add((int)datos.Lector["Hora"]);
                }

                return horas;
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

        /// Arma un Turno con la fila actual del lector (columnas de SELECT_TURNOS).
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

            try
            {
                if (!(datos.Lector["IdObraSocial"] is DBNull))
                {
                    turno.ObraSocial = new ObraSocial();
                    turno.ObraSocial.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    turno.ObraSocial.Nombre = datos.Lector["ObraSocialNombre"] is DBNull ? "" : (string)datos.Lector["ObraSocialNombre"];
                    turno.ObraSocial.Sigla = datos.Lector["ObraSocialSigla"] is DBNull ? "" : (string)datos.Lector["ObraSocialSigla"];
                }
            }
            catch { }

            try
            {
                if (!(datos.Lector["IdPlan"] is DBNull))
                {
                    turno.Plan = new PlanObraSocial();
                    turno.Plan.IdPlan = (int)datos.Lector["IdPlan"];
                    turno.Plan.IdObraSocial = turno.ObraSocial != null ? turno.ObraSocial.IdObraSocial : 0;
                    turno.Plan.NombrePlan = datos.Lector["PlanNombre"] is DBNull ? "" : (string)datos.Lector["PlanNombre"];
                }
            }
            catch { }

            try
            {
                if (!(datos.Lector["NumeroAfiliado"] is DBNull))
                    turno.NumeroAfiliado = (string)datos.Lector["NumeroAfiliado"];
            }
            catch { }

            return turno;
        }
    }

    /// Criterios de la búsqueda avanzada de turnos. Los que quedan en null / 0 / vacío no filtran.
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