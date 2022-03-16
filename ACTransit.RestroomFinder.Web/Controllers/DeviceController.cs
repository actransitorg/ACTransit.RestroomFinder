using System;
using System.Threading.Tasks;
using System.Web.Helpers;
using System.Web.Mvc;

using X.PagedList;

using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.Web.Controllers.Base;
using ACTransit.RestroomFinder.Web.Infrastructure;

using Device = ACTransit.RestroomFinder.Domain.Dto.Device;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class DeviceController : BaseController
    {
        private const string Namefieldname = "LastUsed";
        private const string Ascending = "ascending";

        private readonly RestroomContext _db = new RestroomContext();

        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> Index(string deviceGuid, string searchModel, string searchOS, string sortField, string sortDirection, int page = 1, string showActive = "True")
        {
            IPagedList<Device> pagedDevices;

            //Persit information for next page load
            ViewBag.SearchDevice = deviceGuid;
            ViewBag.SearchModel = searchModel;
            ViewBag.SearchOS = searchOS;
            ViewBag.SortField = sortField ?? Namefieldname;
            ViewBag.ShowActive = showActive;
            ViewBag.SortDirection = sortDirection ?? Ascending;
            ViewBag.Page = page;

            bool? active;
            if (showActive.Equals("All", StringComparison.CurrentCultureIgnoreCase))
                active = null;
            else
                active = showActive == "True";

            using (var service = new UserDeviceService())
            {
                pagedDevices = await service.GetDevicesAsync(new DeviceSearchContext
                {
                    DeviceGuid = deviceGuid,
                    Model = searchModel,
                    Os = searchOS,
                    Active = active,
                    SortField = sortField,
                    SortDirection = sortDirection == "descending" ? SortDirection.Descending : SortDirection.Ascending,
                    PageNumber = page
                });
            }

            return View(pagedDevices);
        }

        [HttpPost]
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenApplicationAccessEditor })]
        public async Task<ActionResult> ActivateDevice(long deviceId, string searchBadge, string searchModel, string searchOS, string sortField, string sortDirection, int? page, string showActive = "True", bool activate = true)
        {
            using (var service = new UserDeviceService(PrincipalName))
            {
                if (activate)
                    await service.ActivateDevice(deviceId);
                else
                    await service.InActivateDevice(deviceId);
            }
            return RedirectToAction("Index", new { searchBadge, searchModel, searchOS, sortField, sortDirection, page, showActive });
        }
    }
}