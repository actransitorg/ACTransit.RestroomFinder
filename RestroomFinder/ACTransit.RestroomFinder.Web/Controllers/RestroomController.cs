using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Infrastructure.Resolver;
using ACTransit.RestroomFinder.Web.Infrastructure.Serialization;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [RoutePrefix("api/Restroom")]
    public class RestroomController : BaseApiController<RestroomService>
    {
        private readonly Log<BaseApiController<RestroomService>> _log = new Log<BaseApiController<RestroomService>>();

        protected override void RequestInitialize()
        {
            SetSerializationResolver(typeof(RestroomResolver));
        }

        /// <summary>
        /// Retrieve all Restrooms
        /// </summary>
        /// <returns>Array of Restroom objects or empty array if none.</returns>
        [Route("")]
        public IEnumerable<Restroom> Get()
        {
            var result = service.GetAll();
            return result;
        }

        /// <summary>
        /// Retrieve a single Restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <returns>Restroom object or null if none.</returns>
        [Route("{id:int}")]
        [HttpGet]
        public Restroom Get(int id)
        {
            return service.Get(id);
        }

        /// <summary>
        /// Create a new Restroom
        /// </summary>
        /// <param name="item">Restroom object</param>
        /// <returns>New Restroom object, with Url set to resource, or null if failed.</returns>
        [Route("")]
        [HttpPost]
        public HttpResponseMessage Post([FromBody] Restroom item)
        {
            var t = service.Add(item);
            var response = Request.CreateResponse<Restroom>(HttpStatusCode.OK, t);
            response.Headers.Location = new Uri(Request.RequestUri, t.Id.ToString());
            return response;
        }

        /// <summary>
        /// Replace an existing Restroom (idempotent)
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <param name="item">Restroom object</param>
        /// <returns>Updated Restroom object, with Url set to resource, or null if failed.</returns>
        [Route("{id:int}")]
        [ValidationActionFilter]
        public HttpResponseMessage Put(int id, [FromBody] Restroom item)
        {
            var t = service.Update(id, item);
            var response = Request.CreateResponse<Restroom>(HttpStatusCode.OK, t);
            response.Headers.Location = new Uri(Request.RequestUri, t.Id.ToString());
            return response;
        }

        /// <summary>
        /// Delete all Restrooms
        /// </summary>
        [Route("")]
        public void Delete()
        {
            service.DeleteAll();
        }

        /// <summary>
        /// Delete a single Restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        [Route("")]
        public void Delete(int id)
        {
            service.Delete(id);
        }
    }
}