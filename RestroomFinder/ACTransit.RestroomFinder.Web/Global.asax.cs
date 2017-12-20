using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

using System.Data.Entity.SqlServer;
using ACTransit.Framework.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web
{
    public class MvcApplication : HttpApplication
    {
        private readonly WebLogger _log;

        public MvcApplication()
        {
            //HACK: Due to IIS Shutdown/Start event timings, Log4Net config file needs to be loaded during the applicatin's constructor, otherwise no log file may be generated.            
            log4net.Config.XmlConfigurator.Configure(new FileInfo("Log4net.config"));
            _log = new WebLogger(GetType());
        }
        protected void Application_Start()
        {
            GlobalConfiguration.Configuration.IncludeErrorDetailPolicy = IncludeErrorDetailPolicy.Always;
            GlobalConfiguration.Configuration.Filters.Add(new WebApiRequestFilter());
            GlobalConfiguration.Configure(WebApiConfig.Register);
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            RouteConfig.RegisterRoutes(RouteTable.Routes);

            //Enables use of spatial data types
            SqlServerTypes.Utilities.LoadNativeAssemblies(Server.MapPath("~/bin"));
            SqlProviderServices.SqlServerTypesAssemblyName =
                "Microsoft.SqlServer.Types, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91";

        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var exception = Server.GetLastError();
            if (exception == null) return;
            _log.Fatal(exception.Message, exception);

            //Send an email if the error is anything other than Not Found.
            var httpException = exception as HttpException;
            if (httpException != null && httpException.GetHttpCode() == (int)HttpStatusCode.NotFound)
                return;

            WebMailer.EmailError(exception);
        }

        private static readonly int[] ignoreStatusCodes = {200, 304, 401};

        public void Application_BeginRequest(object sender, EventArgs e)
        {
            //var httpOrigin = Request.Params["HTTP_ORIGIN"] ?? HttpContext.Current.Request.Url.Host;
            //HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*");
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS");
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, X-Token");
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Credentials", "true");

            if (Request.HttpMethod != "OPTIONS") return;

            _log.Debug($"HTTP Method: {Request.HttpMethod}");
            HttpContext.Current.Response.StatusCode = 200;
            var httpApplication = sender as HttpApplication;
            httpApplication?.CompleteRequest();
        }    

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            if (ignoreStatusCodes.Contains(Context.Response.StatusCode)) return;
            _log.Debug("EndRequest: " + Context.Response.Status);
        }
    }
}
