using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    /// Atenciones de turnos (tabla ATENCIONES) y cierre del turno desde AtencionTurno.aspx.
    public class AtencionNegocio
    {
        /// Códigos que devuelven cerrarTurno y marcarNoAsistio.
        public const int RESULTADO_OK = 1;
        public const int RESULTADO_NO_PENDIENTE = 0;    // no existe, no es del médico o ya no está Nuevo/Reprogramado
        public const int RESULTADO_TURNO_FUTURO = -1;   // el turno es de un día que todavía no llegó

        /// Cierra el turno (Estado Cerrado) y guarda la atención, en una sola transacción.
        public int cerrarTurno(Atencion atencion, int idMedico)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedCerrarTurnoConAtencion");
                datos.setearParametro("@IdTurno", atencion.Turno.Id);
                datos.setearParametro("@IdMedico", idMedico);
                datos.setearParametro("@Evolucion", atencion.Evolucion);
                // AddWithValue no acepta null: los opcionales vacíos van como DBNull.
                datos.setearParametro("@Prescripcion", ValorONulo(atencion.Prescripcion));
                datos.setearParametro("@TensionArterial", ValorONulo(atencion.TensionArterial));
                datos.setearParametro("@FrecuenciaCardiaca", ValorONulo(atencion.FrecuenciaCardiaca));
                datos.setearParametro("@SaturacionOxigeno", ValorONulo(atencion.SaturacionOxigeno));
                datos.setearParametro("@Peso", ValorONulo(atencion.Peso));
                return datos.ejecutarAccionScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Marca el turno como No asistió. Devuelve los mismos códigos que cerrarTurno.
        public int marcarNoAsistio(int idTurno, int idMedico)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedMarcarTurnoNoAsistio");
                datos.setearParametro("@IdTurno", idTurno);
                datos.setearParametro("@IdMedico", idMedico);
                return datos.ejecutarAccionScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Atención registrada de un turno, o null si el turno no tiene.
        public Atencion buscarPorTurno(int idTurno)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedBuscarAtencionPorTurno");
                datos.setearParametro("@IdTurno", idTurno);
                datos.ejecutarLectura();

                return datos.Lector.Read() ? armarAtencion(datos) : null;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Atenciones anteriores del paciente con el médico (sin contar el turno actual), de la más reciente a la más antigua.
        public List<Atencion> listarAnteriores(int idPaciente, int idMedico, int idTurnoActual)
        {
            List<Atencion> lista = new List<Atencion>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarAtencionesAnteriores");
                datos.setearParametro("@IdPaciente", idPaciente);
                datos.setearParametro("@IdMedico", idMedico);
                datos.setearParametro("@IdTurnoActual", idTurnoActual);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                    lista.Add(armarAtencion(datos));

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        /// Arma una Atencion con la fila actual del lector.
        private Atencion armarAtencion(AccesoDatos datos)
        {
            Atencion atencion = new Atencion();
            atencion.Id = (int)datos.Lector["Id"];
            atencion.Evolucion = (string)datos.Lector["Evolucion"];
            atencion.FechaRegistro = (DateTime)datos.Lector["FechaRegistro"];

            if (!(datos.Lector["Prescripcion"] is DBNull))
                atencion.Prescripcion = (string)datos.Lector["Prescripcion"];
            if (!(datos.Lector["TensionArterial"] is DBNull))
                atencion.TensionArterial = (string)datos.Lector["TensionArterial"];
            if (!(datos.Lector["FrecuenciaCardiaca"] is DBNull))
                atencion.FrecuenciaCardiaca = (int)datos.Lector["FrecuenciaCardiaca"];
            if (!(datos.Lector["SaturacionOxigeno"] is DBNull))
                atencion.SaturacionOxigeno = (int)datos.Lector["SaturacionOxigeno"];
            if (!(datos.Lector["Peso"] is DBNull))
                atencion.Peso = (decimal)datos.Lector["Peso"];

            atencion.Turno = new Turno();
            atencion.Turno.Id = (int)datos.Lector["IdTurno"];
            atencion.Turno.Fecha = (DateTime)datos.Lector["Fecha"];
            atencion.Turno.Hora = (int)datos.Lector["Hora"];
            if (!(datos.Lector["Observaciones"] is DBNull))
                atencion.Turno.Observaciones = (string)datos.Lector["Observaciones"];

            return atencion;
        }

        private static object ValorONulo(object valor)
        {
            if (valor == null)
                return DBNull.Value;
            string texto = valor as string;
            if (texto != null && texto.Trim() == "")
                return DBNull.Value;
            return valor;
        }
    }
}
