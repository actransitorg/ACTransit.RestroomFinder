namespace ACTransit.DataAccess.RestroomFinder
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Restroom")]
    public partial class Restroom: IModel
    {
        [Key]
        public int RestroomId { get; set; }

        [StringLength(16)]
        public string RestroomType { get; set; }

        [StringLength(52)]
        public string RestroomName { get; set; }

        [StringLength(49)]
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

        [StringLength(34)]
        public string ACTRoute { get; set; }

        [StringLength(130)]
        public string Hours { get; set; }

        [StringLength(21)]
        public string Note { get; set; }

        public decimal? LongDec { get; set; }

        public decimal? LatDec { get; set; }
        
        public decimal? AverageRating { get; set; }

        public DbGeography Geo { get; set; }

        [NotMapped]
        public int Id
        {
            get { return RestroomId; }
            set { RestroomId = value; }
        }
    }
}