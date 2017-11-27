using System.Web.Mvc;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    public class ErrorController : BaseController
    {
        private readonly Log<ErrorController> log = new Log<ErrorController>();

        public ErrorController() { }

        //
        // GET: /KPI/Error/
        public ActionResult Index()
        {
            log.Debug("Called.");
            return View();
        }

        public ActionResult NotFound(string aspxerrorpath)
        {
            log.Debug("Called.");
            ViewBag.Message = aspxerrorpath;
            return View("NotFound");
        }
    }
}