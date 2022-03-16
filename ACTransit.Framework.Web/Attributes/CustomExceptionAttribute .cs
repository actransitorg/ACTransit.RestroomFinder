using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Script.Serialization;

using log4net;

using ACTransit.Framework.Exceptions;
using ACTransit.Framework.Web.Infrastructure;

namespace ACTransit.Framework.Web.Attributes
{
    /// <inheritdoc />
    /// <summary>
    /// Exception filter for ASP.Net WebAPI
    /// </summary>
    public class CustomExceptionAttribute: ExceptionFilterAttribute 
    {
        private readonly ILog _logger;
        private readonly int[] _errorCodeFriendlyExceptionEmailExcepts;

        public CustomExceptionAttribute()
        {
            _logger = LogManager.GetLogger(GetType());
            _errorCodeFriendlyExceptionEmailExcepts = new int[0];
        }
        public CustomExceptionAttribute(int[] errorCodeFriendlyExceptionEmailExcepts)
        {
            _logger = LogManager.GetLogger(GetType());
            _errorCodeFriendlyExceptionEmailExcepts = errorCodeFriendlyExceptionEmailExcepts;
        }


        public override void OnException(HttpActionExecutedContext filterContext)
        {
            if (filterContext.Exception == null)
                return;

            var currentException = filterContext.Exception;
            IEnumerable<string> headerValues;
            var isAjaxCall = false;
            if (filterContext.Request.Headers.TryGetValues("X-Requested-With", out headerValues))
                isAjaxCall = headerValues.FirstOrDefault() == "XMLHttpRequest";

            // HTTPErrorCode doesn't matter when it is ajax call, we should handle it here.
            if (!isAjaxCall &&
                !(currentException is FriendlyException) &&
                new HttpException(null, currentException).GetHttpCode() != 500)
            {
                return;
            }
            var m = "There was an error processing your request. Please try again in a few moments.";
            var exception = currentException as FriendlyException;

            if (exception==null || _errorCodeFriendlyExceptionEmailExcepts==null || _errorCodeFriendlyExceptionEmailExcepts.All(m1 => m1 != exception.ErrorCode))
                WebMailer.EmailError(currentException);


            if (exception != null)
                m = exception.Message;               

            // log the error using log4net.
            _logger.Error(FormatError(filterContext), currentException);

            filterContext.Response = filterContext.Request.CreateResponse(HttpStatusCode.InternalServerError, new
            {
                error = true,
                message = m, //currentException.Message,
                urlReferrer = filterContext.Request.RequestUri,
                redirect = !string.IsNullOrWhiteSpace(exception?.RedirectUrl),
                redirectUrl = exception?.RedirectUrl,

            });

        }

        //Handles any task cancelled exception thrown from Web API
        public override Task OnExceptionAsync(HttpActionExecutedContext context, CancellationToken cancellationToken)
        {
            //Exception handling will happen synchronously
            var exceptionHandler = !cancellationToken.IsCancellationRequested
                ? base.OnExceptionAsync(context, cancellationToken)
                : Task.Run(() => _logger.Warn(FormatError(context, true)), CancellationToken.None);

            return exceptionHandler;
        }

        private string FormatError(HttpActionExecutedContext filterContext, bool showAppDetails = false)
        {
            var currentException = filterContext.Exception;
            var message = new StringBuilder();

            if (showAppDetails)
            {
                var thisContext = (HttpContextBase)filterContext.Request?.Properties["MS_HttpContext"];

                if (thisContext != null)
                {
                    message.AppendLine("");
                    message.AppendLine("Application Details:");
                    message.AppendLine($"Host: {thisContext.Request.Url?.Host}");
                    message.AppendLine($"URL: {thisContext.Request.Url?.OriginalString}");
                    message.AppendLine($"URL Referrer: {thisContext.Request.UrlReferrer?.OriginalString}");
                    message.AppendLine($"Browser: {thisContext.Request.Browser?.Browser}");
                    message.AppendLine($"User: {thisContext.User?.Identity.Name}");
                    message.AppendLine($"Date: {DateTime.Now}");
                    message.AppendLine("");
                    message.AppendLine("Request Body:");
                    message.AppendLine(GetRequestBody(filterContext));
                    message.AppendLine("");
                }
            }
            else
            {
                message.AppendLine(filterContext.Request?.RequestUri.ToString());
            }

            using (var headers = filterContext.Request?.Headers.GetEnumerator())
            {
                if (headers != null)
                {
                    while (headers.MoveNext())
                    {
                        message.Append(headers.Current.Key).Append(":").AppendLine(headers.Current.Value?.ToString());
                    }
                }
            }

            message.AppendLine(currentException.Message);
            message.AppendLine("content if any and less than 1K:");

            try
            {
                if (filterContext.Request?.Content?.Headers?.ContentLength < 1024)
                {
                    if (filterContext.ActionContext?.ActionArguments?.Count > 0)
                    {
                        foreach (var arg in filterContext.ActionContext?.ActionArguments)
                        {
                            message.Append(arg.Key).Append(":").AppendLine(new JavaScriptSerializer().Serialize(arg.Value));
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                message.Append("Error trying to serialize the content, ").AppendLine(ex.Message);
            }

            return message.ToString();
        }

        private string GetRequestBody(HttpActionExecutedContext filterContext)
        {
            string body;
            using (var stream = filterContext.Request.Content.ReadAsStreamAsync().Result)
            {
                if (stream.CanSeek)
                    stream.Position = 0;
                body = filterContext.Request.Content.ReadAsStringAsync().Result;
            }
            return body;
        }
    }
}
