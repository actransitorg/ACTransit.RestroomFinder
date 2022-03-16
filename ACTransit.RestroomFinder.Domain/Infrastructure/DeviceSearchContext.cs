namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class DeviceSearchContext: SearchContext
    {
        public string DeviceGuid { get; set; }

        public string Model { get; set; }

        public string Os { get; set; }

        public bool? Active { get; set; }
    }
}
