using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using RestroomFinderAPI.Models;
using RestroomFinderAPI.Services;

namespace RestroomFinderAPI.Controllers
{
    public class OperatorController : BaseController
    {
        [ResponseType(typeof(OperatorInfoViewModel))]
        public async Task<IHttpActionResult> PostOperatorInfo(OperatorInfoViewModel operatorInfo)
        {
            if (operatorInfo == null)
                return (IHttpActionResult)NotFound();
            var logService = new LogService();            
            int sanitizedBadge;
            if (string.IsNullOrWhiteSpace(operatorInfo.Badge) || !int.TryParse(operatorInfo.Badge, out sanitizedBadge))
                return BadRequest("Invalid badge number");

            using (var operatorService = new OperatorService())
            {
                var employee = operatorService.GetOperatorByBadge(operatorInfo.Badge.PadLeft(6, '0'));                
                if (employee != null)
                {
                    logService.WriteLog(operatorInfo, "PostOperatorInfo. Employee found.");
                    if (!operatorInfo.Validating)  // just save the confirmation in the database if it is not for validation purposes.
                        operatorService.SaveOperatorAcknowledgementToDisclaimer(employee.Badge, operatorInfo.Agreed, operatorInfo.IncidentDateTime);
                }
                else
                    logService.WriteLog(operatorInfo, "PostOperatorInfo. Employee not found.");
                return employee != null
                    ? Ok(employee)
                    : (IHttpActionResult)NotFound();
            }
        }
    }
}