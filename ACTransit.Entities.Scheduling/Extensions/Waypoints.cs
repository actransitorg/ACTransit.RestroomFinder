using System.ComponentModel.DataAnnotations;

namespace ACTransit.Entities.Scheduling
{

    [MetadataType(typeof(WaypointsMeta))]
    public partial class Waypoints
    {
    }

    public partial class WaypointsMeta
    {
        [Key]
        public long WaypointsId { get; set; }
    }
}