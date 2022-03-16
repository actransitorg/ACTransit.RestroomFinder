using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Handlers;

namespace ACTransit.RestroomFinder.API.Controllers
{    
    //[VersionedRoute("api/v2/Feedback",2)]
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/v2/Feedback")]    
    [Route]
    public class FeedbackV2Controller : BaseController<FeedbackHandler>
    {

        /// <summary>
        /// Gets feedback for a given restroom
        /// </summary>
        /// <param name="restroomId">Restroom Id</param>
        /// <param name="startPage">Start page where the search should begin at</param>
        /// <param name="numRecords">Max number of records to be returned from the search</param>
        /// <returns>Collection of feedback objects</returns>
        [ResponseType(typeof(Models.Feedback))]
        [Route("get")]
        public async Task<IHttpActionResult> Get(int restroomId, int? startPage = 0, int? numRecords = 25)
        {
            var feedbacks = await Handler.GetFeedbacksAsync(restroomId, startPage: startPage, numRecords: numRecords);

            return feedbacks != null && feedbacks.Any()
                ? Ok(feedbacks)
                : (IHttpActionResult)NotFound();
        }

        /// <summary>
        /// Gets one week worth of feedback for a given restroom
        /// </summary>
        /// <param name="restroomId">Restroom Id</param>
        /// <returns>Collection of feedback objects</returns>
        [HttpGet]
        [ResponseType(typeof(Models.Feedback))]
        [Route("lastWeek")]
        public async Task<IHttpActionResult> GetLastWeek(int restroomId)
        {
            var lastDate = DateTime.Now.AddDays(-7);
            var feedbacks = await Handler.GetFeedbacksAsync(restroomId, earliestDate: lastDate);

            return feedbacks != null && feedbacks.Any()
                ? Ok(feedbacks)
                : (IHttpActionResult)NotFound();
        }

        /// <summary>
        /// Gets one month worth of feedback for a given restroom
        /// </summary>
        /// <param name="restroomId">Restroom Id</param>
        /// <returns>Collection of feedback objects</returns>
        [HttpGet]
        [ResponseType(typeof(Models.Feedback))]
        [Route("lastMonth")]
        public async Task<IHttpActionResult> GetLastMonth(int restroomId)
        {
            var lastDate = DateTime.Now.AddMonths(-1);
            var feedbacks = await Handler.GetFeedbacksAsync(restroomId, earliestDate: lastDate);

            return feedbacks != null && feedbacks.Any()
                ? Ok(feedbacks)
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
        [Route("put")]
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

            var _ = await Handler.SaveFeedbackAsync(feedback);

            return StatusCode(HttpStatusCode.NoContent);
        }

        /// <summary>
        /// Deletes all feedback available for a given restroom
        /// </summary>
        /// <param name="id">Restroom Id</param>
        /// <returns></returns>
        /// 
        // DELETE: api/Feedback/5
        [Route("delete")]
        public async Task<IHttpActionResult> DeleteFeedback(short id)
        {
            await Handler.DeleteFeedbackAsync(id);
            return StatusCode(HttpStatusCode.NoContent);
        }


        /// <summary>
        /// Creates feedback for a given restroom
        /// </summary>
        /// <param name="feedback">Feedback object</param>
        /// <returns>New feedback object created</returns>
        /// 
        // POST: api/Feedback
        [ResponseType(typeof(Models.Feedback))]
        [Route("post")]
        public async Task<IHttpActionResult> PostFeedback(Models.Feedback feedback)
        {
            Log.Debug("Feedback:" + JsonConvert.SerializeObject(feedback));
            if (!ModelState.IsValid)
            {
                Log.Warn("Model state is invalid");
                return BadRequest(ModelState);
            }

            Log.Debug("Before SaveFeedback");
            var result = await Handler.SaveFeedbackAsync(feedback);
            Log.Debug("After SaveFeedback");

            return Ok(result);
        }

        /// <summary>
        /// Verifies if a given feedback Id already exists
        /// </summary>
        /// <param name="feedbackId">Feedback object co</param>
        /// <returns>true if it exists or false otherwise</returns>
        /// 
        [HttpGet]
        [Route("exists")]
        public bool FeedbackExists(int feedbackId)
        {
            return Handler.FeedbackExists(feedbackId);
        }

        //private async Task<IEnumerable<Models.Feedback>> GetFeedbacks(int restroomId, int? startPage = null, int? numRecords = null, DateTime? earliestDate = null)
        //{
        //    return await Handler.GetFeedbacksAsync(restroomId, startPage, numRecords, earliestDate);
        //}
    }

}
