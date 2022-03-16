using System;
using System.Web.Mvc;

using ACTransit.Framework.Logging;
using ACTransit.Framework.Web.Attributes;

namespace ACTransit.RestroomFinder.Web.Controllers.Base
{
    [CustomError]
    public abstract class BaseController : Controller
    {
        protected readonly Logger Logger;

        protected BaseController()
        {
            Logger = new Logger(GetType().Name);
        }

        protected string PrincipalName => User?.Identity?.Name ?? Environment.UserName;

        protected BaseController(string loggerPrefixName)
        {
            Logger = new Logger(loggerPrefixName + GetType().Name);
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }
    }
}