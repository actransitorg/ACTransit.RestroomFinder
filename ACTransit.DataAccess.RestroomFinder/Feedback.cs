namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Feedback")]
    public partial class Feedback
    {
        public long FeedbackId { get; set; }

        public int RestroomId { get; set; }

        [Required]
        [StringLength(6)]
        public string Badge { get; set; }

        public bool NeedAttention { get; set; }

        public bool? NeedRepair { get; set; }

        public bool? NeedSupply { get; set; }

        public bool? NeedCleaning { get; set; }

        public bool? Closed { get; set; }

        [StringLength(255)]
        public string FeedbackText { get; set; }

        public decimal? Rating { get; set; }

        [StringLength(255)]
        public string Issue { get; set; }

        [StringLength(2000)]
        public string Resolution { get; set; }

        [StringLength(2000)]
        public string ReportedAction { get; set; }

        [StringLength(255)]
        public string WorkRequestDescription { get; set; }

        [StringLength(50)]
        public string WorkRequestId { get; set; }
        public bool? InspectionPassed { get; set; }

        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        public virtual Restroom Restroom { get; set; }
    }
}
