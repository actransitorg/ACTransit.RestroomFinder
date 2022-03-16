namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Device")]
    public partial class Device
    {
        [Required]
        public long DeviceId { get; set; }

        public string DeviceGuid { get; set; }


        [StringLength(100)]
        public string DeviceModel { get; set; }

        [StringLength(50)]
        public string DeviceOS { get; set; }

        [StringLength(20)]
        public string PhoneNumber { get; set; }

        [StringLength(20)]
        public string Confirm2FACode { get; set; }
        public DateTime? Confirm2FAExpires { get; set; }

        public bool? Confirmed2FACode { get; set; }
        public DateTime? LastUsed{ get; set; }

        [StringLength(4000)]
        public string DeviceSessionId { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public bool Active { get; set; }

        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        public ICollection<UserDevice> UserDevices { get; set; }
    }
}
