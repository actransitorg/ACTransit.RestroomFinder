using System;
using System.Linq;
using System.Security.Claims;
using System.Web.Http;
using System.Web.Http.Cors;
using log4net;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Infrastructure.Api;
using ACTransit.RestroomFinder.API.Services;

namespace ACTransit.RestroomFinder.API.Controllers
{
    [EnableCors("*", "*", "*")]
    //[CustomAuthorize]
    [CustomError]
    [Authorize]
    public class BaseController<T> : ApiController  where T: BaseHandler, new() 
    {
        private readonly ILog _logger;
        protected T Handler { get; set; }

        public BaseController()
        {
            _logger = LogManager.GetLogger(GetType());
            Handler = new T();
            var claimIdentity = User.Identity as ClaimsIdentity;
            var user= claimIdentity?.Claims?.Where(m => m.Type == "User").FirstOrDefault()?.Value;
            Handler.SetUser(user);
        }

        public ILog Log
        {
            get
            {
                return _logger;
            }
        }

        protected void Debug(string method, string message)
        {
            Log.Debug($"Method: {method}, {message}");
        }
        protected void Error(string method, string message)
        {
            Log.Error($"Method: {method}, {message}");
        }
        protected void Error(string method, string message, Exception ex)
        {
            Log.Error($"Method: {method}, {message}", ex);
        }


    }

}
