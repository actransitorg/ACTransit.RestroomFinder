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

        public User[] GetUsersInGroup(string group, bool recursive = false)
        {
            string key = ClassName + "_UserInGroup" + group + "_Recursive_" + recursive;
            var users = Common.Cache.GetCache(key) as User[] ?? Repository.GetUsersInGroup(group, recursive);
            if (users != null && users.Any())
                Common.Cache.AddCache(key, users, (int)DateTime.Now.TimeUntil(DateTime.Now.EndOfDay()).TotalMinutes);
            return users;
        }

        public Group[] GetGroupsOfUser(string user, bool recursive = false)
        {
            return Repository.GetGroupsOfUser(user, recursive).ToArray();
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