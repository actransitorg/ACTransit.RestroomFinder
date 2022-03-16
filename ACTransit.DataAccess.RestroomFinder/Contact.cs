namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("Contact")]
    public partial class Contact
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Contact()
        {
        }

        public int ContactId { get; set; }
        [Required]
        [StringLength(100)]
        public string ServiceProvider { get; set; }

        [Required]
        [StringLength(100)]
        public string ContactName { get; set; }

        [StringLength(100)]
        public string Title { get; set; }

        [StringLength(50)]
        public string Phone { get; set; }

        [StringLength(50)]
        public string Email { get; set; }

        [StringLength(100)]
        public string Address { get; set; }

        public bool Deleted { get; set; }

        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        public string Notes { get; set; }
    }
}
