using System.Runtime.Serialization;

namespace ACTransit.RestroomFinder.API.Models
{    
    /// <summary>
    /// 
    /// </summary>
    public class BaseViewModel
    {
        
        /// <summary>
        /// 
        /// </summary>
        public string DeviceGuid { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string DeviceName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string DeviceModel { get; set; }

        /// <summary>
        /// 
        /// </summary>        
        public string DeviceOS { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SystemName { get; set; }

        /// <summary>
        /// 
        /// </summary>        
        public string SystemVersion { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string LocalizedModel { get; set; }

        /// <summary>
        /// 
        /// </summary>        
        public string BatteryLevel { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BatteryState { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentLatitude { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentLongtitude { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentAltitude { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentSpeed { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentHorizontalAccuracy { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public decimal CurrentVerticalAccuracy { get; set; }

    }
}