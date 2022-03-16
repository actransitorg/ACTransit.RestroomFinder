using ACTransit.DataAccess.RestroomFinder.Interfaces;
using ACTransit.Framework.Interfaces;
using ACTransit.DataAccess.RestroomFinder.Partials;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class Restroom: RestroomBase, IRestroom,IAuditableEntity//IRestroom, IAuditableEntity
    {
        public decimal? AverageRating { get; set; }
        
        public Contact Contact { get; set; }
        public Contact CleanedContact { get; set; }

        public Contact RepairedContact { get; set; }

        public Contact SuppliedContact { get; set; }

        public Contact SecurityGatesContact { get; set; }

        public Contact SecurityLocksContact { get; set; }

    }
}