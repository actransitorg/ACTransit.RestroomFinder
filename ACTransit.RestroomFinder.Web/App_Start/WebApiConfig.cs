using System.Net.Http.Formatting;
using System.Web.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Web.Http.Cors;
using System.Web.Http.Tracing;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Infrastructure.Serialization;

namespace ACTransit.RestroomFinder.Web
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
#if DEBUG
            var traceWriter = config.EnableSystemDiagnosticsTracing();
            traceWriter.IsVerbose = true;
            traceWriter.MinimumLevel = TraceLevel.Debug;
#endif

            // enable Cross Origin Resource Sharing (CORS) 
            var cors = new EnableCorsAttribute("*", "*", "*") 
            {
                SupportsCredentials = true
            };
            config.EnableCors(cors);


            var json = GlobalConfiguration.Configuration.Formatters.JsonFormatter;
            //json.UseDataContractJsonSerializer = true;
            json.SerializerSettings = new JsonSerializerSettings()
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                NullValueHandling = NullValueHandling.Ignore,
            };

            // JSON only
            //config.Services.Replace(typeof(IContentNegotiator), new JsonContentNegotiator(json)); // don't use, not currently working
            config.Formatters.Remove(config.Formatters.JsonFormatter);
            config.Formatters.Add(new JsonFormatter());

            // Configure Web API to use only bearer token authentication.
            //config.SuppressDefaultHostAuthentication();
            //config.Filters.Add(new HostAuthenticationFilter(OAuthDefaults.AuthenticationType));

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            config.Filters.Add(new ActionExceptionFilter());

            config.EnableSystemDiagnosticsTracing();
        }
    }
}