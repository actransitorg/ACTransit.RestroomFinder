namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class UserSearchContext: SearchContext
    {
        public string Badge { get; set; }

        public bool? Active { get; set; }
    }
}
