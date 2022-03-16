using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using ACTransit.Framework.DataAccess;
using ACTransit.Framework.DataAccess.Extensions;
using ACTransit.Framework.Interfaces;
using EntityFramework.Extensions;

namespace ACTransit.DataAccess.RestroomFinder
{
    public class RestroomUnitOfWork : UnitOfWorkBase<RestroomContext>
    {
        public RestroomUnitOfWork() : this(new RestroomContext(), null) { }

        public RestroomUnitOfWork(RestroomContext context) : this(context, null) { }

        public RestroomUnitOfWork(string currentUserName) : this(new RestroomContext(), currentUserName) { }

        public RestroomUnitOfWork(RestroomContext context, string currentUserName) : base(context)
        {
            CurrentUserName = currentUserName;
            context.Configuration.ProxyCreationEnabled = false;
        }

        public void EnabledProxyCreation()
        {
            Context.Configuration.ProxyCreationEnabled = false;
        }

        public object GetEntityKeyValue<T>(T entity) where T : class, new()
        {
            var keyvalues = Context.CreateEntityKey(entity);
            if (keyvalues == null || keyvalues.Length == 0)
                throw new MissingPrimaryKeyException();
            //if (keyvalues.Length>1) 
            //    throw new Exception("more than one Key found.");
            return keyvalues.Length > 1 ? keyvalues : keyvalues[0].Value;
        }


        /// <summary>
        /// Update the entered entity. This funtion won't update the properties past to unChangedProperties parameter.
        /// </summary>
        /// <typeparam name="T">Type of the object to update</typeparam>
        /// <param name="entity">The object to save into database.</param>
        /// <param name="unChangedProperties">list of properties that should not to be changed by this operation.</param>
        /// <returns>returns the updated entity.</returns>
        public T Update<T>(T entity, params Expression<Func<T, object>>[] unChangedProperties) where T : class, new()
        {
            var attachedEntity = Context.AttachToOrGet(entity);
            Context.Entry(attachedEntity).CurrentValues.SetValues(entity);

            if (attachedEntity.Equals(entity))
                Context.Entry(attachedEntity).State = EntityState.Modified;
            if (unChangedProperties != null)
            {
                foreach (var prop in unChangedProperties)
                    Context.Entry(attachedEntity).Property(prop).IsModified = false;
            }

            ApplyPreSaveChanges(attachedEntity, false);
            entity = attachedEntity;
            return entity;
        }


        public async Task<Restroom[]> GetRestroomsNearbyAsync(string routeAlpha, string direction, float? lat, float? longt, int? distance, bool publicRestrooms, bool pending)
        {
            var param1 = new SqlParameter("routeAlpha", routeAlpha ?? "");
            var param2 = new SqlParameter("direction", direction ?? "");
            var param3 = new SqlParameter("lat", lat ?? -1);
            var param4 = new SqlParameter("long", longt ?? -1);
            var param5 = distance.HasValue
                ? new SqlParameter("distance", distance)
                : new SqlParameter("distance", DBNull.Value);
            var param6 = new SqlParameter("isPublic", publicRestrooms);
            var param7 = new SqlParameter("zip", DBNull.Value);
            var param8 = new SqlParameter("statusListId ", pending ? 1 : 2);
            //var param9 = new SqlParameter("active", true);
            var param9 = new SqlParameter("deleted", false);

            return await Context.Database.SqlQuery<Restroom>("GetRestroomsNearby  @routeAlpha, @direction, @lat, @long, @distance,@isPublic, @Zip, @statusListId, @deleted",
                param1, param2, param3, param4, param5, param6, param7, param8, param9).ToArrayAsync();
            //return this.Database.SqlQuery<RestStop>("GetRestroomsNearby @p1, @p2, @p3, @p4, @p5", routeAlpha,direction,lat, longt,distance).AsQueryable<RestStop>();
        }

        public async Task<Restroom> GetRestroomAsync(int restroomId)
        {
            var param1 = new SqlParameter("RestroomId", restroomId);

            return await Context.Database.SqlQuery<Restroom>("GetRestroom @RestroomId", param1).FirstOrDefaultAsync();
        }

        public IEnumerable<Restroom> GetRestroomList()
        {
            return Context.Database.SqlQuery<Restroom>("GetRestroomList").ToList();
        }

        public async Task<Restroom> SaveRestroomAsync(Restroom restroom)
        {
            if (restroom.RestroomId == default)
                restroom = Create(restroom);
            else
                restroom = Update(restroom);
            await SaveChangesAsync();
            return restroom;
        }

        public IEnumerable<RestroomReport> GetRestroomsByDivision()
        {
            return Context.Database.SqlQuery<RestroomReport>("GetRestroomsByDivision").ToList();
        }

        public async Task<IEnumerable<RestroomHistory>> GetRestroomHistory(int id, string sortField, string sortDirection)
        {
            var restroomId = new SqlParameter("RestroomId", id);
            var sortColumn = new SqlParameter("SortField", sortField);
            var direction = new SqlParameter("SortDirection", sortDirection);
            return await Context.Database.SqlQuery<RestroomHistory>(
                    "GetRestroomHistory @restroomId, @sortField, @sortDirection", restroomId, sortColumn, direction).ToListAsync();
        }

        public async Task<IEnumerable<RestroomContactReport>> GetRestroomContactList(string sortField, string sortDirection)
        {
            var sortColumn = new SqlParameter("SortField", sortField);
            var direction = new SqlParameter("SortDirection", sortDirection);
            return await Context.Database.SqlQuery<RestroomContactReport>("GetRestroomContact @sortField, @sortDirection", sortColumn, direction).ToListAsync();
        }

        public async Task<IEnumerable<string>> GetRoutesByLocationAsync(float latitude, float longitude, int? radius)
        {
            var paramLat = new SqlParameter("LocationLat", latitude);
            var paramLong = new SqlParameter("LocationLong", longitude);
            var paramRadius = new SqlParameter("SearchRadiusFeet", radius ?? 600);

            return await Context.Database.SqlQuery<string>("GetRoutesByLocation @locationLat, @locationLong, @searchRadiusFeet", paramLat, paramLong, paramRadius).ToListAsync();
        }

        public async Task<IEnumerable<string>> GetRouteSuggestions(int? radius)
        {
            var paramRadius = new SqlParameter("SearchRadiusFeet", radius ?? 600);

            return await Context.Database.SqlQuery<string>("GetRouteSuggestions @searchRadiusFeet", paramRadius).ToListAsync();
        }

        public async Task<Feedback> SaveFeedbackAsync(Feedback feedback)
        {
            if (feedback.FeedbackId == default)
                feedback = Create(feedback);
            else
                feedback = Update(feedback);

            await SaveChangesAsync();

            return feedback;
        }

        public async Task<Confirmation> SaveConfirmationAsync(Confirmation confirmation)
        {
            confirmation = PrepConfirmation(confirmation);
            await SaveChangesAsync();
            return confirmation;
        }
        public async Task<User> SaveUserAsync(User user)
        {
            user = PrepUser(user);
            await SaveChangesAsync();
            return user;
        }
        public async Task<UserDevice> SaveUserDeviceAsync(UserDevice userDevice)
        {
            if (userDevice.UserDeviceId == default(long))
                userDevice = Create(userDevice);
            else
                userDevice = Update(userDevice);
            await SaveChangesAsync();
            return userDevice;
        }
        public async Task<Device> SaveDeviceAsync(Device device)
        {
            device = PrepDevice(device);
            await SaveChangesAsync();
            return device;
        }

        public Confirmation PrepConfirmation(Confirmation confirmation)
        {
            if (confirmation.ConfirmationId == default(long))
                confirmation = Create(confirmation);
            else
                confirmation = Update(confirmation);
            return confirmation;
        }
        public Device PrepDevice(Device device)
        {
            if (device.DeviceId == default(long))
                device = Create(device);
            else
                device = Update(device);
            return device;
        }
        public User PrepUser(User user)
        {
            if (user.UserId == default(int))
                user = Create(user);
            else
                user = Update(user);
            return user;
        }

        public async Task<Log> SaveLogAsync(Log log)
        {
            if (log.LogId == default(int))
                log = Create(log);
            else
                log = Update(log);
            await SaveChangesAsync();
            return log;

        }

        public async Task<int> DeleteConfirmationAsync(long id)
        {
            return await Context.Confirmations.Where(m => m.ConfirmationId == id).DeleteAsync();
        }
        public async Task<int> DeleteFeedbackAsync(long id)
        {
            return await Context.Feedbacks.Where(m => m.FeedbackId == id).DeleteAsync();
        }

        public async Task<int> InvalidateOperatorAsync(string badge)
        {
            return await Context.Confirmations.Where(m => m.Badge == badge).UpdateAsync(m => new Confirmation { Active = false });
        }

        public async Task<int> ValidateRestroomUser(int userId, bool active = true)
        {
            return await Context.Users.Where(m => m.UserId == userId).UpdateAsync(m => new User { Active = active });
        }

        public async Task<int> ValidateRestroomUserDevice(int userId, long deviceId, bool active = true)
        {
            return await Context.UserDevices.Where(m => m.UserId == userId && m.DeviceId == deviceId).UpdateAsync(m => new UserDevice { Active = active });
        }

        public async Task<int> ValidateRestroomDevice(long deviceId, bool active = true)
        {
            return await Context.Devices.Where(m => m.DeviceId == deviceId).UpdateAsync(m => new Device { Active = active });
        }

        public async Task<Contact> SaveContactAsync(Contact contact)
        {
            if (contact.ContactId == default)
                contact = Create(contact);
            else
                contact = Update(contact);
            await SaveChangesAsync();
            return contact;
        }

        //Override method in base class so local system datetime is used instead for auditing
        protected override void ApplyPreSaveChanges<T>(T entity, bool isEntityNew)
        {
            var modifiedStates = new List<EntityState> { EntityState.Added, EntityState.Modified };

            var auditDate = DateTime.Now;

            foreach (var contextEntry in Context.ChangeTracker.Entries<IAuditableEntity>())
            {
                if (!modifiedStates.Contains(contextEntry.State))
                    continue;

                var auditableEntity = contextEntry.Entity;

                if (contextEntry.State == EntityState.Added)
                {
                    auditableEntity.AddDateTime = auditDate;
                    auditableEntity.AddUserId = CurrentUserName ?? string.Empty;
                }
                else
                {
                    auditableEntity.UpdDateTime = auditDate;
                    auditableEntity.UpdUserId = CurrentUserName;

                    Context.Entry(auditableEntity).Property("AddUserId").OriginalValue = string.Empty;
                    Context.Entry(auditableEntity).Property("AddDateTime").OriginalValue = auditDate;
                    Context.Entry(auditableEntity).Property("AddUserId").IsModified = false;
                    Context.Entry(auditableEntity).Property("AddDateTime").IsModified = false;
                }
            }
        }
    }
}
