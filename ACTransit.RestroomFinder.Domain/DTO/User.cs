using System;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class User
    {
        public int UserId { get; set; }

        public string Name { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Badge { get; set; }

        public string JobTitle { get; set; }

        public string Location { get; set; }

        public string Phone { get; set; }

        public string Email { get; set; }

        public string Description { get; set; }

        public DateTime? LastLogon { get; set; }

        public string LastLogonDeviceGuid { get; set; }

        public string LastLogonDeviceModel { get; set; }

        public string LastLogonDeviceOS { get; set; }

        public int NumberOfActiveDevices { get; set; }

        public bool Active { get; set; }

        public DateTime AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string AddUserId { get; set; }

        public string UpdUserId { get; set; }
    }
}
