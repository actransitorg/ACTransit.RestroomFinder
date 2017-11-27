using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using ACTransit.Framework.Logging;

namespace RestroomFinderAPI
{
    public class WebApiApplication : System.Web.HttpApplication
    {

        private readonly Logger _logger;
        public WebApiApplication()
        {
            //HACK: Due to IIS Shutdown/Start event timings, Log4Net config file needs to be loaded during the applicatin's constructor, otherwise no log file may be generated.
            log4net.Config.XmlConfigurator.Configure(new FileInfo("Log4net.config"));
            _logger = new Logger(this.GetType());
            _logger.WriteDebug("Started...");

        }
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}
