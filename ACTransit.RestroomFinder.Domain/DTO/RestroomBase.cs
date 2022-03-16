using System;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity.Spatial;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class RestroomBase
    {
        public int RestroomId { get; set; }
        public int? ContactId { get; set; }

        public string EquipmentNum { get; set; }

        public string RestroomType { get; set; }

        [StringLength(100)]
        [Required(ErrorMessage = "Please enter a restroom name")]
        public string RestroomName { get; set; }

        [StringLength(255)]
        [Required(ErrorMessage = "Please enter a valid address")]
        public string Address { get; set; }

        [StringLength(14)]
        [Required(ErrorMessage = "Please enter a valid city")]
        public string City { get; set; }

        public string State { get; set; }

        public int? Zip { get; set; }

        public string Country { get; set; }

        public string DrinkingWater { get; set; }

        public string ACTRoute { get; set; }

        [StringLength(130)]
        public string WeekdayHours { get; set; }

        [StringLength(130)]
        public string SaturdayHours { get; set; }

        [StringLength(130)]
        public string SundayHours { get; set; }

        [StringLength(500)]
        public string Note { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.0#####}", ApplyFormatInEditMode = true)]
        [Required(ErrorMessage = "Please make sure that you select a correct location from the map window in order to get the longitude")]
        public decimal? LongDec { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.0#####}", ApplyFormatInEditMode = true)]
        [Required(ErrorMessage = "Please make sure that you select a correct location from the map window in order to get the latitude")]
        public decimal? LatDec { get; set; }

        public DbGeography Geo { get; set; }

        public string NotificationEmail { get; set; }

        public int? CleanedContactId { get; set; }

        public int? RepairedContactId { get; set; }

        public int? SuppliedContactId { get; set; }

        public int? SecurityGatesContactId { get; set; }

        public int? SecurityLocksContactId { get; set; }

        public bool IsToiletAvailable { get; set; } = true;
        
        public int? ToiletGenderId { get; set; } = 0;
        
        public bool? AddressChanged { get; set; } = true;

        [StringLength(7, ErrorMessage = "Only upto 7 characters ID no is allowed.")]
        public string LabelId { get; set; }

        public bool Deleted { get; set; } = false;

        public bool? IsHistory { get; set; }

        public bool IsPublic { get; set; } = false;

        public int StatusListId { get; set; }

        public string Comment { get; set; }

        public DateTime? UnavailableFrom { get; set; }

        public DateTime? UnavailableTo { get; set; }
    }
}
