using System;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

using Newtonsoft.Json;

namespace ACTransit.RestroomFinder.Web.Models
{
    [Table("Restroom")]
    public class UserViewModel
    {
        #region Entity Fields

        [Key]
        public int UserId { get; set; }

        [StringLength(6)]
        [Required(ErrorMessage = "Please enter the badge number")]
        public string Badge { get; set; }

        [StringLength(100)]
        [Required(ErrorMessage = "Please enter the device Id")]
        public string DeviceId { get; set; }

        [StringLength(100)]
        [Required(ErrorMessage = "Please enter the device model")]
        public string DeviceModel { get; set; }

        [StringLength(50)]
        public string DeviceOS { get; set; }


        [StringLength(4000)]
        public string SessionId { get; set; }

        public bool Active { get; set; }
        public bool Deleted { get; set; }

        public DateTime LastLogon { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public DateTime AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string AddUserId { get; set; }

        public string UpdUserId { get; set;}

        #endregion
    }
}