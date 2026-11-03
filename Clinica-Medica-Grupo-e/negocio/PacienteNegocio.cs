using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class PacienteNegocio
    {
        public List<Paciente> listar(bool soloActivos = false)
        {
            List<Paciente> lista = new List<Paciente>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarPacientes");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    lista.Add(mapearPaciente(datos.Lector));
                }

                if (soloActivos)
                    return lista.Where(p => p.Activo).ToList();

                return lista;
            }
            catch (Exception)
            {
                // Fallback por consulta SQL directa si el procedimiento almacenado no fue instalado
                datos.cerrarConexion();
                datos = new AccesoDatos();
                try
                {
                    datos.setearConsulta("SELECT Id, Dni, Nombre, Apellido, FechaNacimiento, Email, Telefono, Direccion, Activo FROM PACIENTES WHERE Activo = 1 ORDER BY Apellido, Nombre ASC");
                    datos.ejecutarLectura();

                    while (datos.Lector.Read())
                    {
                        lista.Add(mapearPaciente(datos.Lector));
                    }

                    if (soloActivos)
                        return lista.Where(p => p.Activo).ToList();

                    return lista;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Paciente buscarPorId(int id)
        {
            List<Paciente> lista = listar();
            Paciente encontrado = lista.FirstOrDefault(p => p.Id == id);
            if (encontrado != null)
                return encontrado;

            // Búsqueda directa por ID en caso de consultar un paciente inactivo
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Dni, Nombre, Apellido, FechaNacimiento, Email, Telefono, Direccion, Activo FROM PACIENTES WHERE Id = @Id");
                datos.setearParametro("@Id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return mapearPaciente(datos.Lector);
                }

                return null;
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

        public void agregar(Paciente nuevo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaPaciente");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Apellido", nuevo.Apellido);
                datos.setearParametro("@Dni", nuevo.Dni);
                datos.setearParametro("@FechaNacimiento", nuevo.FechaNacimiento);
                datos.setearParametro("@Email", nuevo.Email);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(nuevo.Telefono) ? (object)DBNull.Value : nuevo.Telefono);
                datos.setearParametro("@Direccion", string.IsNullOrEmpty(nuevo.Direccion) ? (object)DBNull.Value : nuevo.Direccion);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("storedAltaPaciente") || ex.Message.Contains("Could not find stored procedure"))
                {
                    datos.cerrarConexion();
                    datos = new AccesoDatos();
                    datos.setearConsulta(@"
                        IF EXISTS (SELECT 1 FROM PACIENTES WHERE Dni = @Dni)
                        BEGIN
                            RAISERROR('Ya existe un paciente registrado con el DNI ingresado.', 16, 1);
                            RETURN;
                        END
                        INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
                        VALUES (@Nombre, @Apellido, @Dni, @FechaNacimiento, @Email, @Telefono, @Direccion, 1)");
                    datos.setearParametro("@Nombre", nuevo.Nombre);
                    datos.setearParametro("@Apellido", nuevo.Apellido);
                    datos.setearParametro("@Dni", nuevo.Dni);
                    datos.setearParametro("@FechaNacimiento", nuevo.FechaNacimiento);
                    datos.setearParametro("@Email", nuevo.Email);
                    datos.setearParametro("@Telefono", string.IsNullOrEmpty(nuevo.Telefono) ? (object)DBNull.Value : nuevo.Telefono);
                    datos.setearParametro("@Direccion", string.IsNullOrEmpty(nuevo.Direccion) ? (object)DBNull.Value : nuevo.Direccion);
                    datos.ejecutarAccion();
                }
                else
                {
                    throw ex;
                }
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void modificar(Paciente mod)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarPaciente");
                datos.setearParametro("@Id", mod.Id);
                datos.setearParametro("@Nombre", mod.Nombre);
                datos.setearParametro("@Apellido", mod.Apellido);
                datos.setearParametro("@Dni", mod.Dni);
                datos.setearParametro("@FechaNacimiento", mod.FechaNacimiento);
                datos.setearParametro("@Email", mod.Email);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(mod.Telefono) ? (object)DBNull.Value : mod.Telefono);
                datos.setearParametro("@Direccion", string.IsNullOrEmpty(mod.Direccion) ? (object)DBNull.Value : mod.Direccion);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("storedModificarPaciente") || ex.Message.Contains("Could not find stored procedure"))
                {
                    datos.cerrarConexion();
                    datos = new AccesoDatos();
                    datos.setearConsulta(@"
                        IF EXISTS (SELECT 1 FROM PACIENTES WHERE Dni = @Dni AND Id <> @Id)
                        BEGIN
                            RAISERROR('El DNI ingresado ya pertenece a otro paciente.', 16, 1);
                            RETURN;
                        END
                        UPDATE PACIENTES
                        SET Nombre = @Nombre,
                            Apellido = @Apellido,
                            Dni = @Dni,
                            FechaNacimiento = @FechaNacimiento,
                            Email = @Email,
                            Telefono = @Telefono,
                            Direccion = @Direccion
                        WHERE Id = @Id");
                    datos.setearParametro("@Id", mod.Id);
                    datos.setearParametro("@Nombre", mod.Nombre);
                    datos.setearParametro("@Apellido", mod.Apellido);
                    datos.setearParametro("@Dni", mod.Dni);
                    datos.setearParametro("@FechaNacimiento", mod.FechaNacimiento);
                    datos.setearParametro("@Email", mod.Email);
                    datos.setearParametro("@Telefono", string.IsNullOrEmpty(mod.Telefono) ? (object)DBNull.Value : mod.Telefono);
                    datos.setearParametro("@Direccion", string.IsNullOrEmpty(mod.Direccion) ? (object)DBNull.Value : mod.Direccion);
                    datos.ejecutarAccion();
                }
                else
                {
                    throw ex;
                }
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
                datos.setearProcedimiento("storedEliminarPaciente");
                datos.setearParametro("@Id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("storedEliminarPaciente") || ex.Message.Contains("Could not find stored procedure"))
                {
                    datos.cerrarConexion();
                    datos = new AccesoDatos();
                    datos.setearConsulta("UPDATE PACIENTES SET Activo = 0 WHERE Id = @Id");
                    datos.setearParametro("@Id", id);
                    datos.ejecutarAccion();
                }
                else
                {
                    throw ex;
                }
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        private Paciente mapearPaciente(SqlDataReader lector)
        {
            Paciente aux = new Paciente();
            aux.Id = (int)lector["Id"];
            aux.Dni = (string)lector["Dni"];
            aux.Nombre = (string)lector["Nombre"];
            aux.Apellido = (string)lector["Apellido"];
            aux.FechaNacimiento = (DateTime)lector["FechaNacimiento"];

            if (!(lector["Email"] is DBNull))
                aux.Email = (string)lector["Email"];

            if (!(lector["Telefono"] is DBNull))
                aux.Telefono = (string)lector["Telefono"];

            if (!(lector["Direccion"] is DBNull))
                aux.Direccion = (string)lector["Direccion"];

            aux.Activo = (bool)lector["Activo"];

            return aux;
        }
    }
}
