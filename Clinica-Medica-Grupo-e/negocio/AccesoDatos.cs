using System;
using System.Data.SqlClient;

namespace negocio
{
    /// <summary>
    /// Capa de acceso a datos de la base CLINICA_DB (Clínica Médica - Grupo E).
    /// Mantiene la misma interfaz que ya usan las clases de negocio:
    /// setearConsulta, ejecutarLectura, ejecutarAccion, setearParametro,
    /// Lector, obtenerId y cerrarConexion.
    /// </summary>
    public class AccesoDatos
    {
        // ------------------------------------------------------------------
        // Cadena de conexión por defecto: base CLINICA_DB.
        // Si la instancia de SQL Server tiene otro nombre, se cambia SOLO acá:
        //     .\SQLEXPRESS            -> instancia SQLEXPRESS (SSMS típico)
        //     .                       -> instancia por defecto
        //     (localdb)\MSSQLLocalDB  -> LocalDB de Visual Studio
        // Si la base usa login de SQL Server y no autenticación de Windows,
        // reemplazar "integrated security=true" por "user id=sa; password=clave".
        // ------------------------------------------------------------------
        private const string CADENA_POR_DEFECTO =
            "server=.\\SQLEXPRESS; database=CLINICA_DB; integrated security=true";

        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector
        {
            get { return lector; }
        }

        /// <summary>
        /// Abre la conexión contra CLINICA_DB.
        /// </summary>
        public AccesoDatos() : this(CADENA_POR_DEFECTO)
        {
        }

        /// <summary>
        /// Permite trabajar con otra base o con otra cadena de conexión
        /// (por ejemplo la de CATALOGO_P3_DB) sin modificar el código de negocio.
        /// </summary>
        public AccesoDatos(string cadenaConexion)
        {
            if (string.IsNullOrWhiteSpace(cadenaConexion))
                throw new ArgumentException("La cadena de conexión no puede estar vacía.", "cadenaConexion");

            conexion = new SqlConnection(cadenaConexion);
            comando = new SqlCommand();
        }

        /// <summary>
        /// Cadena de conexión realmente en uso (útil para mostrar en un mensaje de error).
        /// </summary>
        public string CadenaConexion
        {
            get { return conexion.ConnectionString; }
        }

        /// <summary>
        /// Carga una consulta SQL escrita a mano (SELECT, INSERT, UPDATE, DELETE, ...).
        /// </summary>
        public void setearConsulta(string consulta)
        {
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        /// <summary>
        /// Carga un procedimiento almacenado de la base, por ejemplo
        /// 'storedListarEspecialidades' o 'storedListarPacientes'.
        /// </summary>
        public void setearProcedimientoAlmacenado(string nombre)
        {
            comando.CommandType = System.Data.CommandType.StoredProcedure;
            comando.CommandText = nombre;
        }

        /// <summary>
        /// Ejecuta la consulta cargada y deja el resultado en Lector.
        /// El llamador debe recorrer Lector y después llamar a cerrarConexion().
        /// </summary>
        public void ejecutarLectura()
        {
            comando.Connection = conexion;

            if (conexion.State != System.Data.ConnectionState.Open)
                conexion.Open();

            lector = comando.ExecuteReader();
        }

        /// <summary>
        /// Ejecuta INSERT, UPDATE, DELETE o un procedimiento que no devuelve filas.
        /// </summary>
        public void ejecutarAccion()
        {
            comando.Connection = conexion;

            if (conexion.State != System.Data.ConnectionState.Open)
                conexion.Open();

            comando.ExecuteNonQuery();
        }

        /// <summary>
        /// Agrega un parámetro a la consulta. Se recomienda usar el nombre con @
        /// (@id, @fecha, ...) y pasar DBNull.Value cuando el valor es NULL.
        /// </summary>
        public void setearParametro(string nombre, object valor)
        {
            comando.Parameters.AddWithValue(nombre, valor ?? DBNull.Value);
        }

        /// <summary>
        /// Cierra el lector (si quedó abierto) y la conexión. Es seguro llamarlo
        /// más de una vez, por eso se usa siempre desde el bloque finally.
        /// </summary>
        public void cerrarConexion()
        {
            if (lector != null)
            {
                if (!lector.IsClosed)
                    lector.Close();

                lector.Dispose();
                lector = null;
            }

            if (conexion != null && conexion.State != System.Data.ConnectionState.Closed)
                conexion.Close();
        }

        /// <summary>
        /// Devuelve el primer valor de la primera fila. Pensado para INSERT con
        /// "SELECT SCOPE_IDENTITY();" al final, que es como se obtiene el Id
        /// generado por las tablas IDENTITY de CLINICA_DB (USUARIOS, MEDICOS,
        /// PACIENTES, TURNOS, ESPECIALIDADES).
        /// </summary>
        public int obtenerId()
        {
            comando.Connection = conexion;

            if (conexion.State != System.Data.ConnectionState.Open)
                conexion.Open();

            object resultado = comando.ExecuteScalar();

            if (resultado == null || resultado == DBNull.Value)
                return 0;

            return Convert.ToInt32(resultado);
        }

    }
}
