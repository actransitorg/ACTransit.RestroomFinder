using System;
using System.Data.Entity;
using System.IO;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Logging;
using System.Web.Security;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Infrastructure.Api;
using System.Web;

namespace ACTransit.RestroomFinder.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {

        private readonly Logger _logger;
        public WebApiApplication()
        {
            //HACK: Due to IIS Shutdown/Start event timings, Log4Net config file needs to be loaded during the applicatin's constructor, otherwise no log file may be generated.
            log4net.Config.XmlConfigurator.Configure(new FileInfo("Log4net.config"));
            _logger = new Logger(GetType());
            _logger.WriteDebug("Application Started...");

        }
        protected void Application_Start()
        {
            Database.SetInitializer<RestroomContext>(null);
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            SqlServerTypes.Utilities.LoadNativeAssemblies(Server.MapPath("~/bin"));
        }

        private string GetHeaderValue(HttpContext filterContext, string key)
        {
            var result = string.Empty;
            result = filterContext.Request.Headers.Get(key);
            if (string.IsNullOrEmpty(result))            
                result=Context.Request.QueryString.Get(key);            

            return result;
        }


        protected void Application_AuthenticateRequest(Object sender, EventArgs e)
        {

            const string key1 = "sessionId";
            const string key2 = "badge";
            const string key3 = "deviceGuid";
            //const string key3 = "firstName";
            //const string key4 = "lastName";


            try
            {
                string sessionId = GetHeaderValue(Context, key1);
                string badge = GetHeaderValue(Context, key2);
                string deviceGuid = GetHeaderValue(Context, key3);
                //string firstName = GetHeaderValue(Context, key3);
                //string lastName = GetHeaderValue(Context, key4);

                if (!string.IsNullOrEmpty(sessionId))
                    Context.User = new CustomPrincipal( badge,deviceGuid, sessionId);
            }
            catch (UnauthorizedAccessException)
            {
                Context.User = null;
            }
            catch (Exception ex)
            {
                _logger.WriteError(ex.Message);
                Context.User = null;
            }
        }
    }
}
