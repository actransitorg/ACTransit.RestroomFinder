using System;
using System.Runtime.Serialization;

namespace ACTransit.RestroomFinder.API.Models
{

    /// <summary>
    /// 
    /// </summary>
    public class UserViewModel: BaseViewModel
    {
        /// <summary>
        /// 
        /// </summary>
        public int UserId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Badge { get; set; }        

        /// <summary>
        /// 
        /// </summary>
        public string SessionId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool? Active { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool Deleted { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime LastLogon { get; set; }

     

    }
}