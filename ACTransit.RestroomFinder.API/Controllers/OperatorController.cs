using System;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Models;
using ACTransit.RestroomFinder.API.Services;

namespace ACTransit.RestroomFinder.API.Controllers
{
    [AllowAnonymous]
    [RoutePrefix("api/Operator")]
    [Obsolete("Please use OperatorV2 instead.")]
    public class OperatorController : BaseController<OperatorHandler>
    {
        [ResponseType(typeof(OperatorInfoViewModel))]
        public async Task<IHttpActionResult> PostOperatorInfo(OperatorInfoViewModel operatorInfo)
        {
            if (operatorInfo == null)
                return NotFound();
            var logService = new LogService();
            if (string.IsNullOrWhiteSpace(operatorInfo.Badge) || !int.TryParse(operatorInfo.Badge, out _))
                return BadRequest("Invalid badge number");

            using (var operatorService = new OperatorService())
            {
                var employee = operatorService.GetOperatorByBadge(operatorInfo.Badge.PadLeft(6, '0'));                
                if (employee != null)
                {
                    await logService.WriteLogAsync(operatorInfo, "PostOperatorInfo. Employee found.");
                    if (!operatorInfo.Validating)  // just save the confirmation in the database if it is not for validation purposes.
                        operatorService.SaveOperatorAcknowledgementToDisclaimer(employee.Badge, operatorInfo.Agreed, operatorInfo.DeviceGuid, "",operatorInfo.IncidentDateTime);
                }
                else
                    await logService.WriteLogAsync(operatorInfo, "PostOperatorInfo. Employee not found.");
                return employee != null
                    ? Ok(employee)
                    : (IHttpActionResult)NotFound();
            }
        }
    }
}