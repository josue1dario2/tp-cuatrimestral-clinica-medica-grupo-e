using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class ObraSocialNegocio
    {
        public List<ObraSocial> listar()
        {
            List<ObraSocial> lista = new List<ObraSocial>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdObraSocial, Nombre, Sigla, Activo FROM ObrasSociales WHERE Activo = 1 ORDER BY CASE WHEN Sigla = 'PARTICULAR' THEN 0 ELSE 1 END, Nombre ASC;");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ObraSocial aux = new ObraSocial();
                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Sigla = datos.Lector["Sigla"] != DBNull.Value ? (string)datos.Lector["Sigla"] : string.Empty;
                    aux.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
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

        public ObraSocial buscarPorId(int idObraSocial)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdObraSocial, Nombre, Sigla, Activo FROM ObrasSociales WHERE IdObraSocial = @IdObraSocial;");
                datos.setearParametro("@IdObraSocial", idObraSocial);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    ObraSocial aux = new ObraSocial();
                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Sigla = datos.Lector["Sigla"] != DBNull.Value ? (string)datos.Lector["Sigla"] : string.Empty;
                    aux.Activo = (bool)datos.Lector["Activo"];
                    return aux;
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

        public List<PlanObraSocial> listarPlanesPorObraSocial(int idObraSocial)
        {
            List<PlanObraSocial> lista = new List<PlanObraSocial>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdPlan, IdObraSocial, NombrePlan, Activo FROM PlanesObraSocial WHERE IdObraSocial = @IdObraSocial AND Activo = 1 ORDER BY IdPlan ASC;");
                datos.setearParametro("@IdObraSocial", idObraSocial);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PlanObraSocial aux = new PlanObraSocial();
                    aux.IdPlan = (int)datos.Lector["IdPlan"];
                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.NombrePlan = (string)datos.Lector["NombrePlan"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
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

        public PlanObraSocial buscarPlanPorId(int idPlan)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdPlan, IdObraSocial, NombrePlan, Activo FROM PlanesObraSocial WHERE IdPlan = @IdPlan;");
                datos.setearParametro("@IdPlan", idPlan);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    PlanObraSocial aux = new PlanObraSocial();
                    aux.IdPlan = (int)datos.Lector["IdPlan"];
                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.NombrePlan = (string)datos.Lector["NombrePlan"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    return aux;
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

        public List<ObraSocial> ListarSP(string texto)
        {
            List<ObraSocial> lista = new List<ObraSocial>();
            AccesoDatos datos = new AccesoDatos();


            try
            {

                datos.setearProcedimiento("StoredListarObrasSociales");

                datos.setearParametro("@Texto", string.IsNullOrEmpty(texto) ? (object)DBNull.Value : texto.Trim());

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ObraSocial aux = new ObraSocial();

                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.Nombre = (string)datos.Lector["Nombre"].ToString();
                    aux.Sigla = datos.Lector["Sigla"] == DBNull.Value ? null : datos.Lector["Sigla"].ToString().Trim();
                    aux.Activo = (bool)datos.Lector["Activo"];
                    lista.Add(aux);

                }

                return lista;

            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally { datos.cerrarConexion(); }

        }


        public ObraSocial BuscarPorIDSP(int id)
        {
            ObraSocial obra = null;
            AccesoDatos datos = new AccesoDatos();


            try
            {
                datos.setearProcedimiento("StoredBuscarObrasocialPorID");
                datos.setearParametro("@IdObraSocial", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {

                    obra = new ObraSocial();
                    obra.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    obra.Nombre = datos.Lector["Nombre"].ToString();

                    obra.Sigla = datos.Lector["Sigla"] == DBNull.Value ? null : datos.Lector["Sigla"].ToString();

                    obra.Activo = (bool)datos.Lector["Activo"];


                }
                return obra;

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


        public void RegistrarSP(ObraSocial nueva)
        {

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredRegistrarObraSocial");

                datos.setearParametro("@Nombre", nueva.Nombre);

                datos.setearParametro("@Sigla", string.IsNullOrWhiteSpace(nueva.Sigla) ? (object)DBNull.Value : nueva.Sigla.Trim());

                datos.ejecutarAccion();





            }
            catch (Exception)
            {

                throw;
            }
            finally
            {
                datos.cerrarConexion();


            }

        }

        public void ModificarSP(ObraSocial modificada)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredModificarObraSocial");

                datos.setearParametro("@IdObraSocial", modificada.IdObraSocial);
                datos.setearParametro("@Nombre", modificada.Nombre);

                datos.setearParametro("@Sigla", string.IsNullOrWhiteSpace(modificada.Sigla) ? (object)DBNull.Value : modificada.Sigla.Trim());

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void ModificarEstadoSP(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredModificarEstadoObraSocial");
                datos.setearParametro("@IdObraSocial", id);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }


        }






    }
}

