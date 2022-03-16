using ACTransit.DataAccess.RestroomFinder.Interfaces;
using ACTransit.DataAccess.RestroomFinder.Partials;
using ACTransit.Framework.Interfaces;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class ReviewRestroom : RestroomBase, IRestroom, IAuditableEntity, IHistoryVersion, IRestroomModifier
    {
    }
}
