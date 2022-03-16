using System.Threading.Tasks;
using System.Web.Http;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Controllers
{
    public class DisclaimerController : BaseController<DisclaimerHandler>
    {

        // GET: Disclaimer
        public async Task<IHttpActionResult> DisclaimerResponse(DisclaimerViewModel model)
        {
            await Handler.DisclaimerResponse(model);
            return Ok();
        }
    }
}