using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

using System.Data.Entity.Spatial;

using Newtonsoft.Json;

using ACTransit.Framework.Extensions;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class Restroom: RestroomBase
    {
        public string NearestIntersection { get; set; }
        
        public decimal? AverageRating { get; set; }

        /*public bool PendingReview { get; set; } = false;*/

        public DateTime? SysEndTime { get; set; }

        public DateTime? SysStartTime { get; set; }

        public string AddUserId { get; set; }

        public DateTime? AddDateTime { get; set; }

        public string AddUserName { get; set; }

        public string UpdUserId { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string UpdUserName { get; set; }
        

        public IEnumerable<string> SelectedRoutes { get; set; }

        public string FormattedSortedRoutes
        {
            get
            {
                return (ACTRoute != null
                    ? JsonConvert.SerializeObject(ACTRoute.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).OrderByNatural(r => r))
                    : ACTRoute);
            }
        }

        public string SortedRoutes
        {
            get
            {
                return (ACTRoute != null
                    ? string.Join(", ", ACTRoute.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).OrderByNatural(r => r))
                    : ACTRoute);
            }
        }
    }
}
