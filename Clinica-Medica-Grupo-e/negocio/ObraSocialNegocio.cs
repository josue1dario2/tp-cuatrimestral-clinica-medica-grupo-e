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
    }
}

