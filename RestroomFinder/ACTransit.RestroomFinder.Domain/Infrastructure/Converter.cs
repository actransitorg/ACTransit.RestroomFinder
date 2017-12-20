using DB = ACTransit.Entities.Employee;

namespace ACTransit.RestroomFinder.Domain.Infrastructure
{
    public static class Converter
    {
        public static Dto.Employee ToModel(DB.Employee employee)
        {
            if (employee == null) return null;

            return new Dto.Employee()
            {
                EmployeeId = employee.Emp_Id,
                Name = employee.Name,
                FirstName = employee.FirstName,
                LastName = employee.LastName,
                NtLogin = employee.NTLogin,
                Active = employee.Empl_Status == "A",
                Badge = employee.Badge,
                Email = employee.EmailAddress,
                Phone = employee.WorkPhone
            };
        }
    }
}
