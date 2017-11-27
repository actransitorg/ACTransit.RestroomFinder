using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Domain.Repository
{
    public class RestroomRepository : DomainRepositoryBase<Restroom>
    {
        public RestroomRepository(RequestContext requestContext) : base(requestContext) { }

        public RestroomRepository() {}
    }
}
