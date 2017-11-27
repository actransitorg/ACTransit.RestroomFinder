﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ACTransit.RestroomFinder.Web.Controllers.Base;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    public class MockLayoutController : Controller
    {
        [HttpGet]
        public ActionResult RestroomView()
        {
            return View();
        }
    }
}