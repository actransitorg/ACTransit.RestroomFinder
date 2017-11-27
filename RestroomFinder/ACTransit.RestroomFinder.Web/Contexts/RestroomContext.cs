using System.Data.Entity;
using ACTransit.RestroomFinder.Web.Models;
using System.Data.Entity.ModelConfiguration;

namespace ACTransit.RestroomFinder.Web.Contexts
{
    public partial class RestroomContext : DbContext
    {
        public RestroomContext()
        {
        }

        public virtual DbSet<RestroomViewModel> Restrooms { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new RestroomConfiguration());
        }
    }

    public class RestroomConfiguration : EntityTypeConfiguration<RestroomViewModel>
    {
        public RestroomConfiguration()
        {
            ToTable("Restroom");
            Property(f => f.LatDec).HasPrecision(precision: 9, scale: 6);
            Property(f => f.LongDec).HasPrecision(precision: 9, scale: 6);
        }
    }
}