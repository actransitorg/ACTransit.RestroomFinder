using System;
using System.ComponentModel.DataAnnotations;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class RestroomContact
    {
        public int ContactId { get; set; }

        public string ServiceProvider { get; set; }

        public string Name { get; set; }

        public string Title { get; set; }

        [DataType(DataType.PhoneNumber)]
        [RegularExpression(@"^([0-9]{10})$", ErrorMessage = "Phone Number must be 10 Digits long.")]
        public string Phone { get; set; }

        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        public string Address { get; set; }

        public bool HasRestroom { get; set; }

        public string Notes { get; set; }
    }
}
