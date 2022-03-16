using System;
using System.Threading.Tasks;
using System.Web.Mvc;

using X.PagedList;

using ACTransit.RestroomFinder.Domain.Dto;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;
using System.Web.Helpers;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class UserController : BaseController
    {
        private const string Ascending = "ascending";
        private const string Namefieldname = "Name";

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> Index(string searchBadge, string sortField, string sortDirection, int page = 1, string showActive = "True")
        {
            IPagedList<User> pagedUsers;

            //Persit information for next page load
            ViewBag.SearchBadge = searchBadge;
            ViewBag.SortField = sortField ?? Namefieldname;
            ViewBag.ShowActive = showActive;
            ViewBag.SortDirection = sortDirection ?? Ascending;
            ViewBag.Page = page;

            bool? active;
            if (showActive.Equals("All", StringComparison.CurrentCultureIgnoreCase))
                active = null;
            else
                active = showActive.Equals("True", StringComparison.InvariantCultureIgnoreCase);

            using (var service = new UserDeviceService())
            {
                pagedUsers = await service.GetUsersAsync(new UserSearchContext
                {
                    Badge = searchBadge,
                    Active = active,
                    SortField = sortField,
                    SortDirection = sortDirection == "descending" ? SortDirection.Descending : SortDirection.Ascending,
                    PageNumber = page
                });
            }

            return View(pagedUsers);
        }

        [HttpPost]
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> ActivateUser(int userId, string searchBadge, string searchModel, string searchOS, string sortField, string sortDirection, int? page, string showActive = "True", bool activate = true)
        {
            using (var service = new UserDeviceService(PrincipalName))
            {
                if (activate)
                    await service.ActivateUser(userId);
                else
                    await service.InActivateUser(userId);
            }
            return RedirectToAction("Index", new { searchBadge, searchModel, searchOS, sortField, sortDirection, page, showActive });
        }
    }
}