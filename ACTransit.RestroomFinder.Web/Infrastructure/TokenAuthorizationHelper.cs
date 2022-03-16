using System;
using System.Reflection;
using System.Linq;
using System.Web;
using System.Web.Caching;

using ACTransit.RestroomFinder.Domain.AccessControl;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class TokenAuthorizationHelper
    {
        public const string TokenAdmin = "Admin";
        public const string TokenRestroomCreator = "RestroomCreator";
        public const string TokenRestroomEditor = "RestroomEditor";
        public const string TokenFeedbackEditor = "FeedbackEditor";
        public const string TokenRestroomReportCreator = "RestroomReportCreator"; 
        public const string TokenApplicationAccessEditor = "ApplicationAccessEditor";
        public const string TokenContactCreator = "ContactCreator";
        public const string TokenContactEditor = "ContactEditor";

        private static readonly AclService AclService;
        private static DateTime _absoluteExpirationDateTime;
        private static string _aclPath;

        static TokenAuthorizationHelper()
        {
            _aclPath = HttpContext.Current.Server.MapPath("~/ACL.xml");
            AclService = AclService.Create(_aclPath);
        }

        public static bool HasAccess(string token)
        {
            var user = Common.CurrentUser;

            var tokens = token.Contains(";")
                ? token.Split(';')
                : token.Split(',');

            return tokens.Any(individualToken => UserHasAccess(user, token));
        }

        public static bool UserHasAccess(string user, string token)
        {
            string key = CreateCacheKey(user, token);

            var cacheResult = GetCacheAsBool(key);

            if (cacheResult.HasValue)
                return cacheResult.Value;

            var result = AclService.HasAccess(token, user);

            AddCache(key, result);

            return result;
        }

        private static string CreateCacheKey(string user, string token)
        {
            return $"ACTransit.RestroomFinder.Web_User_{user}_Token_{token}";
        }

        private static bool? GetCacheAsBool(string key)
        {
            var result = Cache[key];
            if (result != null)
            {
                if (result is bool)
                    return (bool)result;

                if (bool.TryParse(result.ToString(), out bool temp))
                    return new bool?(temp);
            }
            return new bool?();
        }

        private static void AddCache(string key, object value)
        {
            Cache.Add(key, value, null, GetAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Default, null);
        }

        private static DateTime GetAbsoluteExpiration
        {
            get
            {
                if (DateTime.Now > _absoluteExpirationDateTime)
                    _absoluteExpirationDateTime = DateTime.Now.AddMinutes(5);
                return _absoluteExpirationDateTime;
            }
        }

        private static Cache Cache
        {
            get
            {
                return HttpContext.Current.Cache;
            }
        }
    }
}