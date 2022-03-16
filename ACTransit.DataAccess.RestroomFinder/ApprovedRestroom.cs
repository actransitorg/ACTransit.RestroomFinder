using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;

using ACTransit.Framework.DataAccess.Annotations;

namespace ACTransit.DataAccess.RestroomFinder
{
    [Table("ApprovedRestroom")]
    public partial class ApprovedRestroom
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ApprovedRestroom()
        {
        }

        [Key]
        public int RestroomId { get; set; }

        //public int? ContactId { get; set; }

        //[StringLength(12)]
        //public string EquipmentNum { get; set; }

        //[StringLength(16)]
        //public string RestroomType { get; set; }

        //[StringLength(100)]
        //public string RestroomName { get; set; }

        //[StringLength(255)]
        //public string Address { get; set; }

        //[StringLength(14)]
        //public string City { get; set; }

        //[StringLength(2)]
        //public string State { get; set; }

        //public int? Zip { get; set; }

        //[StringLength(3)]
        //public string Country { get; set; }

        //[StringLength(3)]
        //public string DrinkingWater { get; set; }

        //[StringLength(1000)]
        //public string ACTRoute { get; set; }

        //[StringLength(130)]
        //public string WeekdayHours { get; set; }

        //[StringLength(130)]
        //public string SaturdayHours { get; set; }

        //[StringLength(130)]
        //public string SundayHours { get; set; }

        //[StringLength(500)]
        //public string Note { get; set; }

        //[StringLength(500)]
        //public string NearestIntersection { get; set; }  

        //[Precision(9, 6)]
        //public decimal? LongDec { get; set; }

        //[Precision(9, 6)]
        //public decimal? LatDec { get; set; }

        //public DbGeography Geo { get; set; }

        //[StringLength(255)]
        //public string NotificationEmail { get; set; }

        //public int? CleanedContactId { get; set; }

        //public int? RepairedContactId { get; set; }

        //public int? SuppliedContactId { get; set; }

        //public int? SecurityGatesContactId { get; set; }

        //public int? SecurityLocksContactId { get; set; }

        //public bool IsToiletAvailable { get; set; }

        ////public bool Active { get; set; }
        //public int ToiletGenderId { get; set; }
        //public bool AddressChanged { get; set; }

        //public bool Deleted { get; set; }

        //[StringLength(25)]
        //public string Division { get; set; }

        //public bool IsPublic { get; set; }

        //public DateTime? UnavailableFrom { get; set; }

        //public DateTime? UnavailableTo { get; set; }

        //public int? StatusListId { get; set; }     
        
        [StringLength(50)]
        public string AddUserId { get; set; }

        public string AddUserName { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }
        
        [StringLength(50)]
        public string UpdUserId { get; set; }

        public string UpdUserName { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        //public bool? IsHistory { get; set; }

        public string SearchRoutes { get; set; }
        
        //public string Comment { get; set; }
    }
}