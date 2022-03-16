using System;
using System.Web;
using System.Web.Http.Filters;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class ActionExceptionFilter: ExceptionFilterAttribute
    {
        private readonly Log<ActionExceptionFilter> log = new Log<ActionExceptionFilter>();
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            try
            {
                var e = actionExecutedContext.Exception;
                log.Error(e);
                base.OnException(actionExecutedContext);
            }
            catch (Exception e)
            {
                log.Error("ActionExceptionFilter.OnException Error", e);
            }
        }
    }
}