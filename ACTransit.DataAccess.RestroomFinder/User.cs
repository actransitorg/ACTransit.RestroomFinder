namespace ACTransit.DataAccess.RestroomFinder
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("User")]
    public partial class User
    {
        public int UserId { get; set; }

        [Required]
        [StringLength(6)]
        public string Badge { get; set; }

        [StringLength(10)]
        public string SecurityCardFormatted { get; set; }

        [Required]
        [StringLength(50)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(50)]
        public string LastName { get; set; }

        [StringLength(30)]
        public string MiddleName { get; set; }

        public string JobTitle { get; set; }

        public bool Active { get; set; }

        public bool? IsDemo { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        [StringLength(50)]
        public string AddUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AddDateTime { get; set; }

        [StringLength(50)]
        public string UpdUserId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? UpdDateTime { get; set; }

        public ICollection<UserDevice> UserDevices { get; set; }        
    }
}
