using System;
using System.Web.Mvc;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class MvcRequestFilter : ActionFilterAttribute
    {
        private readonly Log<MvcRequestFilter> log = new Log<MvcRequestFilter>();

        public MvcRequestFilter()
        {
            log.Debug("MvcRequestFilter Created.");
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            log.Debug("OnActionExecuting Entering.");
            try
            {
                RequestHelper.SetLogContextName(filterContext.ActionDescriptor);
                log.Info("Executing");
                base.OnActionExecuting(filterContext);
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

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            log.Debug("OnActionExecuted Entering.");
            try
            {
                base.OnActionExecuted(filterContext);
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