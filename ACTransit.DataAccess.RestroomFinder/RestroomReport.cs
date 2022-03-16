namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Data.Entity.Spatial;

    public partial class RestroomReport
    {
        public int RestroomId { get; set; }

        //public int? ContactId { get; set; }

        //public string EquipmentNum { get; set; }

        //public string RestroomType { get; set; }

        //public string RestroomName { get; set; }

        //public string Address { get; set; }

        //public string City { get; set; }

        //public string State { get; set; }

        //public int? Zip { get; set; }

        //public string Country { get; set; }

        //public string DrinkingWater { get; set; }

        //public string ACTRoute { get; set; }

        //public string Division { get; set; }

        public string Route { get; set; }

        public string DestinationName { get; set; }

        //public string WeekdayHours { get; set; }

        //public string SaturdayHours { get; set; }

        //public string SundayHours { get; set; }

        //public string Note { get; set; }

        //public string NearestIntersection { get; set; }

        //public decimal? LongDec { get; set; }

        //public decimal? LatDec { get; set; }

        //public DbGeography Geo { get; set; }

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

        //public bool? IsHistory { get; set; }

        //public bool IsPublic { get; set; }

        //public int? StatusListId { get; set; }

        //public DateTime? UnavailableFrom { get; set; }

        //public DateTime? UnavailableTo { get; set; }
        //public string Comment { get; set; }

        public string AddUserName { get; set; }

        public string UpdUserName { get; set; }
    }
}
