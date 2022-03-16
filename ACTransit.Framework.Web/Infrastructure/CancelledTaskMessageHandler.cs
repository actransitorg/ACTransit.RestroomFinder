//https://stackoverflow.com/questions/22157596/asp-net-web-api-operationcanceledexception-when-browser-cancels-the-request
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;

namespace ACTransit.Framework.Web.Infrastructure
{
    /// <summary>
    /// Work around for ASP.NET Web API OperationCanceledException when browser cancels the request
    /// </summary>
    public class CancelledTaskMessageHandler : DelegatingHandler
    {
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            HttpResponseMessage response = await base.SendAsync(request, cancellationToken);

            // Try to suppress response content when the cancellation token has fired; ASP.NET will log to the Application event log if there's content in this case.
            if (cancellationToken.IsCancellationRequested)
            {
                return new HttpResponseMessage(HttpStatusCode.InternalServerError);
            }

            return response;
        }
        public static void Initial(HttpConfiguration config)
        {
            config.MessageHandlers.Add(new CancelledTaskMessageHandler());
        }
    }  
}
