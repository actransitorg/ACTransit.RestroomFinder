using System;
using System.Threading.Tasks;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Collections.Generic;

using ACTransit.RestroomFinder.Domain.Dto;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class UserDeviceController : BaseController
    {
        private const string Ascending = "ascending";
        private const string Namefieldname = "LastLogon";

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> Index(string searchBadge, string searchModel, string searchOS, string sortField, string sortDirection, string showActive = "True")
        {
            IEnumerable<UserDevice> userDevices;

            //Persit information for next page load
            ViewBag.SearchBadge = searchBadge;
            ViewBag.SearchModel = searchModel;
            ViewBag.SearchOS = searchOS;
            ViewBag.SortField = sortField ?? Namefieldname;
            ViewBag.ShowActive = showActive;
            ViewBag.SortDirection = sortDirection ?? Ascending;

            bool? active;
            if (showActive.Equals("All", StringComparison.CurrentCultureIgnoreCase))
                active = null;
            else
                active = showActive == "True";

            using (var service = new UserDeviceService())
            {
                userDevices = await service.GetUserDevicesAsync(new UserDeviceSearchContext
                {
                    Badge = searchBadge,
                    Model = searchModel,
                    Os = searchOS,
                    Active = active,
                    SortField = sortField,
                    SortDirection = sortDirection == "descending" ? SortDirection.Descending : SortDirection.Ascending,
                });
            }

            return View(userDevices);
        }

        [HttpPost]
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> ActivateUserDevice(int userId, long deviceId, string searchBadge, string searchModel, string searchOS, string sortField, string sortDirection, int? page, string showActive = "True", bool activate = true)
        {
            using (var service = new UserDeviceService(PrincipalName))
            {
                if (activate)
                    await service.ActivateUserDevice(userId, deviceId);
                else
                    await service.InActivateUserDevice(userId, deviceId);
            }
            return RedirectToAction("Index", new { searchBadge, searchModel, searchOS, sortField, sortDirection, page, showActive });
        }
    }
}