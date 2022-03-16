using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ACTransit.Entities.Employee;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Infrastructure
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