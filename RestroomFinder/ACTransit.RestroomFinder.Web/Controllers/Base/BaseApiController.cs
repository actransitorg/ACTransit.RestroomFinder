using System;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using ACTransit.Framework.Web.Attributes;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web.Controllers.Base
{
    [CustomError]
    public abstract class BaseApiController<TService> : ApiController where TService : IDomainService, new()
    {
        private Log<BaseApiController<TService>> log;

        protected TService service;
        protected RequestContext requestContext;

        protected BaseApiController() { }

        private void SetContext(RequestContext ctx = null)
        {
            if (ctx != null)
                requestContext = ctx;
            if (requestContext == null)
                requestContext = new RequestContext
                {
                    RequestUri = Request.RequestUri,
                    ResponseUri = Request.RequestUri,
                    CurrentUserName = RequestHelper.CurrentUserName
                };
            if (requestContext.CurrentUserName == null)
                requestContext.CurrentUserName = RequestHelper.CurrentUserName;
            service = new TService();
            service.SetContext(requestContext);
        }

        protected void SetSerializationResolver(Type serializationResolver)
        {
            if (requestContext == null)
                SetContext();
            if (requestContext == null)
                throw new Exception("RequestContext is null");
            requestContext.SerializationResolver = serializationResolver;
            service.SetContext(requestContext);
            HttpContext.Current.Items["RequestContext"] = requestContext;
        }
        public void Setup(RequestContext requestContext = null)
        {
            SetContext(requestContext);
            RequestInitialize();
        }

        protected override void Initialize(HttpControllerContext controllerContext)
        {
            base.Initialize(controllerContext);
            Setup();
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
            if (service != null)
            {
                service = default(TService);
            }
        }

        protected virtual void RequestInitialize() { }
    }
}