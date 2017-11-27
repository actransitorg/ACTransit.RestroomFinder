using System;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ACTransit.DataAccess.RestroomFinder;
using RestroomFinderAPI.Infrastructure;
using RestroomFinderAPI.Services;

namespace RestroomFinderAPI.Controllers
{
    //[CustomError]
    public class RestroomsController : BaseController
    {
        private RestroomContext db = new RestroomContext();

        // GET: api/RestStops
//        public IQueryable<Restroom> GetRestrooms()
//        {
//            return db.Restrooms;
//        }

        
        /// <summary>
        /// Returns information for a given restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <returns>Restroom object</returns>
        // GET: api/RestStops/5
        [ResponseType(typeof(Restroom))]
        [Route("api/RestStops/{id}")]
        public async Task<IHttpActionResult> GetRestroom(short id)
        {
            Restroom restStop = db.GetRestStop(id);
            if (restStop == null)
            {
                return NotFound();
            }

            return Ok(Models.Restroom.FromDataAccess(restStop));
        }

        /// <summary>
        /// Returns a list of restrooms that are near a given location
        /// </summary>
        /// <param name="routeAlpha">Bus route</param>
        /// <param name="direction">Bus direction (currently not used)</param>
        /// <param name="lat">Latitude of current location</param>
        /// <param name="longt">Longitude of current location</param>
        /// <param name="distance">Search radius in meters</param>
        /// <returns>Collection of Restroom objects</returns>
        [ResponseType(typeof(Models.Restroom))]
        public IQueryable<Models.Restroom> GetRestrooms(string routeAlpha, string direction, float lat, float longt, int? distance = null)
        {
            var result= db.GetRestroomsNearby(routeAlpha, direction, lat, longt, distance).Select(r => Models.Restroom.FromDataAccess(r));
            //var result1= result.ToList();
            return result;
        }


        //[ResponseType(typeof(Models.Restroom))]
        //public IQueryable<Models.Restroom> GetRestStopsByBadge(string badgeNumber, float? lat = null, float? longt = null, int? distance = null)
        //{
        //    int sanitizedBadge;
        //    if (!int.TryParse(badgeNumber, out sanitizedBadge))
        //        throw new HttpRequestException("Invalid badge number");

        //    var operatorService = new OperatorService();
        //    var driver = operatorService.GetOperatorByBadge(sanitizedBadge);

        //    if (driver == null)
        //        throw new HttpRequestException("Invalid badge number");

        //    return GetRestStops(driver.CurrentRoute, driver.DirectionCodeId.ToString(), lat ?? (float)driver.LastKnownLatitude, longt ?? (float)driver.LastKnownLongitude, distance);
        //}
        
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}