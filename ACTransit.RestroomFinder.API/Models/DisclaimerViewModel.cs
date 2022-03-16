using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.API.Models
{
    public class DisclaimerViewModel: BaseViewModel
    {

        [MaxLength(6)]
        public string Badge { get; set; }
        public bool Agreed { get; set; }
        public DateTime IncidentDateTime { get; set; }
        [MaxLength(4000)]
        public string DeviceSessionId { get; set; }
    }
}