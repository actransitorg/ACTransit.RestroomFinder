using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using log4net;

namespace RestroomFinderAPI.Infrastructure
{
    public class CustomErrorAttribute : ExceptionFilterAttribute
    {
        private readonly ILog _logger;

        public CustomErrorAttribute()
        {
            _logger = LogManager.GetLogger(GetType());
        }

        public override void OnException(HttpActionExecutedContext context)
        {
            var actionName = context.ActionContext.ActionDescriptor.ActionName;
            var controllerName = context.ActionContext.ActionDescriptor.ControllerDescriptor.ControllerName;

            var currentException = context.Exception;
            if (currentException==null) return;

            string message = context.Request.RequestUri == null
                           ? ""
                           : context.Request.RequestUri.OriginalString + "\r\n";
            message += currentException.Message;
            _logger.Error(message, currentException);
            
            bool isAjaxCall = context.Request.Headers.Any(m=>m.Key== "X-Requested-With" && m.Value.Contains("XMLHttpRequest"));
            if(!isAjaxCall &&
                !(currentException is FriendlyException) &&
                new HttpException(null, currentException).GetHttpCode() != 500)
            {                
                return;
            }
            if (currentException is FriendlyException)
            {
                context.Response = new HttpResponseMessage(((FriendlyException)currentException).Code);
            }
        }


    }
}