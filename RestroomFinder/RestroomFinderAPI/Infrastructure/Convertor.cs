using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ACTransit.Entities.Employee;
using RestroomFinderAPI.Models;

namespace RestroomFinderAPI.Infrastructure
{
    public static class Convertor
    {
        public static OperatorInfoViewModel ToViewModel(Employee employee)
        {
            if (employee == null) return null;
            return new OperatorInfoViewModel
            {
                Badge = employee.Badge
            };
        }
    }
}