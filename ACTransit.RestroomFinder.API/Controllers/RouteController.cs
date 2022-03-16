using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ACTransit.RestroomFinder.API.Controllers
{
    public class RouteController : ApiController
    {
        private RestroomContext db = new RestroomContext();

        public IQueryable<RestStop> GetRoutes()
        {
            return db.rou;
        }
    }
}
