using System.Runtime.Serialization;

namespace RestroomFinderAPI.Models
{
    [DataContract()]
    public class BaseViewModel
    {
        [DataMember(Name = "deviceId")]
        public string DeviceId { get; set; }

        [DataMember(Name = "deviceName")]
        public string DeviceName { get; set; }

        [DataMember(Name = "deviceModel")]
        public string DeviceModel { get; set; }

        [DataMember(Name = "deviceOS")]
        public string DeviceOS { get; set; }

        [DataMember(Name = "systemName")]
        public string SystemName { get; set; }

        [DataMember(Name = "systemVersion")]
        public string SystemVersion { get; set; }

        [DataMember(Name = "localizedModel")]
        public string LocalizedModel { get; set; }

        [DataMember(Name = "batteryLevel")]
        public string BatteryLevel { get; set; }

        [DataMember(Name = "batteryState")]
        public string BatteryState { get; set; }

        [DataMember(Name = "currentLatitude")]
        public decimal CurrentLatitude { get; set; }

        [DataMember(Name = "currentLongtitude")]
        public decimal CurrentLongtitude { get; set; }

        [DataMember(Name = "currentAltitude")]
        public decimal CurrentAltitude { get; set; }

        [DataMember(Name = "currentSpeed")]
        public decimal CurrentSpeed { get; set; }

        [DataMember(Name = "currentHorizontalAccuracy")]
        public decimal CurrentHorizontalAccuracy { get; set; }

        [DataMember(Name = "currentVerticalAccuracy")]
        public decimal CurrentVerticalAccuracy { get; set; }

    }
}