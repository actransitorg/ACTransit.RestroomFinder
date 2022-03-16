using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ACTransit.DataAccess.RestroomFinder.Interfaces;
using ACTransit.Framework.DataAccess.Annotations;
using ACTransit.Framework.Interfaces;

namespace ACTransit.DataAccess.RestroomFinder.Partials
{
    public class RestroomBase
    {

        public int? ContactId { get; set; }

        [StringLength(12)]
        public string EquipmentNum { get; set; }

        [StringLength(16)]
        public string RestroomType { get; set; }

        [StringLength(100)]
        public string RestroomName { get; set; }

        [StringLength(255)]
        public string Address { get; set; }

        [StringLength(14)]
        public string City { get; set; }

        [StringLength(2)]
        public string State { get; set; }

        public int? Zip { get; set; }

        [StringLength(3)]
        public string Country { get; set; }

        [StringLength(3)]
        public string DrinkingWater { get; set; }

        [StringLength(1000)]
        public string ACTRoute { get; set; }

        [StringLength(130)]
        public string WeekdayHours { get; set; }

        [StringLength(130)]
        public string SaturdayHours { get; set; }

        [StringLength(130)]
        public string SundayHours { get; set; }

        [StringLength(500)]
        public string Note { get; set; }

        [StringLength(500)]
        public string NearestIntersection { get; set; }

        [Precision(9, 6)]
        public decimal? LongDec { get; set; }

        [Precision(9, 6)]
        public decimal? LatDec { get; set; }

        public DbGeography Geo { get; set; }

        [StringLength(255)]
        public string NotificationEmail { get; set; }

        public int? CleanedContactId { get; set; }

        public int? RepairedContactId { get; set; }

        public int? SuppliedContactId { get; set; }

        public int? SecurityGatesContactId { get; set; }

        public int? SecurityLocksContactId { get; set; }

        public bool IsToiletAvailable { get; set; }

        //public bool Active { get; set; }
        public int? ToiletGenderId { get; set; }
        public bool? AddressChanged { get; set; }

        public bool Deleted { get; set; }

        [StringLength(25)]
        public string Division { get; set; }

        public bool IsPublic { get; set; }

        public DateTime? UnavailableFrom { get; set; }

        public DateTime? UnavailableTo { get; set; }

        public int? StatusListId { get; set; }
        
        public bool? IsHistory { get; set; }

        public string Comment { get; set; }

        [StringLength(7)]
        public string LabelId { get; set; }
    }
}
