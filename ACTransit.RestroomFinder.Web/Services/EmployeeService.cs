using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Models;

using DomainService = ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Web.Services
{
    public class EmployeeService: ServiceBase<DomainService.EmployeeService>
    {
        public EmployeeService():base(RequestHelper.CurrentUserName,m=>new DomainService.EmployeeService())
        { }
        public EmployeeViewModel GetEmployeeByLogin(string login)
        {
            return EmployeeViewModel.FromModel(Service.GetEmployeeByLogin(login));
        }
    }
}