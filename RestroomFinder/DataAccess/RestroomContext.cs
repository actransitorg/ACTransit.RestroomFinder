using System.Collections.Generic;

namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Data.Entity;
    using System.Linq;
    using System.Data.SqlClient;
   
    public partial class RestroomContext : DbContext
    {
        public RestroomContext() : base("name=RestroomContext")
        {
        }

        public virtual DbSet<Restroom> Restrooms { get; set; }

        public virtual DbSet<Feedback> Feedback { get; set; }

        public virtual DbSet<Log> Logs { get; set; }

        public virtual DbSet<Confirmation> Confirmations { get; set; }

        public IQueryable<Restroom> GetRestroomsNearby(string routeAlpha, string direction, float lat, float longt, int? distance)
        {
            var param1 = new SqlParameter("routeAlpha", routeAlpha??"");
            var param2 = new SqlParameter("direction", direction??"");
            var param3 = new SqlParameter("lat", lat);
            var param4 = new SqlParameter("long", longt);
            var param5 = distance.HasValue 
                ? new SqlParameter("distance", distance)
                : new SqlParameter("distance", DBNull.Value);

            return Database.SqlQuery<Restroom>("GetRestroomsNearby  @routeAlpha, @direction, @lat, @long, @distance", param1, param2, param3, param4, param5).AsQueryable<Restroom>();
            //return this.Database.SqlQuery<RestStop>("GetRestroomsNearby @p1, @p2, @p3, @p4, @p5", routeAlpha,direction,lat, longt,distance).AsQueryable<RestStop>();
        }

        public Restroom GetRestStop(short restroomId)
        {
            var param1 = new SqlParameter("RestroomId", restroomId);

            return Database.SqlQuery<Restroom>("GetRestroom @RestroomId", param1).FirstOrDefault();
        }


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
            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.RestType)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.RestName)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.Address)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.City)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.State)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.Country)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.DrinkingWater)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.ACTRoute)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.Hours)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.Note)
            //    .IsUnicode(false);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.LongDec)
            //    .HasPrecision(9, 6);

            //modelBuilder.Entity<RestStop>()
            //    .Property(e => e.LatDec)
            //    .HasPrecision(9, 6);
        }
    }
}
