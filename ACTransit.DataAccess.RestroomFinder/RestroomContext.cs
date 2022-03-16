using System;
using System.Data.Entity;
using System.Linq;
using System.Collections.Generic;
using System.Data.SqlClient;
using ACTransit.Framework.DataAccess.Annotations;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class RestroomContext : DbContext
    {
        public RestroomContext()
            : base("name=RestroomContext")
        {
        }

        public virtual DbSet<Confirmation> Confirmations { get; set; }
        public virtual DbSet<Contact> Contacts { get; set; }
        public virtual DbSet<CostTermList> CostTermLists { get; set; }
        public virtual DbSet<Feedback> Feedbacks { get; set; }
        public virtual DbSet<Log> Logs { get; set; }
        public virtual DbSet<Restroom> Restrooms { get; set; }
        public virtual DbSet<RestroomStatusList> RestroomStatusList { get; set; }
        public virtual DbSet<Setting> Settings { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserDevice> UserDevices { get; set; }
        public virtual DbSet<Device> Devices { get; set; }
        public virtual DbSet<V_UserDevice> V_UserDevices { get; set; }
        public virtual DbSet<V_User> V_Users { get; set; }
        public virtual DbSet<ApprovedRestroom> ApprovedRestrooms { get; set; }
        public virtual DbSet<ReviewRestroom> ReviewRestrooms { get; set; }
        public virtual DbSet<RestroomContact> RestroomContacts { get; set; }

        [Obsolete("Please use UnitOfWork instead.")]
        public IQueryable<Restroom> GetRestroomsNearby(string routeAlpha, string direction, float lat, float longt, int? distance)
        {
            var param1 = new SqlParameter("routeAlpha", routeAlpha ?? "");
            var param2 = new SqlParameter("direction", direction ?? "");
            var param3 = new SqlParameter("lat", lat);
            var param4 = new SqlParameter("long", longt);
            var param5 = distance.HasValue
                ? new SqlParameter("distance", distance)
                : new SqlParameter("distance", DBNull.Value);

            return Database.SqlQuery<Restroom>("GetRestroomsNearby  @routeAlpha, @direction, @lat, @long, @distance", param1, param2, param3, param4, param5).AsQueryable();
            //return this.Database.SqlQuery<RestStop>("GetRestroomsNearby @p1, @p2, @p3, @p4, @p5", routeAlpha,direction,lat, longt,distance).AsQueryable<RestStop>();
        }

        [Obsolete("Please use UnitOfWork instead.")]
        public Restroom GetRestroom(int restroomId)
        {
            var param1 = new SqlParameter("RestroomId", restroomId);

            return Database.SqlQuery<Restroom>("GetRestroom @RestroomId", param1).FirstOrDefault();
        }

        [Obsolete("Please use UnitOfWork instead.")]
        public Feedback SaveFeedback(Feedback feedback)
        {
            if (feedback.FeedbackId == default(int))
            {
                feedback.AddDateTime = DateTime.Now;
                Set<Feedback>().Add(feedback);
            }
            else
            {
                feedback.UpdDateTime = DateTime.Now;
                Set<Feedback>().Attach(feedback);
                Entry(feedback).State = EntityState.Modified;
            }

            ResolveUpdDateTime();

            SaveChanges();

            Entry(feedback).Reload();

            return feedback;
        }

        [Obsolete("Please use UnitOfWork instead.")]
        public Confirmation SaveConfirmation(Confirmation confirmation)
        {
            if (confirmation.ConfirmationId == default(int))
            {
                confirmation.AddDateTime = DateTime.Now;
                Set<Confirmation>().Add(confirmation);
            }
            else
            {
                Set<Confirmation>().Attach(confirmation);
                Entry(confirmation).State = EntityState.Modified;
            }
            SaveChanges();
            Entry(confirmation).Reload();
            return confirmation;
        }

        [Obsolete("Please use UnitOfWork instead.")]
        public User SaveUser(User user)
        {
            if (user.UserId == default(int))
            {
                user.AddDateTime = DateTime.Now;
                Set<User>().Add(user);
            }
            else
            {
                Set<User>().Attach(user);
                Entry(user).State = EntityState.Modified;
            }
            SaveChanges();
            Entry(user).Reload();
            return user;
        }

        [Obsolete("Please use UnitOfWork instead.")]
        public Log SaveLog(Log log)
        {
            if (log.LogId == default(int))
            {
                log.AddDateTime = DateTime.Now;
                Set<Log>().Add(log);
            }
            else
            {
                Set<Log>().Attach(log);
                Entry(log).State = EntityState.Modified;
            }

            SaveChanges();

            Entry(log).Reload();

            return log;
        }

        [Obsolete("Please use UnitOfWork instead.")]
        private void ResolveUpdDateTime()
        {
            var modifiedStates = new List<EntityState> { EntityState.Added, EntityState.Modified };

            //var auditDate = DateTime.UtcNow;
            var auditDate = DateTime.Now;

            foreach (var contextEntry in ChangeTracker.Entries<Feedback>())
            {
                if (!modifiedStates.Contains(contextEntry.State))
                    continue;

                var auditableEntity = contextEntry.Entity;

                auditableEntity.UpdDateTime = auditDate;

                if (contextEntry.State == EntityState.Added)
                {
                    auditableEntity.AddDateTime = auditDate;
                }
                else
                {
                    Entry(auditableEntity).Property("AddDateTime").OriginalValue = DateTime.Now;
                    Entry(auditableEntity).Property("AddDateTime").IsModified = false;
                }
            }
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            Precision.ConfigureModelBuilder(modelBuilder);
            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.Contact)
                .WithMany(m => m.Restrooms)
                .HasForeignKey(m => m.ContactId);

            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.CleanedContact)
                .WithMany(m => m.RestroomsIClean)
                .HasForeignKey(m => m.CleanedContactId);

            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.RepairedContact)
                .WithMany(m => m.RestroomsIRepair)
                .HasForeignKey(m => m.RepairedContactId);

            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.SuppliedContact)
                .WithMany(m => m.RestroomsISupply)
                .HasForeignKey(m => m.SuppliedContactId);

            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.SecurityGatesContact)
                .WithMany(m => m.RestroomsGateIProtect)
                .HasForeignKey(m => m.SecurityGatesContactId);

            modelBuilder.Entity<Restroom>()
                .HasOptional(m => m.SecurityLocksContact)
                .WithMany(m => m.RestroomsLockIProtect)
                .HasForeignKey(m => m.SecurityLocksContactId);


            //modelBuilder.Entity<Confirmation>()
            //    .Property(e => e.Badge)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Confirmation>()
            //    .Property(e => e.DeviceId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Confirmation>()
            //    .Property(e => e.SessionId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Confirmation>()
            //    .Property(e => e.AddUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Confirmation>()
            //    .Property(e => e.UpdUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.Name)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.Phone)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.Email)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.Address)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.AddUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .Property(e => e.UpdUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Contact>()
            //    .HasMany(e => e.RestroomContacts)
            //    .WithRequired(e => e.Contact)
            //    .WillCascadeOnDelete(false);

            //modelBuilder.Entity<CostTermList>()
            //    .Property(e => e.Name)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.Badge)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.FeedbackText)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.Rating)
            //    .HasPrecision(3, 2);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.Issue)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.WorkRequestDescription)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.WorkRequestId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.AddUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Feedback>()
            //    .Property(e => e.UpdUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<IssueStatusList>()
            //    .Property(e => e.Name)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Log>()
            //    .Property(e => e.DeviceId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Log>()
            //    .Property(e => e.DeviceModel)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Log>()
            //    .Property(e => e.DeviceOS)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Log>()
            //    .Property(e => e.Description)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.EquipmentNum)
            //    .IsFixedLength()
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.RestroomType)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.RestroomName)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.Address)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.City)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.State)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.Country)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.DrinkingWater)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.ACTRoute)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.Hours)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.Note)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.LongDec)
            //    .HasPrecision(9, 6);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.LatDec)
            //    .HasPrecision(9, 6);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.NotificationEmail)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.AverageRating)
            //    .HasPrecision(3, 2);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.AddUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .Property(e => e.UpdUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<Restroom>()
            //    .HasMany(e => e.Feedbacks)
            //    .WithRequired(e => e.Restroom)
            //    .WillCascadeOnDelete(false);

            //modelBuilder.Entity<Restroom>()
            //    .HasMany(e => e.RestroomContacts)
            //    .WithRequired(e => e.Restroom)
            //    .WillCascadeOnDelete(false);

            //modelBuilder.Entity<RestroomContact>()
            //    .Property(e => e.Cost)
            //    .HasPrecision(19, 4);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.Badge)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.DeviceId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.DeviceModel)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.DeviceOS)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.SessionId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.Description)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.AddUserId)
            //    .IsUnicode(false);

            //modelBuilder.Entity<User>()
            //    .Property(e => e.UpdUserId)
            //    .IsUnicode(false);
        }
    }
}
