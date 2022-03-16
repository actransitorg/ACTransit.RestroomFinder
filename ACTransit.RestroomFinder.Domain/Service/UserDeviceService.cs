using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

using X.PagedList;

using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.DataAccess;
using ACTransit.Framework.DataAccess.Extensions;
using ACTransit.Framework.Extensions;

using ACTransit.RestroomFinder.Domain.Infrastructure;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class UserDeviceService: DomainServiceBase
    {
        public UserDeviceService() : base(string.Empty)
        {
        }

        public UserDeviceService(string username) : base(username)
        {
        }

        public async Task<IPagedList<Dto.User>> GetUsersAsync(UserSearchContext search = null)
        {
            var filter = new List<Expression<Func<V_User, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (!string.IsNullOrEmpty(search.Badge)) filter.Add(u => u.Badge.Contains(search.Badge.Trim()));
                if (search.Active.HasValue) filter.Add(u => u.UserActive == search.Active.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "Badge";
            }
            else
                search = new UserSearchContext { SortField = "Badge" };

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<V_User, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<V_User>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var users = await query
                .DynamicOrderBy(search.SortField, (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                .ToPagedListAsync(search.PageNumber, search.PageSize);

            return users.Select(Converter.ToModel);
        }

        public async Task<IPagedList<Dto.Device>> GetDevicesAsync(DeviceSearchContext search = null)
        {
            var filter = new List<Expression<Func<Device, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (!string.IsNullOrEmpty(search.DeviceGuid)) filter.Add(d => d.DeviceGuid.Contains(search.DeviceGuid.Trim()));
                if (!string.IsNullOrEmpty(search.Model)) filter.Add(d => d.DeviceModel.Contains(search.Model.Trim()));
                if (!string.IsNullOrEmpty(search.Os)) filter.Add(d => d.DeviceOS.Contains(search.Os.Trim()));
                if (search.Active.HasValue) filter.Add(d => d.Active == search.Active.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "LastUsed";
            }
            else
                search = new DeviceSearchContext { SortField = "LastUsed" };

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<Device, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<Device>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var devices = await query
                .DynamicOrderBy(search.SortField, (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                .ToPagedListAsync(search.PageNumber, search.PageSize);

            return devices.Select(Converter.ToModel);
        }

        public async Task<IPagedList<Dto.UserDevice>> GetUserDevicesPagedAsync(UserDeviceSearchContext search = null)
        {
            var filter = new List<Expression<Func<V_UserDevice, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (!string.IsNullOrEmpty(search.Badge)) filter.Add(ud => ud.Badge.Contains(search.Badge.Trim()));
                if (!string.IsNullOrEmpty(search.Model)) filter.Add(ud => ud.DeviceModel.Contains(search.Model.Trim()));
                if (!string.IsNullOrEmpty(search.Os)) filter.Add(ud => ud.DeviceOS.Contains(search.Os.Trim()));
                if (search.Active.HasValue) filter.Add(ud => ud.UserDeviceActive == search.Active.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "LastLogon";
            }
            else
                search = new UserDeviceSearchContext { SortField = "LastLogon" };

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<V_UserDevice, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<V_UserDevice>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var userDevices = await query
                .DynamicOrderBy(search.SortField, (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                .ToPagedListAsync(search.PageNumber, search.PageSize);

            return userDevices.Select(Converter.ToModel);
        }

        public async Task<IEnumerable<Dto.UserDevice>> GetUserDevicesAsync(UserDeviceSearchContext search = null)
        {
            var filter = new List<Expression<Func<V_UserDevice, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (!string.IsNullOrEmpty(search.Badge)) filter.Add(ud => ud.Badge.Contains(search.Badge.Trim()));
                if (!string.IsNullOrEmpty(search.Model)) filter.Add(ud => ud.DeviceModel.Contains(search.Model.Trim()));
                if (!string.IsNullOrEmpty(search.Os)) filter.Add(ud => ud.DeviceOS.Contains(search.Os.Trim()));
                if (search.Active.HasValue) filter.Add(ud => ud.UserDeviceActive == search.Active.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "LastLogon";
            }
            else
                search = new UserDeviceSearchContext { SortField = "LastLogon" };

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<V_UserDevice, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<V_UserDevice>();

            if (whereClause != null)
                query = query.Where(whereClause);

            return await query
                .DynamicOrderBy(search.SortField, (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                .Select(Converter.ToModel)
                .ToListAsync();
        }

        public Task<int> ActivateUser(int userId)
        {
            return UnitOfWork.ValidateRestroomUser(userId);
        }

        public Task<int> InActivateUser(int userId)
        {
            return UnitOfWork.ValidateRestroomUser(userId, false);
        }

        public Task<int> ActivateDevice(long deviceId)
        {
            return UnitOfWork.ValidateRestroomDevice(deviceId, true);
        }

        public Task<int> InActivateDevice(long deviceId)
        {
            return UnitOfWork.ValidateRestroomDevice(deviceId, false);
        }
        public Task<int> ActivateUserDevice(int userId, long deviceId)
        {
            return UnitOfWork.ValidateRestroomUserDevice(userId, deviceId, true);
        }
        public Task<int> InActivateUserDevice(int userId, long deviceId)
        {
            return UnitOfWork.ValidateRestroomUserDevice(userId, deviceId, false);
        }
    }
}
