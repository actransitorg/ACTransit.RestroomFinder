using ACTransit.DataAccess.RestroomFinder.Interfaces;
using ACTransit.DataAccess.RestroomFinder.Partials;
using ACTransit.Framework.Interfaces;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class ApprovedRestroom: RestroomBase, IRestroom, IAuditableEntity, IRestroomModifier
    {
    }
}
