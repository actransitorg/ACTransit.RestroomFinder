using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ACTransit.DataAccess.RestroomFinder;

namespace RestroomFinderAPI.Controllers
{
    public class FeedbackController : BaseController
    {
        private RestroomContext db = new RestroomContext();


        /// <summary>
        /// Gets feedback for a given restroom
        /// </summary>
        /// <param name="restStopID">Restroom Id</param>
        /// <param name="startPage">Start page where the search should begin at</param>
        /// <param name="numRecords">Max number of records to be returned from the search</param>
        /// <returns>Collection of feedback objects</returns>
        [ResponseType(typeof(Models.Feedback))]
        public async Task<IHttpActionResult> Get(int restStopID, int? startPage = 0, int? numRecords = 25)
        {
            var feedback = GetFeedback(restStopID: restStopID, startPage: startPage, numRecords: numRecords);

            return feedback.Any()
                ? Ok(feedback)
                : (IHttpActionResult)NotFound();
        }

        /// <summary>
        /// Gets one week worth of feedback for a given restroom
        /// </summary>
        /// <param name="restStopId">Restroom Id</param>
        /// <returns>Collection of feedback objects</returns>
        [HttpGet]
        [Route("api/feedback/lastweek")]
        [ResponseType(typeof(Models.Feedback))]
        public async Task<IHttpActionResult> GetLastWeek(int restStopId)
        {
            var lastDate = DateTime.Now.AddDays(-7);
            var feedback = GetFeedback(restStopID: restStopId, earliestDate: lastDate);

            return feedback.Any()
                ? Ok(feedback)
                : (IHttpActionResult)NotFound();
        }

        /// <summary>
        /// Gets one month worth of feedback for a given restroom
        /// </summary>
        /// <param name="restStopId">Restroom Id</param>
        /// <returns>Collection of feedback objects</returns>
        [HttpGet]
        [Route("api/feedback/lastmonth")]
        [ResponseType(typeof(Models.Feedback))]
        public async Task<IHttpActionResult> GetLastMonth(int restStopId)
        {
            var lastDate = DateTime.Now.AddMonths(-1);
            var feedback = GetFeedback(restStopID: restStopId, earliestDate: lastDate);

            return feedback.Any()
                ? Ok(feedback)
                : (IHttpActionResult)NotFound();
        }

        /// <summary>
        /// Updates feedback for a given restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <param name="feedback">Feedback object</param>
        /// <returns></returns>
        /// 
        // PUT: api/Feedback/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutFeedback(short id, Models.Feedback feedback)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != feedback.FeedbackId)
            {
                return BadRequest();
            }

            var result = db.SaveFeedback(feedback.ToDataAccess());

            return StatusCode(HttpStatusCode.NoContent);
        }

        /// <summary>
        /// Deletes all feedback available for a given restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <returns></returns>
        /// 
        // DELETE: api/Feedback/5
        [ResponseType(typeof(Feedback))]
        public async Task<IHttpActionResult> DeleteFeedback(short id)
        {
            Feedback Feedback = await db.Feedback.FindAsync(id);
            if (Feedback == null)
            {
                return NotFound();
            }

            db.Feedback.Remove(Feedback);
            await db.SaveChangesAsync();

            return Ok(Feedback);
        }


        /// <summary>
        /// Creates feedback for a given restroom
        /// </summary>
        /// <param name="feedback">Feedback object</param>
        /// <returns>New feedback object created</returns>
        /// 
        // POST: api/Feedback
        [ResponseType(typeof(Models.Feedback))]
        public async Task<IHttpActionResult> PostFeedback(Models.Feedback feedback)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = db.SaveFeedback(feedback.ToDataAccess());

            return CreatedAtRoute("DefaultApi", new { id = feedback.FeedbackId }, result);
        }

        /// <summary>
        /// Verifies if a given feedback Id already exists
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <param name="feedback">Feedback object co</param>
        /// <returns>true if it exists or false otherwise</returns>
        /// 
        [HttpPost]
        [Route("api/feedback/exists")]
        public bool FeedbackExists(int feedbackId)
        {
            return db.Feedback.Any(f => f.FeedbackId == feedbackId);
        }

        private IEnumerable<Models.Feedback> GetFeedback(int restStopID, int? startPage = null, int? numRecords = null, DateTime? earliestDate = null)
        {
            var feedback = db.Feedback.Where(f => f.RestroomId == restStopID);

            if (earliestDate.HasValue)
                feedback = feedback.Where(f => f.AddDateTime >= earliestDate.Value);

            if (numRecords.HasValue)
            {
                feedback = feedback
                    .OrderByDescending(f => f.AddDateTime)
                    .Skip(startPage.GetValueOrDefault() * numRecords.Value)
                    .Take(numRecords.Value);
            }

            return feedback.ToList().Select(Models.Feedback.FromDataAccess);
        }

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
