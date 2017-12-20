using System;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Net;
using System.Web.Mvc;
using System.Linq;
using System.Linq.Expressions;

using X.PagedList;

using ACTransit.Framework.Extensions;

using ACTransit.RestroomFinder.Web.Contexts;
using ACTransit.RestroomFinder.Web.Models;
using ACTransit.RestroomFinder.Web.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using System.Collections.Generic;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    [Authorize]
    public class RestroomAdminController : Controller
    {
        //TODO: Make this configurable
        private const int Pagesize = 15;
        private const int Srid = 4326;
        private const string Ascending = "ascending";
        private const string Namefieldname = "RestroomName";
        private const string Addressfieldname = "Address";
        private const string Cityfieldname = "City";
        private const string Restroomtypefieldname = "RestroomType";
        private const string Drinkingwaterfieldname = "DrinkingWater";
        private const string Routesfieldname = "ACTRoute";
        private const string Zipfieldname = "Zip";

        private readonly RestroomContext _db = new RestroomContext();

        // GET: RestroomAdmin
        [AllowAnonymous]
        public async Task<ActionResult> Index(string searchName, string searchAddress, string searchCity, string sortField, string sortDirection, int? page, string showActive = "True")
        {
            Expression<Func<RestroomViewModel, bool>> whereClause = null;
            var filter = new List<Expression<Func<RestroomViewModel, bool>>>();
            Func<RestroomViewModel, object> sortByQuery;
            IPagedList<RestroomViewModel> pagedRestrooms;

            //Persit information for next page load
            ViewBag.SearchName = searchName;
            ViewBag.SearchAddress = searchAddress;
            ViewBag.SearchCity = searchCity;
            ViewBag.SortField = sortField ?? Namefieldname;
            ViewBag.ShowActive = showActive;
            ViewBag.SortDirection = sortDirection ?? Ascending;
            ViewBag.Page = page;

            //Check that request does not contain an invalid page reference
            if (page.HasValue && page < 1)
                return null;

            //Parse filters
            if (!string.IsNullOrEmpty(searchName)) filter.Add(r => r.RestroomName.Contains(searchName.Trim()));
            if (!string.IsNullOrEmpty(searchAddress)) filter.Add(r => r.Address.Contains(searchAddress.Trim()));
            if (!string.IsNullOrEmpty(searchCity)) filter.Add(r => r.City.Contains(searchCity.Trim()));
            if (!showActive.Equals("All", StringComparison.CurrentCultureIgnoreCase)) filter.Add(r => r.Active == (showActive == "True"));

            //Build expression tree
            whereClause = filter.Aggregate(whereClause,
                (current, f) => current == null ? f : current.And(f));

            //Perform query
            var restrooms = whereClause != null ? _db.Restrooms.Where(whereClause) : _db.Restrooms;

            //Perform sorting and pagination
            switch (sortField)
            {
                case Namefieldname:
                    sortByQuery = (field => field.RestroomName);
                    break;
                case Addressfieldname:
                    sortByQuery = (field => field.Address);
                    break;
                case Cityfieldname:
                    sortByQuery = (field => field.City);
                    break;
                case Restroomtypefieldname:
                    sortByQuery = (field => field.RestroomType);
                    break;
                case Drinkingwaterfieldname:
                    sortByQuery = (field => field.DrinkingWater);
                    break;
                case Routesfieldname:
                    sortByQuery = (field => field.ACTRoute);
                    break;
                case Zipfieldname:
                    sortByQuery = (field => field.Zip);
                    break;
                default:
                    sortByQuery = (field => field.RestroomName);
                    break;
            }

            if (string.IsNullOrEmpty(sortDirection) || sortDirection.Equals(Ascending, StringComparison.InvariantCultureIgnoreCase))
                pagedRestrooms = await restrooms.OrderBy(sortByQuery).ToPagedListAsync(page ?? 1, Pagesize);
            else
                pagedRestrooms = await restrooms.OrderByDescending(sortByQuery).ToPagedListAsync(page ?? 1, Pagesize);

            return View(pagedRestrooms);
        }

        // GET: RestroomAdmin/Details/5
        [AllowAnonymous]
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            RestroomViewModel restroomModel = await _db.Restrooms.FindAsync(id);

            if (restroomModel == null)
                return HttpNotFound();

            return View(restroomModel);
        }

        // GET: RestroomAdmin/Create
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenCreator })]
        public ActionResult Create()
        {
            RestroomViewModel restroomModel = new RestroomViewModel();
            
            return View(restroomModel);
        }

        // POST: RestroomAdmin/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "RestroomId,RestroomType,RestroomName,Address,City,State,Zip,Country,DrinkingWater,ACTRoute,SelectedRoutes,Hours,Note,Active,LongDec,LatDec,Geo")] RestroomViewModel restroomModel)
        {
            if (ModelState.IsValid)
            {
                //Create geography object for the current location
                restroomModel.Geo = System.Data.Entity.Spatial.DbGeography.PointFromText(
                    $"POINT({restroomModel.LongDec} {restroomModel.LatDec})", Srid);

                //Set creation Time-stamp
                restroomModel.AddDateTime = DateTime.Now;

                //Set creation User ID
                restroomModel.AddUserId = User.Identity.Name;

                //Transform string array of routes into a comma separated values string
                if (restroomModel.SelectedRoutes != null && restroomModel.SelectedRoutes.Length > 0)
                    restroomModel.ACTRoute = string.Join(",", restroomModel.SelectedRoutes);

                _db.Restrooms.Add(restroomModel);

                await _db.SaveChangesAsync();

                return RedirectToAction("Index");
            }

            return View(restroomModel);
        }

        // GET: RestroomAdmin/Edit/5
        [TokenAuthorization(Tokens = new []{TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenEditor})]
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            
            RestroomViewModel restroomModel = await _db.Restrooms.FindAsync(id);

            if (restroomModel == null)
            {
                return HttpNotFound();
            }

            return View(restroomModel);
        }

        // POST: RestroomAdmin/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "RestroomId,RestroomType,RestroomName,Address,City,State,Zip,Country,DrinkingWater,ACTRoute,SelectedRoutes,Hours,Note,Active,LongDec,LatDec,Geo,AddUserId,AddDateTime")] RestroomViewModel restroomModel)
        {
            if (ModelState.IsValid)
            {
                //Update geography object for the current location
                restroomModel.Geo = System.Data.Entity.Spatial.DbGeography.PointFromText(
                    $"POINT({restroomModel.LongDec} {restroomModel.LatDec})", Srid);

                //Set update Time-stamp
                restroomModel.UpdDateTime = DateTime.Now;

                //Set update User ID
                restroomModel.UpdUserId = User.Identity.Name;

                //Transform string array of routes into a comma separated values string
                if (restroomModel.SelectedRoutes != null && restroomModel.SelectedRoutes.Length > 0)
                    restroomModel.ACTRoute = string.Join(",", restroomModel.SelectedRoutes);

                _db.Entry(restroomModel).State = EntityState.Modified;

                await _db.SaveChangesAsync();
                return RedirectToAction("Index");
            }
            return View(restroomModel);
        }

        // GET: RestroomAdmin/Delete/5
        [TokenAuthorization(Tokens = new[] { TokenAuthorizationHelper.TokenAdmin, TokenAuthorizationHelper.TokenEditor })]
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            RestroomViewModel restroomModel = await _db.Restrooms.FindAsync(id);

            if (restroomModel == null)
            {
                return HttpNotFound();
            }
            return View(restroomModel);
        }

        // POST: RestroomAdmin/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            RestroomViewModel restroomModel = await _db.Restrooms.FindAsync(id);
            _db.Restrooms.Remove(restroomModel);
            await _db.SaveChangesAsync();
            return RedirectToAction("Index");
        }

        // GET: RestroomAdmin/GetAllRoutes
        [AllowAnonymous]
        public async Task<ActionResult> GetAllRoutes()
        {
            return Json(await Task.Run(() => new RestroomService().GetRestroomRoutes()), JsonRequestBehavior.AllowGet);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                _db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
