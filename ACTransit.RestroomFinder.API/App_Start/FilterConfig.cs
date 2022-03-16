using System.Web;
using System.Web.Mvc;
using ACTransit.RestroomFinder.API.Infrastructure;

namespace ACTransit.RestroomFinder.API
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
