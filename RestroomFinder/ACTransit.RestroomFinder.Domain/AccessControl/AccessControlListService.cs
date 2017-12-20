using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using ACTransit.RestroomFinder.Domain.ActiveDirectory;

namespace ACTransit.RestroomFinder.Domain.AccessControl
{
    public class AccessControlListService : BaseService
    {
        private DateTime _lastExpired = DateTime.MinValue;
        private static XElement _root;
        private readonly string _path = "ACL.xml";

        private XElement Root
        {
            get { return _root ?? (_root = XElement.Load(_path)); }
        }

        public AccessControlListService() { }

        public AccessControlListService(string path)
        {
            _path = path;
        }

        public bool HasAccess(string token, string user)
        {
            var users = GetUserItems(token, user).ToList();
            if (users.Any())
            {
                if (users.Any(m => !m.HasAccess))
                    return false;
                return true;
            }

            var groups = GetGroups(token);

            if (string.IsNullOrEmpty(ActiveDirectorySettings.Url) || ActiveDirectorySettings.Url.Contains("URL"))
                return true;

            using (var service = new ActiveDirectoryService(ActiveDirectorySettings.Url, ActiveDirectorySettings.Username, ActiveDirectorySettings.Password))
            {
                var usergroups = service.GetGroupOfUser(user, true);

                if (usergroups != null)
                {
                    var groupsInCommon = groups
                        .Where(m => usergroups.Any(u => string.Equals(u.SamAccountName, m.Name,
                            StringComparison.OrdinalIgnoreCase))).ToArray();

                    if (groupsInCommon.Any())
                    {
                        if (groupsInCommon.Any(m => (!m.HasAccess &&
                                                     !m.Name.Equals("Admin",
                                                         StringComparison.InvariantCultureIgnoreCase))))
                            return false;
                        return true;
                    }
                }
            }

            return false;
        }

        private IEnumerable<Item> GetGroups(string token)
        {
            var tokens = Root.Elements("tokens");
            return tokens.Elements("token")
                    .Where(m => m.Attribute("name").Value == token)
                    .Elements("groups")
                    .Elements("group")
                    .Select(m => new Item
                    {
                        Name = m.Value,
                        HasAccess =
                            (m.Attribute("allow").Value == "1" ||
                             string.Equals(m.Attribute("allow").Value, "true", StringComparison.OrdinalIgnoreCase)),
                        Silence = m.Attribute("silence") != null && ((m.Attribute("silence").Value == "1" || string.Equals(m.Attribute("silence").Value, "true", StringComparison.OrdinalIgnoreCase))),

                    }).ToArray();
        }

        private IEnumerable<Item> GetUserItems(string token, string user)
        {
            var tokens = Root.Elements("tokens");
            return tokens.Elements("token")
                    .Where(m => m.Attribute("name").Value == token)
                    .Elements("users")
                    .Elements("user")
                    .Where(m => string.Equals(m.Value, user, StringComparison.OrdinalIgnoreCase))
                    .Select(m => new Item
                    {
                        Name = m.Value,
                        HasAccess = (m.Attribute("allow").Value == "1" || string.Equals(m.Attribute("allow").Value, "true", StringComparison.OrdinalIgnoreCase)),
                        Silence = m.Attribute("silence") != null && ((m.Attribute("silence").Value == "1" || string.Equals(m.Attribute("silence").Value, "true", StringComparison.OrdinalIgnoreCase))),
                    });
        }

        public void Refresh()
        {
            if ((DateTime.Now - _lastExpired).TotalSeconds > 5)
            {
                _root = null;
                _lastExpired = DateTime.Now;
            }
        }

        private class Item
        {
            public string Name { get; set; }
            public bool HasAccess { get; set; }
            public bool Silence { get; set; }
        }

        protected override void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {

            }

            base.Dispose(disposing);
        }
    }
}