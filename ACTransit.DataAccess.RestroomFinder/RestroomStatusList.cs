namespace ACTransit.DataAccess.RestroomFinder
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("RestroomStatusList")]
    public partial class RestroomStatusList
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public RestroomStatusList()
        {
            Restrooms = new HashSet<Restroom>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int RestroomStatusListId { get; set; }

        [StringLength(50)]
        public string Name { get; set; }

        [StringLength(50)]
        public string Title { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public bool IsDefault { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Restroom> Restrooms { get; set; }
    }
}
