using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class Common
    {
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
    }
}