using System.Web.Mvc;
using ACTransit.Framework.Web.Exceptions;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class TokenAuthorizationAttribute : AuthorizeAttribute
    {
        public string Token { get; set; }

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