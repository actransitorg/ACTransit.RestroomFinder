using ACTransit.RestroomFinder.Domain.Dto;

namespace ACTransit.RestroomFinder.Web.Models
{
    public class EmployeeViewModel
    {
        public int EmployeeId { get; set; }
        public string Name { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string NtLogin { get; set; }
        public bool Active { get; set; }
        public string Badge { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }

        public static EmployeeViewModel FromModel(Employee employee)
        {
            if (employee == null) return null;

            return new EmployeeViewModel()
            {
                EmployeeId = employee.EmployeeId,
                Name = employee.Name,
                FirstName = employee.FirstName,
                LastName = employee.LastName,
                NtLogin = employee.NtLogin,
                Active = employee.Active,
                Badge = employee.Badge,
                Email = employee.Email,
                Phone =  employee.Phone
            };
        }

    }
}