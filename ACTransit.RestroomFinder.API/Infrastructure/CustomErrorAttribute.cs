using System.Data.Entity.Validation;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Http.Results;
using log4net;

namespace ACTransit.RestroomFinder.API.Infrastructure
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
            if (currentException is FriendlyException)
                message += (currentException as FriendlyException).DebugString ?? "";

            _logger.Error(message, currentException);
            
            var entityException = currentException as DbEntityValidationException;
            if (entityException != null)
            {
                foreach (var eve in entityException.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                        _logger.Error($"- Property: {ve.PropertyName}, Error: {ve.ErrorMessage}");
                }

            }
            
            
            bool isAjaxCall = context.Request.Headers.Any(m=>m.Key== "X-Requested-With" && m.Value.Contains("XMLHttpRequest"));
            if(!isAjaxCall &&
                !(currentException is FriendlyException) &&
                new HttpException(null, currentException).GetHttpCode() != 500)
            {                
                return;
            }
            if (currentException is FriendlyException)
            {
                //throw currentException;
                var response= new HttpResponseMessage(((FriendlyException)currentException).Code);
                response.Content=new StringContent(((FriendlyException)currentException).Message);
                //response.ReasonPhrase = ((FriendlyException)currentException).Message;
                context.Response = response;
            }
        }


    }
}