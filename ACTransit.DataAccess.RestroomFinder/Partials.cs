using System.ComponentModel.DataAnnotations.Schema;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class Restroom:IModel
    {        
        public decimal? AverageRating { get; set; }

        [NotMapped]
        public int Id
        {
            get { return RestroomId; }
            set { RestroomId = value; }
        }
    }
}
