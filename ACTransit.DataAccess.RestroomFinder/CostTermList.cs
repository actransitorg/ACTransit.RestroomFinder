namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("CostTermList")]
    public partial class CostTermList
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CostTermListId { get; set; }

        [StringLength(50)]
        public string Name { get; set; }
    }
}
