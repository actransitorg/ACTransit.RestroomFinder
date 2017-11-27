using System;
using System.Collections.Generic;
using System.Linq;

using ACTransit.DataAccess.ActiveDirectory.Repositories;
using ACTransit.Entities.ActiveDirectory;
using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.Domain.AccessControl;

namespace ACTransit.RestroomFinder.Domain.ActiveDirectory
{
    public class ActiveDirectoryService : BaseService
    {
        private const string ClassName = "ACTransit.Entities.ActiveDirectory.ActiveDirectoryService";

        protected ActiveDirectoryRepository Repository { get; private set; }

        public ActiveDirectoryService(string activeDirectlryUrl, string username, string password)
        {
            Repository = new ActiveDirectoryRepository(activeDirectlryUrl, username, password);
        }

        public IEnumerable<User> GetUsersInGroup(string group, bool recursive = false)
        {
            var cacheKey = string.Format("{0}_UserInGroup{1}_Recursive_{2}", ClassName, group);

            var users = Common.Cache.GetCache(cacheKey) as IEnumerable<User>;

            if (users == null || !users.Any())
            {
                users = Repository.GetUsersInGroup(group, recursive);
                Common.Cache.AddCache(cacheKey, users, (int)DateTime.Now.TimeUntil(DateTime.Now.EndOfDay()).TotalMinutes);
            }

            return users;
        }

        public IEnumerable<Group> GetGroupOfUser(string user, bool recursive = false)
        {
            return Repository.GetGroupsOfUser(user, recursive);
        }

        protected override void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                Repository.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}