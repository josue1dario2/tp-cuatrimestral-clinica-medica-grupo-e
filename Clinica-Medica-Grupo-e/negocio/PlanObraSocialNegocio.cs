using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;
namespace negocio
{
    internal class PlanObraSocialNegocio
    {
        public List<PlanObraSocial> ListarSP(string texto, int? idObraSocial, bool? activo)
        {
            List<PlanObraSocial> lista = new List<PlanObraSocial>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredListarPlanesObraSocial");

                datos.setearParametro("@Texto", string.IsNullOrWhiteSpace(texto) ? (object)DBNull.Value : texto.Trim());

                datos.setearParametro("@IdObraSocial", idObraSocial.HasValue ? (object)idObraSocial.Value : DBNull.Value);

                datos.setearParametro("@Activo", activo.HasValue ? (object)activo.Value : DBNull.Value);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PlanObraSocial aux = new PlanObraSocial();

                    aux.IdPlan = (int)datos.Lector["IdPlan"];
                    aux.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    aux.NombrePlan = datos.Lector["NombrePlan"].ToString();
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.NombreObraSocial = datos.Lector["NombreObraSocial"].ToString();

                    aux.Sigla = datos.Lector["Sigla"] == DBNull.Value ? null : datos.Lector["Sigla"].ToString();

                    lista.Add(aux);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public PlanObraSocial BuscarPorIDSP(int id)
        {
            PlanObraSocial plan = null;
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredBuscarPlanPorID");
                datos.setearParametro("@IdPlan", id);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    plan = new PlanObraSocial();

                    plan.IdPlan = (int)datos.Lector["IdPlan"];
                    plan.IdObraSocial = (int)datos.Lector["IdObraSocial"];
                    plan.NombrePlan = datos.Lector["NombrePlan"].ToString();
                    plan.Activo = (bool)datos.Lector["Activo"];

                    plan.NombreObraSocial = datos.Lector["NombreObraSocial"].ToString();

                    plan.Sigla = datos.Lector["Sigla"] == DBNull.Value ? null : datos.Lector["Sigla"].ToString();
                }

                return plan;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void RegistrarSP(PlanObraSocial nuevo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredRegistrarPlanObraSocial");

                datos.setearParametro("@IdObraSocial", nuevo.IdObraSocial);
                datos.setearParametro("@NombrePlan", nuevo.NombrePlan);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void ModificarSP(PlanObraSocial modificado)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("StoredModificarPlanObraSocial");

                datos.setearParametro("@IdPlan", modificado.IdPlan);
                datos.setearParametro("@IdObraSocial", modificado.IdObraSocial);
                datos.setearParametro("@NombrePlan", modificado.NombrePlan);

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
                datos.setearProcedimiento("StoredModificarEstadoPlanObraSocial");

                datos.setearParametro("@IdPlan", id);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



    }
}
