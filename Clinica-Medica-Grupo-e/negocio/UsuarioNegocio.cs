using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using System.Threading.Tasks;
using dominio;
namespace negocio
{
    public class UsuarioNegocio
    {


        public List<Usuario> ListarUsuarios()
        {
            List<Usuario> Lista = new List<Usuario>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearProcedimiento("StoredListarUsuarios");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Usuario usuarios = new Usuario();

                    usuarios.Id = (int)datos.Lector["Id"];
                    usuarios.Email = (string)datos.Lector["Email"];

                    usuarios.TipoUsuario = (TipoUsuario)datos.Lector["TipoUsuario"];
                    usuarios.Activo = (bool)datos.Lector["Activo"];
                    usuarios.NombreUsuario = (string)datos.Lector["NombreUsuario"];

                    if (!(datos.Lector["UltimaConexion"] is DBNull))
                        usuarios.UltimaConexion = (DateTime)datos.Lector["UltimaConexion"];

                    if (!(datos.Lector["Nombre"] is DBNull))
                        usuarios.Nombre = (string)datos.Lector["Nombre"];

                    if (!(datos.Lector["Apellido"] is DBNull))
                        usuarios.Apellido = (string)datos.Lector["Apellido"];

                    Lista.Add(usuarios);
                }



            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }

            return Lista;
        }



        public Usuario BuscarPorID(int id)
        {
            List<Usuario> Lista = ListarUsuarios();

            return Lista.FirstOrDefault(m => m.Id == id);

        }

        public void RegistrarUsuario(Usuario nuevo, int? idMedico)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearProcedimiento("StoredRegistrarUsuario");

                datos.setearParametro("@Nombreusuario", nuevo.NombreUsuario);
                datos.setearParametro("@Email", nuevo.Email);
                datos.setearParametro("@Pass", nuevo.Pass);
                datos.setearParametro("@TipoUsuario", (int)nuevo.TipoUsuario);


                if (idMedico == null)
                {
                    datos.setearParametro("@IdMedico", DBNull.Value);
                }
                else { datos.setearParametro("@IdMedico", idMedico); }



                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }


        }

        public void ModificarUsuario(Usuario modificado)
        {
            AccesoDatos datos = new AccesoDatos();



            try
            {
                datos.setearProcedimiento("StoredModificarUsuario");
                datos.setearParametro("@pass", modificado.Pass);
                datos.setearParametro("@nombreUsuario", modificado.NombreUsuario);
                datos.setearParametro("@Email", modificado.Email);
                datos.setearParametro("@Id", modificado.Id);

                datos.ejecutarAccion();




            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }

        }

        public void modificarEstado(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {


                datos.setearProcedimiento("StoredModificarEstadoUsuario");
                datos.setearParametro("@Id", id);
                datos.ejecutarAccion();

            }
            catch (Exception)
            {

                throw;
            }
            finally { datos.cerrarConexion(); }

        }

        public void ActualizarUltimaConexion(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredActualizarUltimaConexion");
                datos.setearParametro("@Id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }
        }


    

        public List <Usuario> AplicarFiltros(string texto, int? rol, bool? activo)
        {
            List <Usuario> lista = new  List <Usuario>();
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearProcedimiento("FiltrarUsuarios");
                datos.setearParametro("@Texto", texto ?? "");
                datos.setearParametro("@Rol", rol == null ? (object)DBNull.Value : rol);
                datos.setearParametro("@Activo", activo == null ? (object)DBNull.Value : activo);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {

                    Usuario usuarios = new Usuario();

                    usuarios.Id = (int)datos.Lector["Id"];
                    usuarios.Email = (string)datos.Lector["Email"];

                    usuarios.TipoUsuario = (TipoUsuario)datos.Lector["TipoUsuario"];
                    usuarios.Activo = (bool)datos.Lector["Activo"];
                    usuarios.NombreUsuario = (string)datos.Lector["NombreUsuario"];

                    if (!(datos.Lector["UltimaConexion"] is DBNull))
                        usuarios.UltimaConexion = (DateTime)datos.Lector["UltimaConexion"];

                    if (!(datos.Lector["Nombre"] is DBNull))
                        usuarios.Nombre = (string)datos.Lector["Nombre"];

                    if (!(datos.Lector["Apellido"] is DBNull))
                        usuarios.Apellido = (string)datos.Lector["Apellido"];

                    lista.Add(usuarios);

                }

                return lista;






            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }


        }


        public Usuario StoredBuscarPorID(int id)
        {
            Usuario buscado = null;
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearProcedimiento("StoredBuscarPorID");
                datos.setearParametro("@IdABuscar", id);
                datos.ejecutarLectura();


                if (datos.Lector.Read())
                {
                    Usuario usuario = new Usuario();
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.NombreUsuario = (string)datos.Lector["Nombreusuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.TipoUsuario = (TipoUsuario)(int)datos.Lector["TipoUsuario"];
                    usuario.Activo = (bool)datos.Lector["Activo"];
                    usuario.Pass = (string)datos.Lector["Pass"];
                    usuario.Nombre = datos.Lector["Nombre"] == DBNull.Value
                        ? null : (string)datos.Lector["Nombre"];

                    usuario.Apellido = datos.Lector["Apellido"] == DBNull.Value
                        ? null : (string)datos.Lector["Apellido"];

                    usuario.UltimaConexion = datos.Lector["UltimaConexion"] == DBNull.Value
                    ? (DateTime?)null : (DateTime)datos.Lector["UltimaConexion"];

                    buscado = usuario;

                }



            }
            catch (Exception ex)
            {

                throw ex; 
            }
            finally { datos.cerrarConexion(); }




            return buscado;
        }

        public Usuario BuscarUsuarioPorNombreUsuario(string nombreUsuario)
        {

            AccesoDatos datos = new AccesoDatos();
            Usuario aBuscar = null;

            try
            {

                datos.setearProcedimiento("StoredBuscarUsuarioPorNombreUsuario");

                datos.setearParametro("@NombreUsuario", nombreUsuario);

                datos.ejecutarLectura();


                while (datos.Lector.Read())
                {
                    Usuario usuario = new Usuario();

                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Pass = (string)datos.Lector["Pass"];

                    usuario.TipoUsuario = (TipoUsuario)(int)datos.Lector["TipoUsuario"];
                    usuario.Activo = (bool)datos.Lector["Activo"];

                    if (datos.Lector["Nombre"] != DBNull.Value)
                        usuario.Nombre = (string)datos.Lector["Nombre"];

                    if (datos.Lector["Apellido"] != DBNull.Value)
                        usuario.Apellido = (string)datos.Lector["Apellido"];

                    if (datos.Lector["UltimaConexion"] != DBNull.Value)
                        usuario.UltimaConexion = (DateTime)datos.Lector["UltimaConexion"];

                    aBuscar = usuario;

                }


                return aBuscar;

            }
            catch (Exception)
            {
 
                throw;
            }
            finally { datos.cerrarConexion(); }



        }


        public Usuario Login(string NombreUsuario, string Pass)
        {
            if (string.IsNullOrWhiteSpace(NombreUsuario) || Pass == null)
                return null;

            Usuario usuario = BuscarUsuarioPorNombreUsuario(NombreUsuario);

            if (usuario == null)
                return null;

            if (!usuario.Activo)
                return null;

            if (usuario.Pass != Pass)
                return null;

            return usuario;
        }



    }
}
