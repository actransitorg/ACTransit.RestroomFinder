using ACTransit.Framework.DataAccess.Annotations;
using System;
using System.Data.Entity.Spatial;
using System.Runtime.Serialization;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Enums;

namespace ACTransit.RestroomFinder.API.Models
{
    [DataContract(Name = "Restroom")]
    public class Restroom
    {
        [DataMember(Name = "restroomId")]
        public int RestroomId { get; set; }

        [DataMember(Name = "equipmentNum")]
        public string EquipmentNum { get; set; }

        [DataMember(Name = "restroomType")]
        public string RestroomType { get; set; }

        [DataMember(Name = "restroomName")]
        public string RestroomName { get; set; }

        [DataMember(Name = "serviceProvider")]
        public string ServiceProvider { get; set; }


        [DataMember(Name = "contactName")]
        public string ContactName { get; set; }

        [DataMember(Name = "contactTitle")]
        public string ContactTitle{ get; set; }

        [DataMember(Name = "contactPhone")]
        public string ContactPhone{ get; set; }

        [DataMember(Name = "contactEmail")]
        public string ContactEmail { get; set; }


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

        [DataMember(Name = "weekdayHours")]
        public string WeekdayHours { get; set; }
        [DataMember(Name = "saturdayHours")]
        public string SaturdayHours { get; set; }
        [DataMember(Name = "sundayHours")]
        public string SundayHours { get; set; }

        public bool Active { get; set; }
        [DataMember(Name = "toiletGenderId")]
        public int? ToiletGenderId { get; set; }
        [DataMember(Name = "addressChanged")]
        public bool? AddressChanged { get; set; }


        [DataMember(Name = "note")]
        public string Note { get; set; }

        [DataMember(Name = "nearestIntersection")]
        public string NearestIntersection { get; set; }

        [DataMember(Name = "longDec")]
        public decimal? LongDec { get; set; }

        [DataMember(Name = "latDec")]
        public decimal? LatDec { get; set; }

        [DataMember(Name = "isToiletAvailable")]
        public bool IsToiletAvailable { get; set; }

        [DataMember(Name = "labelId")]
        public string LabelId { get; set; }

        [DataMember(Name = "averageRating")]
        public decimal? AverageRating { get; set; }

        [DataMember(Name = "geo")]
        public DbGeography Geo { get; set; }

        [DataMember(Name = "approved")]
        public bool Approved { get; set; }

        [DataMember(Name = "division")]
        public string Division { get; set; }

        [DataMember(Name = "isPublic")]
        public bool IsPublic { get; set; }

        [DataMember(Name = "isHistory")] 
        public bool? IsHistory { get; set; }

        //[DataMember(Name = "isPaid")]
        //public bool IsPaid => !(RestroomType == "BART" || RestroomType == "NON-PAID");

        //[DataMember(Name = "isPaid")]
        //public bool IsPaid
        //{
        //    get { return !(RestroomType==null || RestroomType.ToUpper() == "BART" || RestroomType.ToUpper() == "NON-PAID" || RestroomType.ToUpper() == "ACT"); }
        //    set{}
        //}

        internal static Restroom FromDataAccess(ACTransit.DataAccess.RestroomFinder.Restroom restStop)
        {
            return FromDataAccess(restStop, null);
        }

        internal static Restroom FromDataAccess(ACTransit.DataAccess.RestroomFinder.Restroom restStop, ACTransit.DataAccess.RestroomFinder.Contact contact)
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
                WeekdayHours = restStop.WeekdayHours,
                SaturdayHours = restStop.SaturdayHours,
                SundayHours = restStop.SundayHours,
                NearestIntersection = restStop.NearestIntersection,
                RestroomName = restStop.RestroomName,
                RestroomId = restStop.RestroomId,
                RestroomType = restStop.RestroomType,
                IsToiletAvailable = restStop.IsToiletAvailable,
                State = restStop.State,
                Zip = restStop.Zip,
                IsHistory = restStop.IsHistory,
                IsPublic = restStop.IsPublic,
                AverageRating = restStop.AverageRating,
                Approved = restStop.StatusListId.GetValueOrDefault(2)==2,
                Active=restStop.StatusListId.GetValueOrDefault() == (int)RestroomEnums.RestroomApprovalStatus.Approved,
                ToiletGenderId = restStop.ToiletGenderId,
                AddressChanged = restStop.AddressChanged,
                LabelId = restStop.LabelId,
                ContactName = contact?.ContactName,
                ContactTitle= contact?.Title,
                ContactEmail = contact?.Email,
                ContactPhone= contact?.Phone,
                ServiceProvider= contact?.ServiceProvider,
                
                //Active = restStop.Active
            };
        }

        internal ACTransit.DataAccess.RestroomFinder.Restroom ToDataAccess()
        {
            return new ACTransit.DataAccess.RestroomFinder.Restroom
            {
                ACTRoute = ACTRoute,
                Address = Address,
                City = City,
                Country = Country,
                DrinkingWater = DrinkingWater,
                Geo = DbGeography.PointFromText(String.Format("POINT({0} {1})", LongDec, LatDec),4326),
                LatDec = LatDec,
                LongDec = LongDec,
                Note = Note,
                WeekdayHours = WeekdayHours,
                SaturdayHours = SaturdayHours ,
                SundayHours = SundayHours,
                NearestIntersection = NearestIntersection,
                RestroomName = RestroomName,
                RestroomId = RestroomId,
                RestroomType = RestroomType,
                IsToiletAvailable = IsToiletAvailable,
                State = State,
                Zip = Zip,
                IsPublic = IsPublic,
                AverageRating = AverageRating,
                AddDateTime = DateTime.Now,
                StatusListId = Active ? (Approved ? (int)RestroomEnums.RestroomApprovalStatus.Approved : (int)RestroomEnums.RestroomApprovalStatus.Pending) : (int)RestroomEnums.RestroomApprovalStatus.InActive,
                ToiletGenderId = ToiletGenderId,
                AddressChanged = AddressChanged,
                LabelId = LabelId,
            };
        }

        internal ACTransit.DataAccess.RestroomFinder.Restroom ToDataAccessFrom(ACTransit.DataAccess.RestroomFinder.Restroom restroom)
        {
            restroom.ACTRoute = ACTRoute;
            restroom.Address = Address;
            restroom.City = City;
            restroom.Country = Country;
            restroom.DrinkingWater = DrinkingWater;
            restroom.Geo = DbGeography.PointFromText(String.Format("POINT({0} {1})", LongDec, LatDec), 4326);
            restroom.LatDec = LatDec;
            restroom.LongDec = LongDec;
            restroom.Note = Note;
            restroom.WeekdayHours = WeekdayHours;
            restroom.SaturdayHours = SaturdayHours;
            restroom.SundayHours = SundayHours;
            restroom.NearestIntersection = NearestIntersection;
            restroom.RestroomName = RestroomName;
            restroom.RestroomType = RestroomType;
            restroom.IsToiletAvailable = IsToiletAvailable;
            restroom.State = State;
            restroom.Zip = Zip;
            restroom.IsPublic = IsPublic;
            restroom.AverageRating = AverageRating;
            restroom.UpdDateTime = DateTime.Now;
            restroom.StatusListId = Active?(Approved ? (int)RestroomEnums.RestroomApprovalStatus.Approved : (int)RestroomEnums.RestroomApprovalStatus.Pending):(int)RestroomEnums.RestroomApprovalStatus.InActive;
            restroom.ToiletGenderId = ToiletGenderId;
            restroom.AddressChanged = AddressChanged;
            restroom.LabelId = LabelId;
            return restroom;
        }
    }

    [Flags]
    public enum GenderToiletEnum
    {
        Men=1,
        Women=2,
        GenderNeutral=4,
    }
}