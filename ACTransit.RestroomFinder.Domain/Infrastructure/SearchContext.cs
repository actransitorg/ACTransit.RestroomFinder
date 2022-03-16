using System.Web.Helpers;
using ACTransit.RestroomFinder.Domain.Enums;

namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public class SearchContext
    {
        public int PageNumber { get; set; } = 1;

        public int PageSize { get; set; } = 15;

        public string SortField { get; set; }

        public SortDirection SortDirection { get;  set; } = SortDirection.Ascending;
    }
}