using System;
using System.ComponentModel.DataAnnotations;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class Feedback
    {
        public int RestroomId { get; set; }

        public long FeedbackId { get; set; }

        [StringLength(6, ErrorMessage = "Please provide 6 digit Badge number")]
        [Required(ErrorMessage = "This field is required")]
        public string Badge { get; set; }

        public bool NeedsAttention { get; set; }

        public bool? NeedsRepair { get; set; }

        public bool? NeedsSupply { get; set; }

        public bool? NeedsCleaning { get; set; }

        public string FeedbackText { get; set; }

        public decimal? Rating { get; set; }

        public bool? InspectionPassed { get; set; }

        public string Issue { get; set; }

        public string Resolution { get; set; }

        public string ReportedAction { get; set; }

        public DateTime AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }
    }
}
