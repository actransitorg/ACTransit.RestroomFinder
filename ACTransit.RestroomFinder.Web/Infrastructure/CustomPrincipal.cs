using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Helpers;
using System.Web.Security;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.Domain.Dto;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class CustomPrincipal : ClaimsPrincipal
    {
        private readonly Log<MvcApplication> log = new Log<MvcApplication>();

        public struct ClaimType
        {
            public static string Tokens = "Token";
            public static string Role = "Role";
        }
        public CustomPrincipal(IIdentity identity) : base(identity) { }
        
        public CustomPrincipal(FormsAuthenticationTicket ticket) : base(new GenericIdentity(ticket.Name))
        {
            var user = Json.Decode<User>(ticket.UserData);
            User = user;
            if (user == null || string.IsNullOrEmpty(user.Badge) || string.IsNullOrEmpty(user.Name))
            {
                log.Debug("CustomPrincipal, ticket is " + JsonConvert.SerializeObject(ticket));
                log.Debug("CustomPrincipal, User  is " + JsonConvert.SerializeObject(user));

                throw new UnauthorizedAccessException();
            }
        }

        public new GenericIdentity Identity => (GenericIdentity)base.Identity;
        
        public User User { get; set; }

    }
}