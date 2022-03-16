using ACTransit.Framework.Caching;

namespace ACTransit.RestroomFinder.Domain.ActiveDirectory
{
    public static class Common
    {
        private static ICache _cache;

        public static ICache Cache
        {
            get { return _cache ?? (_cache = new Cache("ACTransit.BusStop.Web.Business")); }
        }
    }
}