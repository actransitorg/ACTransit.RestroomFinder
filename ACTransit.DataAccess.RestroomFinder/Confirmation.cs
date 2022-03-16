namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Confirmation")]
    public partial class Confirmation
    {
        [Key]
        public long ConfirmationId { get; set; }

        [Required]
        [StringLength(6)]
        public string Badge { get; set; }

        public bool Agreed { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime IncidentDateTime { get; set; }

        [StringLength(100)]
        public string DeviceId { get; set; }

        [StringLength(2000)]
        public string SessionId { get; set; }

        public bool? Active { get; set; }

        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }
    }
}
