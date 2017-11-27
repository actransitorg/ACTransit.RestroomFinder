using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace RestroomFinderAPI.Models
{
    [DataContract(Name = "Version")]
    public class VersionModel
    {
        [DataMember(Name="version")]
        public string Version { get; set; }
        [DataMember(Name = "date")]
        public DateTime Date { get; set; }
        [DataMember(Name = "url")]
        public string Url { get; set; }
        [DataMember(Name = "applicationType")]
        public string ApplicationType { get; set; }

        [DataMember(Name = "fileName")]
        public string FileName { get; set; }

    }
}