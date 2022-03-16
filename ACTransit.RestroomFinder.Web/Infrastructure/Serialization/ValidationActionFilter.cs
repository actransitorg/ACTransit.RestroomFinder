using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace ACTransit.RestroomFinder.Web.Infrastructure.Serialization
{
    public class ValidationActionFilter : ActionFilterAttribute
    {
        private readonly Log<ValidationActionFilter> log = new Log<ValidationActionFilter>();

        public ValidationActionFilter()
        {
            log.Debug("ValidationActionFilter Created.");
        }

        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            log.Debug("OnActionExecuting Entering.");
            try
            {
                if (actionContext.ModelState.IsValid)
                {
                    log.Debug("ModelState OK");
                    return;
                }
                var request = actionContext.ActionArguments.Select(x => x.Value).FirstOrDefault();
                var response = new InvalidRequestRepresentation(actionContext.ModelState, request);
                log.Error("Invalid model: " + response);
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.BadRequest, response);
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
    }
}