using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using ACTransit.RestroomFinder.Domain.Dto;
using ACTransit.RestroomFinder.Domain.Enums;
using ACTransit.RestroomFinder.Web.Models;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class RestroomController : BaseController
    {
        [AllowAnonymous]
        public async Task<ActionResult> Index(string searchName,
                                              string searchLabelId,
                                              string searchAddress,
                                              string searchCity,
                                              string searchRouteSelection,
                                              string sortField = "RestroomName",
                                              string sortDirection = "Ascending",
                                              int page = 1,
                                              string statusId = "All",
                                              string showPublic = "All",
                                              string showToilet = "All",
                                              string showPendingReview = "All")
        {
            var restroomViewModel = new RestroomViewModel();
            try
            {
                //Persit information for next page load
                Session["SearchName"] = searchName;
                Session["SearchLabelId"] = searchLabelId;
                Session["SearchAddress"] = searchAddress;
                Session["SearchCity"] = searchCity;
                Session["SearchRoutes"] = searchRouteSelection;
                Session["SortField"] = sortField ?? "RestroomName";
                Session["StatusId"] = statusId;
                Session["ShowPublic"] = showPublic;
                Session["showToilet"] = showToilet;
                Session["ShowPendingReview"] = showPendingReview;
                Session["SortDirection"] = sortDirection ?? "Ascending";
                Session["Page"] = page;

                using (var service = new RestroomService())
                {
                    restroomViewModel.ApprovedRestrooms = await service.GetApprovedRestroomsAsync(new RestroomSearchContext
                    {
                        Name = searchName,
                        LabelId = searchLabelId,
                        Address = searchAddress,
                        City = searchCity,
                        Routes = string.IsNullOrEmpty(searchRouteSelection) ? null : searchRouteSelection.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries),
                        Public = showPublic == "All" ? (bool?)null : showPublic == "True",
                        StatusId = statusId == "All" ? (int?) null : int.Parse(statusId),
                        HasToilet = showToilet == "All" ? (bool?)null : showToilet == "True",
                        PendingReview = showPendingReview == "All" ? (bool?)null : showPendingReview == "True",
                        SortField = sortField,
                        SortDirection = sortDirection.Equals("Ascending", StringComparison.CurrentCultureIgnoreCase)
                                            ? System.Web.Helpers.SortDirection.Ascending
                                            : System.Web.Helpers.SortDirection.Descending,
                        PageNumber = page
                    });
                    restroomViewModel.ToiletGenders = service.GetToiletGenders();
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Index", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomViewModel);
        }

        [AllowAnonymous]
        public async Task<ActionResult> History(int? id,
            string sortField = "UpdDateTime",
            string sortDirection = "Ascending")
        {
            if (id == null)
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            Session["RestroomId"] = id.Value;
            Session["SortField"] = sortField ?? "RestroomName";
            Session["SortDirection"] = sortDirection ?? "Ascending";

            sortDirection = sortDirection != null && sortDirection.Equals("Ascending", StringComparison.CurrentCultureIgnoreCase)
                ? System.Web.Helpers.SortDirection.Ascending.ToString()
                : System.Web.Helpers.SortDirection.Descending.ToString();

            var restroomViewModel = new RestroomViewModel();
            try
            {
                using (var service = new RestroomService())
                {
                    restroomViewModel.RestroomHistory = await service.GetRestroomHistory(id.Value, sortField, sortDirection);
                    restroomViewModel.ToiletGenders = service.GetToiletGenders();
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.History", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomViewModel);
        }

        [AllowAnonymous]
        public async Task<ActionResult> Details(int? id, int page = 1, string sortField = "AddDateTime", string sortDirection = "Descending")
        {
            var restroomViewModel = new RestroomViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                //Persit information for next page load
                ViewBag.SortField = sortField ?? "AddDateTime";
                ViewBag.SortDirection = sortDirection ?? "Ascending";
                ViewBag.Page = page;

                using (var restroomService = new RestroomService())
                {
                    restroomViewModel.CurrentRestroom = await restroomService.GetApprovedRestroomAsync(id);
                    restroomViewModel.ToiletGenders = restroomService.GetToiletGenders();
                }

                using (var feedbackService = new FeedbackService())
                {
                    restroomViewModel.RestroomFeedback = await feedbackService.GetRestroomFeedbackAsync(new FeedbackSearchContext
                    {
                        RestroomId = id,
                        SortField = sortField,
                        SortDirection = sortDirection != null && sortDirection.Equals("Ascending", StringComparison.CurrentCultureIgnoreCase)
                        ? System.Web.Helpers.SortDirection.Ascending
                        : System.Web.Helpers.SortDirection.Descending,
                        PageNumber = page
                    });
                }

                using (var contactService = new ContactService())
                {
                    restroomViewModel.RestroomContacts = await contactService.GetContactsAsync(new ContactSearchContext
                    {
                        SortField = "ServiceProvider",
                        SortDirection = System.Web.Helpers.SortDirection.Ascending,
                        PageNumber = 1,
                        PageSize = 1
                    });
                }
                
                if (restroomViewModel.CurrentRestroom?.ContactId != null)
                    restroomViewModel.CurrentContact = restroomViewModel.RestroomContacts.FirstOrDefault(c =>
                                                           c.ContactId == (int)restroomViewModel.CurrentRestroom.ContactId) ??
                                                       new RestroomContact();

                if (restroomViewModel == null)
                    return HttpNotFound();

            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Details", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomViewModel);
        }

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenRestroomCreator })]
        public async Task<ActionResult> Create()
        {
            try
            {
                var restroomModel = new RestroomViewModel();
                using (var contactService = new ContactService())
                {
                    restroomModel.RestroomContacts = await contactService.GetContactsAsync(new ContactSearchContext
                    {
                        SortField = "ServiceProvider",
                        SortDirection = System.Web.Helpers.SortDirection.Ascending,
                        PageNumber = 1,
                        PageSize = 1
                    });
                }
                restroomModel.ToiletGenders = new RestroomService().GetToiletGenders();
                return View(restroomModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Create", ex);
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
                    using (var service = new RestroomService(PrincipalName))
                    {
                        var newRestroom = await service.SaveRestroomAsync(restroomModel.CurrentRestroom);
                        return RedirectToAction("Index", new
                        {
                            searchName = Session["SearchName"],
                            searchAddress = Session["SearchAddress"],
                            searchCity = Session["SearchCity"],
                            sorField = Session["SortField"],
                            sortDirection = Session["SortDirection"],
                            page = Session["page"],
                            statusId = Session["StatusId"],
                            showPublic = Session["ShowPublic"],
                            showToilet = Session["ShowToilet"],
                            showPendingReview = Session["ShowPendingReview"]
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Create", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomModel);
        }

        // GET: RestroomAdmin/Edit/5
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenRestroomEditor })]
        public async Task<ActionResult> Edit(int? id)
        {
            var restroomModel = new RestroomViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                using (var service = new RestroomService())
                {
                    var pendingReviewRestrooms = await service.GetRestroomForReviewAsync(id.Value);

                    if (pendingReviewRestrooms == null)
                        return HttpNotFound();
                    else
                    {
                        //The last record contains the current approved version of the restroom
                        restroomModel.CurrentRestroom = pendingReviewRestrooms.LastOrDefault();

                        //Remaining records contain unapproved versions of the restroom
                        restroomModel.ReviewRestrooms = pendingReviewRestrooms.Take(pendingReviewRestrooms.Count() - 1);
                    }
                }

                using (var contactService = new ContactService())
                {
                    restroomModel.RestroomContacts = await contactService.GetContactsAsync(new ContactSearchContext
                    {
                        SortField = "ServiceProvider",
                        SortDirection = System.Web.Helpers.SortDirection.Ascending,
                        PageNumber = 1,
                        PageSize = 1
                    });
                }

                if (restroomModel.CurrentRestroom?.ContactId != null)
                    restroomModel.CurrentContact = restroomModel.RestroomContacts.FirstOrDefault(c =>
                                                       c.ContactId == (int)restroomModel.CurrentRestroom.ContactId) ??
                                                   new RestroomContact();

                var toiletGenders = new RestroomService().GetToiletGenders();
                if (restroomModel.CurrentRestroom?.ToiletGenderId != null && restroomModel.CurrentRestroom.ToiletGenderId != 0)
                {
                    foreach (var gender in toiletGenders)
                    {
                        if ((restroomModel.CurrentRestroom.ToiletGenderId & (int) RestroomEnums.ToiletGender.Men) == Convert.ToInt32(gender.Value))
                            gender.Selected = true;
                        else if ((restroomModel.CurrentRestroom.ToiletGenderId & (int)RestroomEnums.ToiletGender.Women) == Convert.ToInt32(gender.Value))
                            gender.Selected = true;
                        else if ((restroomModel.CurrentRestroom.ToiletGenderId & (int) RestroomEnums.ToiletGender.GenderNeutral) == Convert.ToInt32(gender.Value))
                            gender.Selected = true;
                    }
                }
                restroomModel.ToiletGenders = toiletGenders;

                return View(restroomModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        // POST: RestroomAdmin/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
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
                    restroomModel.CurrentRestroom.AddressChanged = false; //Make sure AddressChanged flag is false after edit.
                    using (var service = new RestroomService(PrincipalName))
                    {
                        var reviewedRestroomModel = await service.SaveRestroomAsync(restroomModel.CurrentRestroom);
                        return RedirectToAction("Index", new
                        {
                            searchName = Session["SearchName"],
                            searchAddress = Session["SearchAddress"],
                            searchCity = Session["SearchCity"],
                            sorField = Session["SortField"],
                            sortDirection = Session["SortDirection"],
                            page = Session["page"],
                            statusId = Session["StatusId"],
                            showPublic = Session["ShowPublic"],
                            showToilet = Session["ShowToilet"],
                            showPendingReview = Session["ShowPendingReview"]
                        });
                    }
                }
                else
                {
                   return await Edit(restroomModel.CurrentRestroom.RestroomId);
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }


        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenRestroomEditor })]
        public async Task<ActionResult> Delete(int? id)
        {
            var restroomViewModel = new RestroomViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                using (var service = new RestroomService())
                {
                    restroomViewModel.CurrentRestroom = await service.GetApprovedRestroomAsync(id);
                    restroomViewModel.ToiletGenders = service.GetToiletGenders();
                }

                if (restroomViewModel == null)
                    return HttpNotFound();
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Delete", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomViewModel);
        }


        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            try
            {
                using (var service = new RestroomService(PrincipalName))
                {
                    var isDeleted = await service.SoftDeleteRestroomAsync(id);

                    if (!isDeleted)
                        return HttpNotFound();
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.DeleteConfirmed", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            //Return to main page
            return RedirectToAction("Index", new
            {
                searchName = Session["SearchName"],
                searchAddress = Session["SearchAddress"],
                searchCity = Session["SearchCity"],
                sorField = Session["SortField"],
                sortDirection = Session["SortDirection"],
                page = Session["page"],
                statusId = Session["StatusId"],
                showPublic = Session["ShowPublic"],
                showToilet = Session["ShowToilet"],
                showPendingReview = Session["ShowPendingReview"]
            });
        }

        // GET: RestroomAdmin/GetAllRoutes
        [AllowAnonymous]
        public async Task<ActionResult> GetAllRoutes()
        {
            try
            {
                using (var service = new RestroomService())
                    return Json(await service.GetRestroomRoutesAsync(), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.GetAllRoutes", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        // GET: RestroomAdmin/GetAllRoutes
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenRestroomEditor })]
        public async Task<ActionResult> GetRoutesByLocation(float latitude, float longitude)
        {
            try
            {
                using (var service = new RestroomService())
                    return Json(await service.GetRoutesByLocationAsync(latitude, longitude), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.GetAllRoutes", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }


        // GET: RestroomAdmin/Print
        [AllowAnonymous]
        public ActionResult Print()
        {
            try
            {
                var restroomViewModel = new RestroomViewModel();

                using (var service = new RestroomService())
                {
                    var restrooms = service.GetRestroomsByDivision();
                    restroomViewModel.ApprovedRestrooms = restrooms.Restrooms;
                    restroomViewModel.RestroomsByDivision = restrooms.RestroomsByDivision;
                    restroomViewModel.RestroomsByRoute = restrooms.RestroomsByRoutes;
                }

                return View(restroomViewModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.Print", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        [AllowAnonymous]
        public async Task<ActionResult> RestroomContactReport(string sortField = "RestroomName",
            string sortDirection = "Ascending")
        {
            Session["SortField"] = sortField ?? "RestroomName";
            Session["SortDirection"] = sortDirection ?? "Ascending";

            sortDirection = sortDirection != null && sortDirection.Equals("Ascending", StringComparison.CurrentCultureIgnoreCase)
                ? System.Web.Helpers.SortDirection.Ascending.ToString()
                : System.Web.Helpers.SortDirection.Descending.ToString();
            var restroomViewModel = new RestroomViewModel();
            try
            {
                using (var service = new RestroomService())
                {
                    restroomViewModel.RestroomContactReport = await service.GetRestroomContactList(sortField, sortDirection);
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.RestroomController.RestroomContactReport", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(restroomViewModel);
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
