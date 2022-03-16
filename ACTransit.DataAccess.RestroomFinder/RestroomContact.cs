using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using ACTransit.Framework.Interfaces;

namespace ACTransit.DataAccess.RestroomFinder
{
    [Table("RestroomContact")]
    public partial class RestroomContact
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public RestroomContact()
        {
        }
        [Key]
        public int ContactId { get; set; }
        public string ServiceProvider { get; set; }
        public string ContactName { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public bool HasRestroom { get; set; }
        public string Notes { get; set; }
    }
}
