using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;


namespace ACTransit.RestroomFinder.API.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/v2/Restrooms")]    
    public class RestroomsV2Controller : BaseController<RestroomHandler>
    {
        //private RestroomContext db = new RestroomContext();

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
        [Route("getbyid")]
        public async Task<IHttpActionResult> GetRestroom(int id)
        {
            Log.Debug("GetRestroom called!");
            Restroom restroom = await Handler.GetRestroomAsync(id);
            if (restroom == null)
                    return NotFound();
            return Ok(restroom);
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
        [ResponseType(typeof(Restroom[]))]
        [Route("get")]
        [AllowAnonymous]
        public async Task<IHttpActionResult> GetRestrooms(string routeAlpha, string direction, float? lat, float? longt, int? distance = null)
        {            
            Log.Debug("GetRestrooms called!");
            var result= await Handler.GetRestroomsNearbyAsync(routeAlpha, direction, lat, longt, distance,true);
            return Ok(result);
        }
        [ResponseType(typeof(Restroom[]))]
        [Route("getActRestrooms")]
        [HttpGet]
        public async Task<IHttpActionResult> GetActRestrooms(string routeAlpha, string direction, float? lat, float? longt, int? distance = null, bool pending=false)
        {
            //ActionContext.RequestContext.Principal.
            
            Log.Debug("GetRestrooms called!");
            var result = await Handler.GetRestroomsNearbyAsync(routeAlpha, direction, lat, longt, distance,false, pending);
            return Ok(result);
        }
        [ResponseType(typeof(Restroom[]))]
        [Route("getNewPendingActRestrooms")]
        [HttpGet]
        public async Task<IHttpActionResult> GetNewPendingActRestrooms(string routeAlpha, string direction, float? lat, float? longt, int? distance = null)
        {
            //ActionContext.RequestContext.Principal.

            Log.Debug("GetRestrooms called!");
            var result1 = await Handler.GetRestroomsNearbyAsync(routeAlpha, direction, lat, longt, distance, false, false);
            var result2 = await Handler.GetRestroomsNearbyAsync(routeAlpha, direction, lat, longt, distance, false, true);
            //var result = result2.Where(m => result1.Contains(m, m1 => m1.RestroomId == m.RestroomId) );
            var result = result2.Where(m => !result1.Contains(m, new GenericComparer<Restroom>((r1, r2) => r1.RestroomId == r2.RestroomId)));
            return Ok(result);
        }


        [ResponseType(typeof(Restroom))]
        [Route("post")]
        [HttpPost]
        [AllowAnonymous]
        public async Task<IHttpActionResult> PostRestroom(Restroom restroom)
        {

            if (!ModelState.IsValid)
            {
                Log.Warn("Model state is invalid in PostRestroom");
                return BadRequest(ModelState);
            }
            Log.Debug("Before SaveRestroomAsync for public.");
            restroom.IsPublic = true;
            var result = await Handler.SaveRestroomAsync(restroom);
            Log.Debug("After SaveRestroomAsync for public.");

            return Ok(result);
        }

        [ResponseType(typeof(Restroom))]
        [Route("postActRestroom")]
        public async Task<IHttpActionResult> PostActRestroom(Restroom restroom)
        {
            Log.Debug("restroom:" + JsonConvert.SerializeObject(restroom));
            if (User==null)
                return Unauthorized();
            var claimIdentity = User.Identity as ClaimsIdentity;
            var jobTitle = claimIdentity?.Claims?.Where(m => m.Type == "JobTitle").FirstOrDefault()?.Value;
            var edit = restroom.RestroomId > 0;

            if (jobTitle==null)
                return Unauthorized();
            if (edit && !Config.JobTitlesAccessToEditRestroom.Any(m => m == jobTitle))
                return Unauthorized();
            if (!edit && !Config.JobTitlesAccessToAddRestroom.Any(m => m == jobTitle))
                return Unauthorized();

            if (!ModelState.IsValid)
            {
                Log.Warn("Model state is invalid PostActRestroom");
                return BadRequest(ModelState);
            }

            Log.Debug("Before SaveRestroomAsync for ACTransit");
            var result = await Handler.SaveRestroomAsync(restroom);
            Log.Debug("After SaveRestroomAsync for ACTransit");

            return Ok(result);
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

    }



    public class GenericComparer<T> : IEqualityComparer<T> where T:class
    {
        private Func<T,T, bool> _predicate;
        public GenericComparer(Func<T,T, bool> predicate) 
        {
            this._predicate = predicate;
        }
        public bool Equals(T x, T y)
        {
            //If both object refernces are equal then return true
            if (object.ReferenceEquals(x, y))
                return true;
            if (x is null || y is null)             //If one of the object refernce is null then return false
                return false;

            return this._predicate(x, y);
        }

        public int GetHashCode(T obj)
        {
            //If obj is null then return 0
            if (obj is null)
                return 0;

            return obj.GetHashCode();
            //int IDHashCode = obj.ID.GetHashCode();
            //int NameHashCode = obj.Name == null ? 0 : obj.Name.GetHashCode();
            //int TotalMarksHashCode = obj.TotalMarks.GetHashCode();

            //return IDHashCode ^ NameHashCode ^ TotalMarksHashCode;
        }
    }
}