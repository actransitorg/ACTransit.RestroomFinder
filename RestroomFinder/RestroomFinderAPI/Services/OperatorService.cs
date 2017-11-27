using System;
using RestroomFinderAPI.Models;
using ACTransit.DataAccess.Employee.Repositories;
using RestroomFinderAPI.Infrastructure;
using ACTransit.DataAccess.RestroomFinder;

namespace RestroomFinderAPI.Services
{
    internal class OperatorService: IDisposable
    {
        private readonly EmployeeRepository _employeeRepository = new EmployeeRepository();
        private readonly RestroomContext _restroomRepository = new RestroomContext();
        internal OperatorInfoViewModel GetOperatorByBadge(string badge)
        {
            var employee = _employeeRepository.GetEmployeeByBadge(badge);
            return Convertor.ToViewModel(employee);
        }

        internal void SaveOperatorAcknowledgementToDisclaimer(string badge, bool agreed, DateTime incidentDateTime)
        {
            var obj = new Confirmation
            {
                Badge = badge,
                Agreed = agreed,
                IncidentDateTime = incidentDateTime
            };
            _restroomRepository.SaveConfirmation(obj);
        }

        public void Dispose()
        {
            _employeeRepository.Dispose();
            _restroomRepository.Dispose();
        }
    }
}
