﻿using System.Web.Mvc;

using ACTransit.RestroomFinder.Web.Controllers.Base;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}