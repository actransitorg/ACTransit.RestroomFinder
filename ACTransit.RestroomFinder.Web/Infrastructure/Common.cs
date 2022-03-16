using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.Configuration;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class Common
    {
        private const string AuthenticationSectionKey = "system.web/authentication";

        public static string CurrentUser
        {
            get
            {
                var user = HttpContext.Current.User.Identity.Name;

                if (string.IsNullOrWhiteSpace(user))
                    return string.Empty;

                if (user.Contains('\\'))
                    user = user.Split('\\')[1];
                if (user.Contains("@"))
                    user = user.Split('@')[0];

                return user;
            }
        }

        public static string Badge => HttpContext.Current.User.GetType() == typeof(CustomPrincipal)
            ? ((CustomPrincipal)HttpContext.Current.User).User.Badge
            : null;

        public static bool IsAutologin => ConfigurationManager.AppSettings["Forms.Demo.Autologin"]
            .Equals(bool.TrueString, StringComparison.CurrentCultureIgnoreCase);

        public static IEnumerable<FormsAuthenticationUser> FormsCredentials
        {
            get
            {
                var userCount = ((AuthenticationSection) ConfigurationManager.GetSection(AuthenticationSectionKey))
                    ?.Forms?.Credentials?.Users.Count;

                if (userCount.HasValue && userCount.Value > 0)
                {
                    for (var userIndex = 0; userIndex < userCount.Value; userIndex++)
                    {
                        yield return ((AuthenticationSection) ConfigurationManager.GetSection(AuthenticationSectionKey))
                            ?.Forms?.Credentials.Users[userIndex];
                    }
                }
            }
        }

    }
}