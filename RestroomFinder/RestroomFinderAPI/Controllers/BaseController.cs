using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using log4net;

namespace RestroomFinderAPI.Controllers
{
    [EnableCors("*", "*", "*")]
    public class BaseController : ApiController
    {
        private readonly ILog _logger;

        public BaseController()
        {
            _logger = LogManager.GetLogger(GetType());
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
