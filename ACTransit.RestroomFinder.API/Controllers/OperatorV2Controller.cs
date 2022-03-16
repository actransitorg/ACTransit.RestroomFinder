using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/v2/Operator")]
    public class OperatorV2Controller : BaseController<OperatorHandler>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="operatorInfo"></param>
        /// <returns></returns>
        [ResponseType(typeof(OperatorInfoViewModel))]
        [Route()]
        public async Task<IHttpActionResult> PostOperatorInfo(OperatorInfoViewModel operatorInfo)
        {
            if (!ModelState.IsValid)
                return BadRequest("Invalid Model State.");

            if (operatorInfo == null)
                return NotFound();
            if (string.IsNullOrWhiteSpace(operatorInfo.Badge) || !int.TryParse(operatorInfo.Badge, out _))
                return BadRequest("Invalid badge number.");
            if (string.IsNullOrWhiteSpace(operatorInfo.DeviceGuid))
                return BadRequest("Invalid Device Id.");
            //if (string.IsNullOrWhiteSpace(operatorInfo.CardNumber))
            //    return BadRequest("Invalid Card Number.");


            operatorInfo = await Handler.GetOperatorInfoAsync(operatorInfo);

            return operatorInfo != null
                    ? Ok(operatorInfo)
                    : (IHttpActionResult)NotFound();
            
        }
     


    }
}