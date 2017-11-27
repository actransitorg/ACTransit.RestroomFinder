using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ACTransit.DataAccess.RestroomFinder
{
    [Table("Feedback")]
    public class Feedback
    {
        public long FeedbackId { get; set; }

        [ForeignKey("Restroom")]
        public int RestroomId { get; set; }

        [StringLength(6)]
        public string Badge { get; set; }

        public bool NeedAttention { get; set; }

        [StringLength(255)]
        public string FeedbackText { get; set; }

        public decimal? Rate { get; set; }

        public DateTime AddDateTime { get; set; }
        
        public DateTime? UpdDateTime { get; set; }

        public Restroom Restroom { get; set; }
    }
}
