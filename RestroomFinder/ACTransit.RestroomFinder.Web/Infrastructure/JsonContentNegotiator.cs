//using System;
//using System.Collections.Generic;
//using System.Net.Http;
//using System.Net.Http.Formatting;
//using System.Net.Http.Headers;
//using System.Web;
//using ACTransit.RestroomFinder.Domain.Infrastructure;

//namespace ACTransit.RestroomFinder.Web.Infrastructure
//{
//    public class JsonContentNegotiator : IContentNegotiator
//    {
//        private readonly JsonMediaTypeFormatter jsonFormatter;
//        private readonly Log<JsonContentNegotiator> log = new Log<JsonContentNegotiator>(HttpContext.Current.Items["LogContextName"]?.ToString());

//        public JsonContentNegotiator(JsonMediaTypeFormatter formatter)
//        {
//            log.Debug("JsonContentNegotiator Created.");
//            jsonFormatter = formatter;
//        }

//        public ContentNegotiationResult Negotiate(Type type, HttpRequestMessage request, IEnumerable<MediaTypeFormatter> formatters)
//        {
//            log.Debug("JsonContentNegotiator.Negotiate Entering.");
//            ContentNegotiationResult result = null;
//            try
//            {
//                result = new ContentNegotiationResult(jsonFormatter, new MediaTypeHeaderValue("application/json"));
//            }
//            catch (Exception e)
//            {
//                log.Error(e);
//            }
//            finally
//            {
//                log.Debug("JsonContentNegotiator.Negotiate Done.");
//            }
//            return result;
//        }
//    }
//}