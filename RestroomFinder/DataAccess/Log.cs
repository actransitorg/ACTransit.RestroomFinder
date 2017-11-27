using System;

namespace ACTransit.DataAccess.RestroomFinder
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("Log")]
    public partial class Log
    {
        public long LogId { get; set; }

        [StringLength(100)]
        public string DeviceId { get; set; }

        [StringLength(50)]
        public string DeviceOS { get; set; }

        [StringLength(50)]
        public string DeviceModel { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public DateTime AddDateTime { get; set; }

    }
}