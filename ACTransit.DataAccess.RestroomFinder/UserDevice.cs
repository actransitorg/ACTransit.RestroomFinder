namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("UserDevice")]
    public partial class UserDevice
    {
        [Required]
        public long UserDeviceId { get; set; }

        public int UserId { get; set; }
        public long DeviceId{ get; set; }

        public DateTime? LastLogon{ get; set; }

        public bool Active { get; set; }       

        
        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        public User User { get; set; }
        public Device Device { get; set; }        
    }
}
