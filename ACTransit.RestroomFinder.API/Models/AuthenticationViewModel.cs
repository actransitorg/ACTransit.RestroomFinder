using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace ACTransit.RestroomFinder.API.Models
{

    public class AuthenticationViewModel: BaseViewModel
    {        
        [MaxLength(50)]
        public string FirstName { get; set; }
        [MaxLength(50)]
        public string LastName { get; set; }

        [MaxLength(6)]
        public string Badge { get; set; }

        [MaxLength(25)]
        public string PhoneNumber { get; set; }

        [MaxLength(20)]
        public string Confirm2FACode { get; set; }
        
        public DateTime IncidentDateTime { get; set; }

        public bool CanAddRestroom { get; set; }

        public bool CanEditRestroom{ get; set; }

        [MaxLength(4000)]
        public string DeviceSessionId { get; set; }
        
        public bool SessionApproved{ get; set; }

    }
}