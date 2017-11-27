using System;
using System.Linq;
using System.Web;
using System.Web.Caching;

using ACTransit.RestroomFinder.Domain.AccessControl;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class TokenAuthorizationHelper
    {
        public const string TokenAdmin = "Admin";
        public const string TokenCreator = "Creator";
        public const string TokenEditor = "Editor";

        private static readonly AccessControlListService AclService;
        private static DateTime _absoluteExpirationDateTime;
        private static string _aclPath;

        static TokenAuthorizationHelper()
        {
            _aclPath = HttpContext.Current.Server.MapPath("~/ACL.xml");
            AclService = new AccessControlListService(_aclPath);
        }

        public static bool HasAccess(string token)
        {
            var user = Common.CurrentUser;

            var tokens = token.Contains(";")
                ? token.Split(';')
                : token.Split(',');

            return tokens.Any(individualToken => UserHasAccess(user, token));
        }

        private static bool UserHasAccess(string user, string token)
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
            return string.Format("ACTransit.RestroomFinder.Web_user_{0}_token_{1}", user, token);
        }

        private static bool? GetCacheAsBool(string key)
        {
            var result = Cache[key];
            if (result != null)
            {
                if (result is bool)
                    return (bool)result;
                bool temp;
                if (bool.TryParse(result.ToString(), out temp))
                    return new bool?(temp);
            }
            return new bool?();
        }

        private static void AddCache(string key, object value)
        {
            Cache.Add(key, value, new CacheDependency(_aclPath), GetAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Default, OnRemoveCallback);
        }

        private static void OnRemoveCallback(string key, object value, CacheItemRemovedReason reason)
        {
            if (reason == CacheItemRemovedReason.DependencyChanged)
                AclService.Refresh();
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