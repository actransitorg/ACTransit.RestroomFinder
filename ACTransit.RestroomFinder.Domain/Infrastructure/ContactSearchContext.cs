namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class ContactSearchContext: SearchContext
    {
        public int? ContactId { get; set; }

        public string Name { get; set; }

        public string ServiceProvider { get; set; }

        public string Search { get; set; }
    }
}
