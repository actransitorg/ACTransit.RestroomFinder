using ACTransit.Entities.Scheduling;
using System.Collections.Generic;

namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class RestroomSearchContext: SearchContext
    {
        public string Name { get; set; }

        public string LabelId { get; set; }

        public string Address { get; set; }

        public string City { get; set; }

        public int? StatusId { get; set; }

        public bool? Public { get; set; }

        public bool? HasToilet { get; set; }

        public bool? PendingReview { get; set; }

        public IEnumerable<string> Routes { get; set; }
    }
}
