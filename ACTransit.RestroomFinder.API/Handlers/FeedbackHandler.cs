using System;
using System.Data.Entity;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;
using entity= ACTransit.DataAccess.RestroomFinder;

namespace ACTransit.RestroomFinder.API.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class FeedbackHandler : BaseHandler
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="restroomId"></param>
        /// <param name="startPage"></param>
        /// <param name="numRecords"></param>
        /// <param name="earliestDate"></param>
        /// <returns></returns>
        public async Task<Feedback[]> GetFeedbacksAsync (int restroomId, int? startPage = null, int? numRecords = null, DateTime? earliestDate = null)
        {
            if (!LoggedIn)
            {
                var restroom = await RestroomUnitOfWork.GetRestroomAsync(restroomId);
                if (!restroom.IsPublic)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
            }

            var feedbacks = RestroomUnitOfWork.Get<entity.Feedback>().Where(f => f.RestroomId == restroomId);

            if (earliestDate.HasValue)
                feedbacks = feedbacks.Where(f => f.AddDateTime >= earliestDate.Value);

            if (numRecords.HasValue)
            {
                feedbacks = feedbacks
                    .OrderByDescending(f => f.AddDateTime)
                    .Skip(startPage.GetValueOrDefault() * numRecords.Value)
                    .Take(numRecords.Value);
            }

            var result=await feedbacks.ToListAsync();
            return result.Select(Feedback.FromDataAccess).ToArray();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="feedback"></param>
        /// <returns></returns>
        public async Task<Feedback> SaveFeedbackAsync(Feedback feedback)
        {            
            if (feedback==null)
                throw new FriendlyException(FriendlyExceptionType.InvalidModelState);
            Logger.WriteDebug("Feedback:" + JsonConvert.SerializeObject(feedback));
            if (!LoggedIn)
            {
                var restroom = await RestroomUnitOfWork.GetRestroomAsync(feedback.RestroomId);
                if (!restroom.IsPublic)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
            }
            
            if (LoggedIn && feedback.Badge!= ClaimsPrincipal.Current.Identity.Name)
                throw new UnauthorizedAccessException("You can't post a feedback for someone else.");
            if (feedback.Rating<3 && string.IsNullOrWhiteSpace(feedback.FeedbackText))
                throw new FriendlyException(FriendlyExceptionType.FeedbackTextRequired);
            var result= await RestroomUnitOfWork.SaveFeedbackAsync(feedback.ToDataAccess());
            return Feedback.FromDataAccess(result);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<int> DeleteFeedbackAsync(long id)
        {
            try
            {
                throw new NotImplementedException();
                //return await RestroomUnitOfWork.DeleteFeedbackAsync(id);
            }
            catch (Exception ex)
            {
                Logger.WriteError(ex.Message, ex);
                throw;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="feedbackId"></param>
        /// <returns></returns>
        public bool FeedbackExists(long feedbackId)
        {
            return RestroomUnitOfWork.Get<entity.Feedback>().Any(f => f.FeedbackId == feedbackId);
        }
    }
}