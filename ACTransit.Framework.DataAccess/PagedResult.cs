using System.Collections.Generic;
using System.Linq;

namespace ACTransit.Framework.DataAccess
{
    public class PagedResult<T> : PagedResultBase where T : class
    {
        public IEnumerable<T> Results { get; set; }

        public PagedResult()
        {
            Results = Enumerable.Empty<T>();
        }
    }
}
