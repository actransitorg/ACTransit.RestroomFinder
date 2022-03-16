using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace ACTransit.RestroomFinder.API.Models
{

    public class OperatorInfoViewModel: BaseViewModel
    {        
        [MaxLength(50)]
        public string FirstName { get; set; }
        [MaxLength(50)]
        public string LastName { get; set; }

        [MaxLength(6)]
        public string Badge { get; set; }

        //[MaxLength(25)]
        //public string CardNumber { get; set; }L

        public bool Agreed { get; set; }
        
        public DateTime IncidentDateTime { get; set; }
        
        public bool Validating { get; set; }

        [MaxLength(4000)]
        public string DeviceSessionId { get; set; }
        
        public bool SessionApproved{ get; set; }

    }
}