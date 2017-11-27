using System;
using System.Runtime.Serialization;

namespace RestroomFinderAPI.Models
{

    public class OperatorInfoViewModel: BaseViewModel
    {
        [DataMember(Name = "badge")]
        public string Badge { get; set; }

        [DataMember(Name = "agreed")]
        public bool Agreed { get; set; }

        [DataMember(Name = "incidentDateTime")]
        public DateTime IncidentDateTime { get; set; }

        [DataMember(Name = "validating")]
        public bool Validating { get; set; }
    }
}