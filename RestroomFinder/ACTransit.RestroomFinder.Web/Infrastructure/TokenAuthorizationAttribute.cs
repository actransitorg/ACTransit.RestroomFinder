using System.Web.Mvc;
using System.Collections.Generic;
using ACTransit.Framework.Web.Exceptions;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class TokenAuthorizationAttribute : AuthorizeAttribute
    {
        public string Token { get; set; }
        public string[] Tokens { get; set; }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (SkipAuthorization(filterContext))
                return;

            var hasAccess = false;

            if (!string.IsNullOrEmpty(Token))
            {
                hasAccess = TokenAuthorizationHelper.HasAccess(Token);

                if (hasAccess)
                    return;
            }
            else if (Tokens != null && Tokens.Length > 0)
            {
                foreach (var token in Tokens)
                {
                    hasAccess = TokenAuthorizationHelper.HasAccess(token);
                    break;
                }

                if (hasAccess)
                    return;
            }

            if (!hasAccess)
                throw new FriendlyException(FriendlyExceptionType.AccessDenied);
        }

        private bool SkipAuthorization(AuthorizationContext filterContext, bool inherit = true)
        {
            return (filterContext.ActionDescriptor.IsDefined(typeof(AllowAnonymousAttribute), inherit) ||
                    filterContext.ActionDescriptor.ControllerDescriptor.IsDefined(typeof(AllowAnonymousAttribute), true));
        }
    }
}