using System;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class Device
    {
        public bool Active { get; set; }

        public long DeviceId{ get; set; }

        public string DeviceGuid { get; set; }

        public string DeviceModel { get; set; }

        public string DeviceOS { get; set; }

        public string DeviceSessionId { get; set; }        

        public DateTime? LastUsed { get; set; }
        
        public string Description { get; set; }

        public DateTime AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string AddUserId { get; set; }

        public string UpdUserId { get; set; }
    }
}
