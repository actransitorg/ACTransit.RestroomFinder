using ACTransit.Framework.Web.Attributes;
using System.Web.Mvc;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new MvcRequestFilter());
            filters.Add(new CustomErrorAttribute());
            filters.Add(new HandleErrorAttribute());
        }
    }
}
