using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Dispatcher;
using System.Web.Routing;
using Newtonsoft.Json.Serialization;
using ACTransit.RestroomFinder.API.Infrastructure;
using WebApiThrottle;
using TraceLevel = System.Web.Http.Tracing.TraceLevel;

namespace ACTransit.RestroomFinder.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            //config.AddApiVersioning(o => o.AssumeDefaultVersionWhenUnspecified = true);

            //GlobalConfiguration.Configuration.Services.Replace(typeof(IHttpControllerSelector), new VersionHttpControllerSelector(GlobalConfiguration.Configuration));
            // added to the web api configuration in the application setup
            config.MapHttpAttributeRoutes();

            // Configure Web API to use only bearer token authentication.
            //config.SuppressDefaultHostAuthentication();
            //config.Filters.Add(new HostAuthenticationFilter(OAuthDefaults.AuthenticationType));
            config.Filters.Add(new CustomErrorAttribute());
            

#if DEBUG
            var traceWriter = config.EnableSystemDiagnosticsTracing();
            traceWriter.IsVerbose = true;
            traceWriter.MinimumLevel = TraceLevel.Debug;
#endif

            // Web API routes
            //config.MapHttpAttributeRoutes();

            //var r=config.Routes.MapHttpRoute(
            //    name: "v2API",
            //    routeTemplate: "api/v{version}/{controller}/{id}",
            //    defaults: new
            //    {
            //        id = RouteParameter.Optional,
            //    }
            //);
            //r.Constraints.Add("version", "([0-9]{1,2})|([0-9]{1,2}.[0-9]{0,2})");            



            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional}
            );

            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();

            ////https://github.com/stefanprodan/WebApiThrottle
            //var throttlingHandler = new ThrottlingHandler()
            //{
            //    Policy = new ThrottlePolicy(perSecond: 20, perMinute: 300)//, perHour: 36000, perDay: 864000, perWeek: 6048000)
            //    {
            //        //scope to IPs
            //        IpThrottling = true,
            //        //IpRules = new Dictionary<string, RateLimits>
            //        //{
            //        //    {"::1/10", new RateLimits {PerSecond = 2}},
            //        //    {"192.168.2.1", new RateLimits {PerMinute = 30, PerHour = 30*60, PerDay = 30*60*24}}
            //        //},
            //        //white list the "::1" IP to disable throttling on localhost for Win8
            //        //IpWhitelist = new List<string> (Config.IpThrottlingWhiteList),

            //        //scope to clients (if IP throttling is applied then the scope becomes a combination of IP and client key)
            //        //ClientThrottling = true,
            //        //ClientRules = new Dictionary<string, RateLimits>
            //        //{
            //        //    {"api-client-key-1", new RateLimits {PerMinute = 60, PerHour = 600}},
            //        //    {"api-client-key-9", new RateLimits {PerDay = 5000}}
            //        //},
            //        //white list API keys that don’t require throttling
            //        //ClientWhitelist = new List<string> {"admin-key"},

            //        //scope to routes (IP + Client Key + Request URL)
            //        EndpointThrottling = true,
            //        EndpointRules = new Dictionary<string, RateLimits>
            //        {
            //            //per hour per client IP
            //            {"api/Feedback/", new RateLimits {PerHour = 20}},
            //            {"api/Restrooms/", new RateLimits {PerHour = 2000}},
            //            {"api/Operator/", new RateLimits {PerHour = 500}},
            //            {"api/v2/Feedback/", new RateLimits {PerHour = 20}}, // twenty feedbacks per hour per client IP
            //            {"api/v2/Restrooms/", new RateLimits {PerHour = 2000}}, // Restrooms per hour per client IP
            //            {"api/v2/Operator/", new RateLimits {PerHour = 2000}},
            //            {"api/v2/Authentication", new RateLimits {PerHour = 50}},
            //            {"api/v2/Authentication/send", new RateLimits {PerHour = 5}},
            //            {"api/Version/", new RateLimits {PerHour = 500}},
            //        }
            //    },
            //    Repository = new CacheRepository(),
            //};
#if DEBUG
            var throttlingHandler = new ThrottlingHandler();
            throttlingHandler.Logger = new TracingThrottleLogger(traceWriter);
#endif
            //config.MessageHandlers.Add(throttlingHandler);
            config.MessageHandlers.Add(new ThrottlingHandler()
            {
                Policy = ThrottlePolicy.FromStore(new PolicyConfigurationProvider()),
                Repository = new CacheRepository()
            });

        }
    }
}
