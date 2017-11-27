//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ACTransit.Entities.Scheduling
{
    using System;
    using System.Collections.Generic;
    
    public partial class Trip
    {
        public Trip()
        {
            this.Trip1 = new HashSet<Trip>();
            this.TripStops = new HashSet<TripStop>();
            this.TripTimingPoints = new HashSet<TripTimingPoint>();
        }
    
        public string BookingId { get; set; }
        public string ScheduleType { get; set; }
        public int PermanentTripNumber { get; set; }
        public int TripNumber { get; set; }
        public Nullable<int> NextTripNumber { get; set; }
        public string RouteAlpha { get; set; }
        public short PatternId { get; set; }
        public bool HasOpException { get; set; }
        public string StatusCode { get; set; }
        public string EventAndStatus { get; set; }
        public System.DateTime TimeStart { get; set; }
        public System.DateTime TimeEnd { get; set; }
        public Nullable<short> HeadwayStart { get; set; }
        public Nullable<short> HeadwayEnd { get; set; }
        public int BlockNumber { get; set; }
        public byte Rank { get; set; }
        public bool OperatesSunday { get; set; }
        public bool OperatesMonday { get; set; }
        public bool OperatesTuesday { get; set; }
        public bool OperatesWednesday { get; set; }
        public bool OperatesThursday { get; set; }
        public bool OperatesFriday { get; set; }
        public bool OperatesSaturday { get; set; }
        public Nullable<System.DateTime> ValidToDate { get; set; }
        public string AddUserId { get; set; }
        public System.DateTime AddDateTime { get; set; }
        public string UpdUserId { get; set; }
        public System.DateTime UpdDateTime { get; set; }
        public long SysRecNo { get; set; }
    
        public virtual Booking Booking { get; set; }
        public virtual Route Route { get; set; }
        public virtual ICollection<Trip> Trip1 { get; set; }
        public virtual Trip Trip2 { get; set; }
        public virtual TripPattern TripPattern { get; set; }
        public virtual ICollection<TripStop> TripStops { get; set; }
        public virtual ICollection<TripTimingPoint> TripTimingPoints { get; set; }
    }
}