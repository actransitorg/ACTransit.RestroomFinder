using System;
using System.ComponentModel.DataAnnotations;
using NetTopologySuite.Geometries;

namespace ACTransit.RestroomFinder.Core.Domain.RestroomFinder.Models
{
    public class Restroom
    {
        [Key]
        public int RestroomId { get; set; }
        public string RestroomType { get; set; }
        public string RestroomName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public int? Zip { get; set; }
        public string Country { get; set; }
        public string DrinkingWater { get; set; }
        public string Actroute { get; set; }
        public string Hours { get; set; }
        public string Note { get; set; }
        public decimal? LongDec { get; set; }
        public decimal? LatDec { get; set; }
        public Point Geo { get; set; }
        public string AddUserId { get; set; }
        public DateTime? AddDateTime { get; set; }
        public string UpdUserId { get; set; }
        public DateTime? UpdDateTime { get; set; }
    }
}
