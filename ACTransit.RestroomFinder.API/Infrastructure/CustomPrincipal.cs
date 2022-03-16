using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using ACTransit.Framework.Imaging;
using ACTransit.Framework.Logging;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Infrastructure
{
    public class CustomPrincipal : ClaimsPrincipal
    {
        private static readonly Logger Logger = new Logger("CustomPrincipal");
              
        public CustomPrincipal(IIdentity identity) : base(identity) { }
        //public CustomPrincipal(string firstName, string lastName, string badge, string cardNumber, string sessionId) : base(new GenericIdentity(badge))
        //{
        //    Logger.WriteDebug("SessionId:" + sessionId);
        //    var hasAccess = false;
        //    var key = $"{firstName}_{lastName}_{badge}_{cardNumber}_{sessionId}";
        //    if (Cache.Get(key) is bool cacheFound)
        //        hasAccess = cacheFound;
        //    else 
        //    {
        //        hasAccess = AsyncHelpers.RunSync(async () =>
        //        {
        //            using (var service = new OperatorHandler())
        //            {
        //                return await service.IsValidSessionAsync(firstName, lastName, badge, sessionId);
        //            }
        //        });
        //        Cache.Add(key, hasAccess, null, DateTime.Now.AddMinutes(5), Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
        //    }




        //    if (!hasAccess)
        //        throw new UnauthorizedAccessException();

        //}
        public CustomPrincipal(string badge,string deviceGuid, string sessionId) : base(new GenericIdentity(badge))
        {
            Logger.WriteDebug( $"Badge: {badge}, SessionId: {sessionId}, deviceGuid: {deviceGuid}");
            var hasAccess = false;
            var jobTitle = "";
            var user = "";
            var key = $"{badge}_{sessionId}";
            if (Cache.Get(key) is Tuple<bool, string, string> cacheFound)
            {
                hasAccess = cacheFound.Item1;
                jobTitle = cacheFound.Item2;
                user = cacheFound.Item3;

            }
            else
            {
                hasAccess = AsyncHelpers.RunSync(async () =>
                {
                    using (var service = new OperatorHandler())
                    {
                        var result=await service.IsValidSessionAsync(badge, deviceGuid, sessionId);
                        jobTitle = result.Item2;
                        user = result.Item3;
                        return result.Item1;
                    }
                });
                Cache.Add(key,new Tuple<bool,string, string>(hasAccess,jobTitle,user), null, DateTime.Now.AddMinutes(5), Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }


            if (!hasAccess)
                throw new UnauthorizedAccessException();

            
            var claims = new List<Claim>();
            Identity.AddClaim(new Claim("JobTitle", jobTitle));
            Identity.AddClaim(new Claim("User", user));

        }

        public new GenericIdentity Identity => (GenericIdentity)base.Identity;

        private static Cache _cache;

        public Cache Cache => _cache ?? (_cache = new Cache());
        //public Cache Cache
        //{

        //}
        //public static CustomPrincipal Current => HttpContext.Current.User as CustomPrincipal;
    }
}