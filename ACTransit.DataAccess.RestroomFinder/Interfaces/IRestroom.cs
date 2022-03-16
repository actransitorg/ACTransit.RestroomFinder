using System;

using System.Data.Entity.Spatial;

namespace ACTransit.DataAccess.RestroomFinder.Interfaces
{
    public interface IRestroom
    {
        //bool Active { get; set; }
        int? ToiletGenderId { get; set; }
        bool? AddressChanged { get; set; }
        string LabelId { get; set; }
        string ACTRoute { get; set; }

        string Address { get; set; }

        string City { get; set; }

        string Country { get; set; }

        bool Deleted { get; set; }

        string Division { get; set; }

        string DrinkingWater { get; set; }

        string EquipmentNum { get; set; }

        DbGeography Geo { get; set; }

        int? CleanedContactId { get; set; }

        int? RepairedContactId { get; set; }

        int? SuppliedContactId { get; set; }

        int? SecurityGatesContactId { get; set; }

        int? SecurityLocksContactId { get; set; }

        bool IsToiletAvailable { get; set; }

        bool? IsHistory { get; set; }

        bool IsPublic { get; set; }

        decimal? LatDec { get; set; }

        decimal? LongDec { get; set; }

        string NearestIntersection { get; set; }

        string Note { get; set; }

        string NotificationEmail { get; set; }

        int RestroomId { get; set; }
        int? ContactId { get; set; }

        
        string RestroomName { get; set; }

        string RestroomType { get; set; }

        string SaturdayHours { get; set; }

        string State { get; set; }

        int? StatusListId { get; set; }
        
        string SundayHours { get; set; }

        DateTime? UnavailableFrom { get; set; }

        DateTime? UnavailableTo { get; set; }

        string WeekdayHours { get; set; }

        int? Zip { get; set; }
        string Comment { get; set; }
    }
}