using System.Web;
using System.Web.Mvc;
using RestroomFinderAPI.Infrastructure;

namespace RestroomFinderAPI
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
