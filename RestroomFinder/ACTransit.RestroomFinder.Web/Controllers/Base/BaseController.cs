using ACTransit.Framework.Web.Attributes;
using System.Web.Mvc;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web.Controllers.Base
{
    [CustomError]
    public abstract class BaseController : Controller
    {
        private readonly Log<BaseController> log = new Log<BaseController>();

        protected BaseController() { }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }
    }
}