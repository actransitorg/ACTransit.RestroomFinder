namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("V_User")]
    public partial class V_User
    {
        [Key]
        public int UserId { get; set; }

        [StringLength(6)]
        public string Badge { get; set; }

        public string Name { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string MiddleName { get; set; }

        public string PreferredPhone { get; set; }

        public string JobTitle { get; set; }

        public bool UserActive { get; set; }

        public string UserDescription { get; set; }

        public DateTime? LastLogon { get; set; }

        public bool UserDeviceActive { get; set; }

        public long DeviceId { get; set; }

        public string DeviceGuid { get; set; }

        public string DeviceModel { get; set; }

        public string DeviceOS { get; set; }

        public string DeviceDescription { get; set; }

        public bool DeviceActive { get; set; }

        public int NumberOfActiveDevices { get; set; }



    }
}
