using System;
using System.Data.Entity.Spatial;
using System.Runtime.Serialization;

namespace RestroomFinderAPI.Models
{
    [DataContract(Name = "Restroom")]
    public class Restroom
    {
        [DataMember(Name = "restroomId")]
        public int RestroomId { get; set; }

        [DataMember(Name = "restroomType")]
        public string RestroomType { get; set; }

        [DataMember(Name = "restroomName")]
        public string RestroomName { get; set; }

        [DataMember(Name = "address")]
        public string Address { get; set; }

        [DataMember(Name = "city")]
        public string City { get; set; }

        [DataMember(Name = "state")]
        public string State { get; set; }

        [DataMember(Name = "zip")]
        public int? Zip { get; set; }

        [DataMember(Name = "country")]
        public string Country { get; set; }

        [DataMember(Name = "drinkingWater")]
        public string DrinkingWater { get; set; }

        [DataMember(Name = "actRoute")]
        public string ACTRoute { get; set; }

        [DataMember(Name = "hours")]
        public string Hours { get; set; }

        [DataMember(Name = "note")]
        public string Note { get; set; }

        [DataMember(Name = "longDec")]
        public decimal? LongDec { get; set; }

        [DataMember(Name = "latDec")]
        public decimal? LatDec { get; set; }

        [DataMember(Name = "averageRating")]
        public decimal? AverageRating { get; set; }

        [DataMember(Name = "geo")]
        public DbGeography Geo { get; set; }

        //[DataMember(Name = "isPaid")]
        //public bool IsPaid => !(RestroomType == "BART" || RestroomType == "NON-PAID");

        [DataMember(Name = "isPaid")]
        public bool IsPaid
        {
            get { return !(RestroomType == "BART" || RestroomType == "NON-PAID"); }
            set{}
        }
            

        internal static Restroom FromDataAccess(ACTransit.DataAccess.RestroomFinder.Restroom restStop)
        {
            return new Restroom
            {
                ACTRoute = restStop.ACTRoute,
                Address = restStop.Address,
                City = restStop.City,
                Country = restStop.Country,
                DrinkingWater = restStop.DrinkingWater,
                Geo = restStop.Geo,
                LatDec = restStop.LatDec,
                LongDec = restStop.LongDec,
                Note = restStop.Note,
                Hours = restStop.Hours,
                RestroomName = restStop.RestroomName,
                RestroomId = restStop.RestroomId,
                RestroomType = restStop.RestroomType,
                State = restStop.State,
                Zip = restStop.Zip,
                AverageRating = restStop.AverageRating
            };
        }
    }
}