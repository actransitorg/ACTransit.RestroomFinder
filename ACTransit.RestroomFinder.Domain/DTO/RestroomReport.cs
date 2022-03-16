using System.Collections.Generic;
using X.PagedList;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class RestroomsByDivision 
    {
        public string Division { get; set; }
        public string CurrentVersion { get; set; }
        public List<RestroomsByRoutes> RestroomsByRoutes { get; set; }
    }

    public class RestroomsByRoutes 
    {
        public string Route { get; set; }
        public string DestinationName { get; set; }
        public List<Restroom> Restrooms { get; set; }
    }

    public class RestroomsPrint
    {
        public IPagedList<Restroom> Restrooms { get; set; }
        public List<RestroomsByDivision> RestroomsByDivision { get; set; }
        public List<RestroomsByRoutes> RestroomsByRoutes { get; set; }
    }
}
