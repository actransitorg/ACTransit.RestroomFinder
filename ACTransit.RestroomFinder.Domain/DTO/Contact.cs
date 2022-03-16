using System;
using System.ComponentModel.DataAnnotations;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class Contact
    {
        public int ContactId { get; set; }

        public string ServiceProvider { get; set; }

        public string Name { get; set; }

        public string Title { get; set; }

        [DataType(DataType.PhoneNumber)]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please provide a valid Phone Number.")]
        public string Phone { get; set; }

        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        public string Address { get; set; }

        public string AddUserId { get; set; }

        public DateTime AddDateTime { get; set; }

        public string UpdUserId { get; set; }

        public DateTime? UpdDateTime { get; set; }
        
        public string Notes { get; set; }
    }
}
