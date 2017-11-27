using System;

namespace ACTransit.DataAccess.RestroomFinder
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("Confirmation")]
    public partial class Confirmation
    {
        public long ConfirmationId { get; set; }

        [StringLength(6)]
        public string Badge { get; set; }

        public bool Agreed { get; set; }

        public DateTime IncidentDateTime { get; set; }
        public DateTime AddDateTime { get; set; }
    }
}