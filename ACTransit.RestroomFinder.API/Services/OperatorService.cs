using System;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using ACTransit.RestroomFinder.API.Models;
using ACTransit.DataAccess.Employee.Repositories;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Entities.Employee;
using EntityFramework.Extensions;
using Microsoft.Ajax.Utilities;

namespace ACTransit.RestroomFinder.API.Services
{
    [Obsolete("Please use handlers instead.")]
    internal class OperatorService: BaseService
    {
        [Obsolete("Is here for compatibility! Will be removed soon. Please use GetOperatorInfo(string badge, string deviceId) instead.")]
        internal OperatorInfoViewModel GetOperatorByBadge(string badge)
        {
            OperatorInfoViewModel result=null;
            var employee = EmployeeRepository.GetEmployeeByBadge(badge);
            if (employee != null)            
                result = Convertor.ToViewModel(employee);
            return result;
        }


        internal async void InvalidateOperator(string badge)
        {
            await RestroomUnitOfWork.InvalidateOperatorAsync(badge);
        }
        internal async void SaveOperatorAcknowledgementToDisclaimer(string badge, bool agreed, string deviceId, string sessionId, DateTime incidentDateTime)
        {
            InvalidateOperator(badge);
            var obj = new Confirmation
            {
                Badge = badge,
                Agreed = agreed,
                IncidentDateTime = incidentDateTime,
                DeviceId = deviceId,
                Active = true
            };
            await RestroomUnitOfWork.SaveConfirmationAsync(obj);
        }

    }
}
