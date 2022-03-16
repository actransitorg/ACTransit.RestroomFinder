using System;
using System.Web.Http.Controllers;
using System.Web.Http;
using ACTransit.Framework.Web.Exceptions;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Security;
using ACTransit.Framework.Imaging;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Models;
using ACTransit.RestroomFinder.API.Services;
using log4net;
using ACTransit.RestroomFinder.API.Handlers;

namespace ACTransit.RestroomFinder.API.Infrastructure.Api
{
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        //   public string Tokens { get; set; }
        public string[] Tokens { get; set; }
        public string Token { get; set; }

        private readonly ILog _logger;

        public CustomAuthorizeAttribute()
        {
            _logger = LogManager.GetLogger(GetType());
        }

        private string GetHeaderValue(HttpActionContext filterContext, string key)
        {
            string result = string.Empty;
            if (filterContext.Request.Headers.TryGetValues(key, out var res))
            {
                var sessions = res.ToArray();
                if (sessions.Any())
                    result = sessions[0];
            }
            if (string.IsNullOrEmpty(result))
            {
                var keyValues = filterContext.Request.GetQueryNameValuePairs().Where(m => m.Key == key).ToArray();
                if (keyValues.Any())
                    result = keyValues.First().Value;
            }

            return result;
        }


        public override void OnAuthorization(HttpActionContext filterContext)
        {
            if (SkipAuthorization(filterContext))
                return;

            
            const string key1 = "sessionId";
            const string key2 = "badge";
            const string key3 = "deviceGuid";
            bool hasAccess;
            string sessionId= GetHeaderValue(filterContext,key1);
            string badge = GetHeaderValue(filterContext, key2);
            string deviceGuid = GetHeaderValue(filterContext, key3);

            hasAccess = AsyncHelpers.RunSync(async () =>
            {
                using (var service = new OperatorHandler())
                {
                    var result=await service.IsValidSessionAsync(badge, deviceGuid,sessionId);
                    return result?.Item1??false;
                }                
            });


            

            //_logger.Debug("SessionId:" + sessionId);
            //if (!string.IsNullOrEmpty(sessionId))
            //{
            //    try
            //    {                    
            //        var ticket = FormsAuthentication.Decrypt(sessionId);
            //        if (ticket != null)
            //        {
            //            _logger.Debug("tikcet is not null! " + ticket.UserData);
            //            var userData = ticket.UserData;
            //            if (!string.IsNullOrWhiteSpace(userData))
            //            {
            //                _logger.Debug("User data object is created.");
            //                var user = JsonConvert.DeserializeObject<SecurityUserInfo>(userData);
            //                _logger.Debug("User data DeserializeObject successfull!");
            //                if (user != null)
            //                {
            //                    _logger.Debug("User data user is not null!");
            //                    using (var service = new OperatorHandler())
            //                    {
            //                        hasAccess = service.IsValidSession(user.Badge, ticket.Name,sessionId);
            //                        _logger.Debug("has Access:" + hasAccess);
            //                    }
            //                }
            //            }
            //        }

            //    }
            //    catch (Exception ex)
            //    {
            //        _logger.Error("Error on OnAuthorization", ex);

            //        throw new FriendlyException(FriendlyExceptionType.AccessDenied);
            //    }       
            //}


            //if (!string.IsNullOrEmpty(Token) || (Tokens != null && Tokens.Length > 0))
            //{
            //    if (Tokens == null || Tokens.Length == 0)
            //        hasAccess = AuthorizeHelper.HasAccess(Token);
            //    else
            //    {
            //        var arr = new List<string>();
            //        if (Tokens != null)
            //            arr.AddRange(Tokens);
            //        if (!string.IsNullOrEmpty(Token))
            //            arr.Add(Token);
            //        foreach (var token in arr)
            //        {
            //            hasAccess = AuthorizeHelper.HasAccess(token);
            //            if (hasAccess)
            //                break;
            //        }
            //    }
            //}

            //if (!string.IsNullOrEmpty(Tokens))
            //{
            //    string[] tokens;
            //    if (Tokens.Contains(';'))
            //        tokens = Tokens.Split(';');
            //    else
            //        tokens = Tokens.Split(',');
            //    foreach (var token in tokens)
            //    {
            //        hasAccess = AuthorizeHelper.HasAccess(token);
            //        if (hasAccess)
            //            break;
            //    }
            //}
            if (!hasAccess)
                throw new FriendlyException(FriendlyExceptionType.AccessDenied);


        }

        private bool SkipAuthorization(HttpActionContext filterContext, bool inherit = true)
        {
            return (filterContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>(inherit).Count > 0 ||
                    filterContext.ActionDescriptor.ControllerDescriptor.GetCustomAttributes<AllowAnonymousAttribute>(true).Count > 0);
        }
    }

}