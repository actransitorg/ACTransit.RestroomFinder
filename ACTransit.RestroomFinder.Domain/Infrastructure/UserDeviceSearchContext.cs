namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class UserDeviceSearchContext: SearchContext
    {
        public string Badge { get; set; }

        public string Model { get; set; }

        public string Os { get; set; }

        public bool? Active { get; set; }
    }
}
