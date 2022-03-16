using System;

namespace ACTransit.RestroomFinder.Domain.Dto
{
    public class UserDevice
    {
        public int EmployeeId { get; set; }

        public string Name { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string NtLogin { get; set; }

        public string JobTitle { get; set; }

        public bool Active { get; set; }

        public bool DeviceActive { get; set; }

        public bool CanUse { get; set; }

        public string Badge { get; set; }

        public string Email { get; set; }

        public string Phone { get; set; }

        public int UserId { get; set; }

        public long DeviceId{ get; set; }

        public string DeviceGuid { get; set; }

        public string DeviceModel { get; set; }

        public string DeviceOS { get; set; }

        public string DeviceSessionId { get; set; }        

        public DateTime? LastLogon { get; set; }

        public string Description { get; set; }

        public DateTime AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string AddUserId { get; set; }

        public string UpdUserId { get; set; }
    }
}