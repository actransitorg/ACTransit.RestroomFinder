using System.Configuration;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ACTransit.Framework.Logging;
using ACTransit.Framework.Notification;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/v2/Authentication")]
    public class AuthenticationController : BaseController<AuthenticationHandler>
    {

        //public string Get()
        //{
        //    var smsSection = ConfigurationManager.GetSection("SMS") as SmsSection;
            
        //    if (smsSection == null)
        //        return "SmsSection is null!";
        //    else 
        //        return smsSection.Name??"name is null";
        //}
        /// <summary>
        /// 
        /// </summary>
        /// <param name="authModel"></param>
        /// <returns></returns>
        [ResponseType(typeof(AuthenticationViewModel))]
        [Route("send")]
        [HttpPost]
        public async Task<IHttpActionResult> SendSecurityCode(AuthenticationViewModel authModel)
        {
            Log.Debug("SendSecurityCode called.");
            if (!ModelState.IsValid)
            {
                Log.Debug("Invalid Model State.");
                return BadRequest("Invalid parameters sent.");
            }

            if (authModel == null)
            {
                Log.Debug("Model is null!");
                return NotFound();
            }

            if (string.IsNullOrWhiteSpace(authModel.Badge) || !int.TryParse(authModel.Badge, out _))
            {
                Log.Debug($"Invalid Badge. Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid badge number.");
            }

            if (string.IsNullOrWhiteSpace(authModel.DeviceGuid))
            {
                Log.Debug($"Invalid Device Id. DeviceGuid: ${authModel.DeviceGuid}, Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid Device Id.");
            }

            if (string.IsNullOrWhiteSpace(authModel.PhoneNumber))
            {
                Log.Debug($"Invalid Phone Number. PhoneNumber: ${authModel.PhoneNumber}, Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid Phone Number.");
            }
                


            var result = await Handler.SendSecurityCode(authModel);
            
            return Ok(new BoolModel(result));

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="authModel"></param>
        /// <returns></returns>
        [ResponseType(typeof(AuthenticationViewModel))]
        [Route("validateSecurityCode")]
        [HttpPost]
        public async Task<IHttpActionResult> ValidateSecurityCode(AuthenticationViewModel authModel)
        {
            Log.Debug("ValidateSecurityCode called.");
            if (!ModelState.IsValid)
            {
                Log.Debug("Invalid Model State.");
                return BadRequest("Invalid parameters sent.");
            }

            if (authModel == null)
            {
                Log.Debug("Model is null!");
                return NotFound();
            }

            if (string.IsNullOrWhiteSpace(authModel.Badge) || !int.TryParse(authModel.Badge, out _))
            {
                Log.Debug($"Invalid Badge. Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid badge number.");
            }

            if (string.IsNullOrWhiteSpace(authModel.DeviceGuid))
            {
                Log.Debug($"Invalid Device Id. DeviceGuid: ${authModel.DeviceGuid}, Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid Device Id.");
            }

            if (string.IsNullOrWhiteSpace(authModel.Confirm2FACode))
            {
                Log.Debug($"Invalid Security Code. SecurityCode: ${authModel.Confirm2FACode}, Badge: ${authModel.Badge}, FirstName: ${authModel.FirstName}, LastName: ${authModel.LastName}");
                return BadRequest("Invalid Security Code.");
            }
            
            authModel = await Handler.ValidateSecurityCode(authModel);

            return authModel != null
                ? Ok(authModel)
                : (IHttpActionResult)Unauthorized();

        }

        [ResponseType(typeof(AuthenticationViewModel))]
        [Route("authenticate")]
        [HttpPost]
        public async Task<IHttpActionResult> Authenticate(AuthenticationViewModel authModel)
        {
            if (!ModelState.IsValid)
                return BadRequest("Invalid Model State.");

            if (authModel == null)
                return NotFound();
            if (string.IsNullOrWhiteSpace(authModel.Badge) || !int.TryParse(authModel.Badge, out _))
                return BadRequest("Invalid badge number.");
            if (string.IsNullOrWhiteSpace(authModel.DeviceGuid))
                return BadRequest("Invalid Device Id.");


            authModel = await Handler.Authenticate(authModel);

            return authModel != null
                ? Ok(authModel)
                : (IHttpActionResult)Unauthorized();

        }
        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="authModel"></param>
        ///// <returns></returns>
        //[ResponseType(typeof(OperatorInfoViewModel))]
        //[Route()]
        //public async Task<IHttpActionResult> CancelSecurityCode(AuthenticationViewModel authModel)
        //{
        //    //if (!ModelState.IsValid)
        //    //    return BadRequest("Invalid Model State.");

        //    //if (operatorInfo == null)
        //    //    return NotFound();
        //    //if (string.IsNullOrWhiteSpace(operatorInfo.Badge) || !int.TryParse(operatorInfo.Badge, out _))
        //    //    return BadRequest("Invalid badge number.");
        //    //if (string.IsNullOrWhiteSpace(operatorInfo.DeviceGuid))
        //    //    return BadRequest("Invalid Device Id.");
        //    //if (string.IsNullOrWhiteSpace(operatorInfo.CardNumber))
        //    //    return BadRequest("Invalid Card Number.");


        //    //operatorInfo = await Handler.GetOperatorInfoAsync(operatorInfo);

        //    return authModel != null
        //        ? Ok(true)
        //        : (IHttpActionResult)NotFound();

        //}


    }
}