using System;
using System.Net;
using System.Threading.Tasks;
using System.Web.Helpers;
using System.Web.Mvc;
using ACTransit.Framework.Logging;
using X.PagedList;

using ACTransit.RestroomFinder.Domain.Dto;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Web.Models;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class ContactController : BaseController
    {
        private const string Ascending = "ascending";
        private const string Namefieldname = "ContactName";
        
        public async Task<ActionResult> Index(string searchContactName, string sortField, string sortDirection, string searchServiceProvider, int page = 1)
        {
            var contactModel = new ContactViewModel();

            //Persit information for next page load
            ViewBag.SearchContactName = searchContactName;
            ViewBag.SearchServiceProvider = searchServiceProvider;
            ViewBag.SortField = sortField ?? Namefieldname;
            ViewBag.SortDirection = sortDirection ?? Ascending;
            ViewBag.Page = page;

            using (var service = new ContactService())
            {
                contactModel.Contacts = await service.GetContactsAsync(new ContactSearchContext
                {
                    Name = searchContactName,
                    ServiceProvider = searchServiceProvider,
                    SortField = sortField,
                    SortDirection = sortDirection == "descending" ? SortDirection.Descending : SortDirection.Ascending,
                    PageNumber = page
                });
            }

            return View(contactModel);
        }

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenContactCreator })]
        public ActionResult Create()
        {
            try
            {
                var contactModel = new ContactViewModel();
                return View(contactModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Create", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(ContactViewModel contactModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    using (var service = new ContactService(PrincipalName))
                    {
                        var newContact = await service.SaveContactAsync(contactModel.CurrentContact);
                        return RedirectToAction("Index", new
                        {
                            searchContactName = Session["SearchContactName"],
                            searchServiceProvider = Session["SearchServiceProvider"]
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Create", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(contactModel);
        }

        [AllowAnonymous]
        public async Task<ActionResult> Details(int? id, int page = 1, string sortField = "AddDateTime", string sortDirection = "Descending")
        {
            var contactViewModel = new ContactViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                //Persit information for next page load
                ViewBag.SortField = sortField ?? "AddDateTime";
                ViewBag.SortDirection = sortDirection ?? "Ascending";
                ViewBag.Page = page;

                using (var contactService = new ContactService(PrincipalName))
                {
                    contactViewModel.CurrentContact = await contactService.GetContactAsync(id);
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Details", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(contactViewModel);
        }

        // GET: Contact/Edit/5
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenContactEditor })]
        public async Task<ActionResult> Edit(int? id)
        {
            var contactModel = new ContactViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                using (var service = new ContactService())
                {
                    var contact = await service.GetContactAsync(id.Value);

                    if (contact == null)
                        return HttpNotFound();
                    contactModel.CurrentContact = contact;
                }

                return View(contactModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }

        // POST: Contact/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(ContactViewModel contactModel)
        {
            if (contactModel == null)
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            try
            {
                if (ModelState.IsValid)
                {
                    using (var service = new ContactService(PrincipalName))
                    {
                        var contact = await service.SaveContactAsync(contactModel.CurrentContact);
                        return RedirectToAction("Index", new
                        {
                            searchContactName = Session["SearchContactName"],
                            searchServiceProvider = Session["SearchServiceProvider"],
                            sorField = Session["SortField"],
                            sortDirection = Session["SortDirection"],
                            page = Session["page"]
                        });
                    }
                }

                return View(contactModel);
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Edit", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }
        }


        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenContactEditor })]
        public async Task<ActionResult> Delete(int? id)
        {
            var contactViewModel = new ContactViewModel();

            try
            {
                if (id == null)
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

                using (var service = new ContactService())
                    contactViewModel.CurrentContact = await service.GetContactAsync(id);

                if (contactViewModel == null)
                    return HttpNotFound();
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.Delete", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            return View(contactViewModel);
        }


        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            try
            {
                using (var service = new ContactService(PrincipalName))
                {
                    var isDeleted = await service.SoftDeleteContactAsync(id);

                    if (!isDeleted)
                        return HttpNotFound();
                }
            }
            catch (Exception ex)
            {
                Logger.WriteError("ACTransit.RestroomFinder.Web.ContactController.DeleteConfirmed", ex);
                return new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
            }

            //Return to main page
            return RedirectToAction("Index", new
            {
                searchContactName = Session["SearchContactName"],
                searchServiceProvider = Session["SearchServiceProvider"],
                sorField = Session["SortField"],
                sortDirection = Session["SortDirection"],
                page = Session["page"]
            });
        }

    }
}