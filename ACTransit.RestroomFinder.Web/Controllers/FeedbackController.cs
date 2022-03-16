using System;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;

using ACTransit.RestroomFinder.Web.Models;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class FeedbackController : BaseController
    {

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenFeedbackEditor })]
        public ActionResult Create(int? restroomId)
        {
            try
            {
                var restroomModel = new RestroomViewModel();
                restroomModel.CurrentFeedback.RestroomId = restroomId.Value;
                return View(restroomModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.FeedbackController.Create", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(RestroomViewModel restroomModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    using (var service = new FeedbackService(PrincipalName))
                    {
                        var newContact = await service.SaveFeedbackAsync(restroomModel.CurrentFeedback);
                        return RedirectToAction("Details", "Restroom", new { id = restroomModel.CurrentFeedback.RestroomId });
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.FeedbackController.Create", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomModel);
        }


        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenFeedbackEditor })]
        public async Task<ActionResult> Edit(int? id)
        {
            var restroomModel = new RestroomViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                using (var service = new FeedbackService())
                {
                    var feedback = await service.GetFeedbackAsync(id.Value);

                    if (feedback == null)
                        return HttpNotFound();
                    else
                        restroomModel.CurrentFeedback = feedback;
                }

                return View(restroomModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.FeedbackController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenFeedbackEditor })]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(RestroomViewModel restroomModel)
        {
            if (restroomModel == null)
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            try
            {
                if (ModelState.IsValid)
                {
                    using (var service = new FeedbackService(PrincipalName))
                    {
                        var reviewedRestroomModel = await service.SaveFeedbackAsync(restroomModel.CurrentFeedback);
                        return RedirectToAction("Details", "Restroom", new { id = restroomModel.CurrentFeedback.RestroomId });
                    }
                }

                return View(restroomModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.FeedbackController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                //TODO
            }
            base.Dispose(disposing);
        }
    }
}
