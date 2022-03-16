using System;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class WebApiRequestFilter : ActionFilterAttribute
    {
        private readonly Log<WebApiRequestFilter> log = new Log<WebApiRequestFilter>();

        public WebApiRequestFilter()
        {
            log.Debug("WebApiRequestFilter Created.");
        }

        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            log.Debug("OnActionExecuting Entering.");
            try
            {
                RequestHelper.SetLogContextName(actionContext.ActionDescriptor);
                log.Info("Executing");
                base.OnActionExecuting(actionContext);
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("OnActionExecuting Done.");
            }
        }

        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            log.Debug("OnActionExecuted Entering.");
            try
            {
                base.OnActionExecuted(actionExecutedContext);
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("OnActionExecuted Done.");
            }
        }
    }
}