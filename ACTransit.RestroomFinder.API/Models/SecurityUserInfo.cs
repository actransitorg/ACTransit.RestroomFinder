using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.API.Models
{
    public class SecurityUserInfo
    {
        //public string DeviceId { get; set; }
        public string DeviceModel { get; set; }
        //public string DeviceName { get; set; }
        //public string Badge { get; set; }
        public DateTime CreationDateTime { get; set; }
        public DateTime Expires { get; set; }
    }
}