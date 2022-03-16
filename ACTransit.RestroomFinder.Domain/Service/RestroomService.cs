using ACTransit.DataAccess.RestroomFinder;
using ACTransit.DataAccess.Scheduling.Repositories;
using ACTransit.Framework.Caching;
using ACTransit.Framework.DataAccess;
using ACTransit.Framework.DataAccess.Extensions;
using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.Domain.Enums;
using ACTransit.RestroomFinder.Domain.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Mvc;

using ACTransit.RestroomFinder.Domain.Dto;

using X.PagedList;

using Restroom = ACTransit.DataAccess.RestroomFinder.Restroom;


namespace ACTransit.RestroomFinder.Domain.Service
{
    public class RestroomService : DomainServiceBase
    {
        private const string Classname = "RestroomService";

        public RestroomService() : base(string.Empty)
        {
        }

        public RestroomService(string username) : base(username)
        {
        }

        public async Task<IPagedList<Dto.Restroom>> GetApprovedRestroomsAsync(RestroomSearchContext search = null)
        {
            var filterAnd = new List<Expression<Func<ApprovedRestroom, bool>>>();
            var filterOr = new List<Expression<Func<ApprovedRestroom, bool>>>();
            Expression<Func<ApprovedRestroom, bool>> whereClause = null;

            //Parse filters
            if (search != null)
            {
                if (!string.IsNullOrEmpty(search.LabelId)) filterAnd.Add(r => r.LabelId.Contains(search.LabelId.Trim()));
                if (!string.IsNullOrEmpty(search.Address)) filterAnd.Add(r => r.Address.Contains(search.Address.Trim()));
                if (!string.IsNullOrEmpty(search.City)) filterAnd.Add(r => r.City.Contains(search.City.Trim()));
                if (!string.IsNullOrEmpty(search.Name)) filterAnd.Add(r => r.RestroomName.Contains(search.Name.Trim()));
                if (search.StatusId.HasValue) filterAnd.Add(r => r.StatusListId == search.StatusId.Value);
                if (search.Public.HasValue) filterAnd.Add(r => r.IsPublic == search.Public.Value);
                /*if (search.PendingReview.HasValue) filterAnd.Add(r => r.PendingReview == search.PendingReview.Value);*/
                if (search.HasToilet.HasValue) filterAnd.Add(r => r.IsToiletAvailable == search.HasToilet.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "RestroomName";

                if (search.Routes != null && search.Routes.Count() > 0)
                    foreach (var route in search.Routes)
                        filterAnd.Add(r => r.SearchRoutes.Contains("'" + route + "'"));
            }
            else
                search = new RestroomSearchContext { SortField = "RestroomName" };

            //Build AND expression tree
            if (filterAnd.Count > 0)
                whereClause = filterAnd.Aggregate((Expression<Func<ApprovedRestroom, bool>>)null, (current, f) => current == null ? f : current.And(f));

            //Build OR expression tree
            if (filterOr.Count > 0)
            {
                if (whereClause == null)
                    whereClause = filterOr.Aggregate((Expression<Func<ApprovedRestroom, bool>>)null, (current, f) => current == null ? f : current.Or(f));

                //Please note that AND and OR combinations are not currenly supported (either)
                else
                    whereClause.And(filterOr.Aggregate((Expression<Func<ApprovedRestroom, bool>>)null, (current, f) => current == null ? f : current.Or(f)));
            }

            var query = UnitOfWork.Get<ApprovedRestroom>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var restrooms = await query
                    .DynamicOrderBy(search.SortField,
                        (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                    .ToPagedListAsync(search.PageNumber, search.PageSize);

            return restrooms.Select(Converter.ToModel);
        }

        public async Task<IEnumerable<Dto.RestroomHistory>> GetRestroomHistory(int id, string sortField, string sortDirection)
        {
            var restrooms = await UnitOfWork.GetRestroomHistory(id, sortField, sortDirection);
            return restrooms.Select(Converter.ToModel);
        }

        public async Task<IEnumerable<Dto.RestroomContactReport>> GetRestroomContactList(string sortField, string sortDirection)
        {
            var restrooms = await UnitOfWork.GetRestroomContactList(sortField, sortDirection);
            return restrooms.Select(Converter.ToModel);
        }

        public async Task<Dto.Restroom> GetApprovedRestroomAsync(int? restroomId)
        {
            var restroom = await UnitOfWork.GetByIdAsync<ApprovedRestroom, int?>(restroomId);
            return Converter.ToModel(restroom);
        }

        public async Task<IEnumerable<Dto.Restroom>> GetRestroomForReviewAsync(int restroomId)
        {
            return await UnitOfWork.Get<ReviewRestroom>()
                                        .Where(r => r.RestroomId == restroomId)
                                        .OrderByDescending(r => r.SysStartTime)
                                        .Select(Converter.ToModel)
                                        .ToListAsync();
        }

        public RestroomsPrint GetRestroomsByDivision()
        {
            var restroomsByDivision = new List<Dto.RestroomsByDivision>();
            var restrooms = UnitOfWork.GetRestroomsByDivision().ToList();
            var version = DateTime.Now.ToString("yy.MMdd.HHmm");

            foreach (var rDivision in restrooms.GroupBy(r => r.Division))
            {
                var rr = new List<Dto.RestroomsByRoutes>();

                foreach (var items in rDivision.GroupBy(r => r.Route))
                {
                    var restroomInfo = items.FirstOrDefault();
                    if (restroomInfo != null)
                    {
                        var r = new Dto.RestroomsByRoutes()
                        {
                            Route = restroomInfo.Route,
                            DestinationName = restroomInfo.DestinationName,
                            Restrooms = items.Select(Converter.ToModel).ToList()
                        };

                        rr.Add(r);
                    }
                }

                var rd = new Dto.RestroomsByDivision()
                {
                    Division = rDivision.FirstOrDefault()?.Division,
                    RestroomsByRoutes = rr,
                    CurrentVersion = version + "." + rDivision.FirstOrDefault()?.Division
                };
                restroomsByDivision.Add(rd);
            }

            var restroomsByRoutes = new List<Dto.RestroomsByRoutes>();

            foreach (var items in restrooms.OrderByNatural(r => r.Route).GroupBy(r => r.Route))
            {
                var restroomInfo = items.FirstOrDefault();
                if (restroomInfo != null)
                {
                    var r = new Dto.RestroomsByRoutes()
                    {
                        Route = restroomInfo.Route,
                        DestinationName = restroomInfo.Division + " " + restroomInfo.DestinationName,
                        Restrooms = items.Select(Converter.ToModel).ToList()
                    };

                    restroomsByRoutes.Add(r);
                }
            }

            var restroomsById = restrooms.GroupBy(r => r.RestroomId).ToList();
            var uniqueRestrooms = new List<RestroomReport>();

            foreach (var restroom in restroomsById)
            {
                var restroomInfo = restroom.FirstOrDefault();
                if (restroomInfo != null)
                {
                    uniqueRestrooms.Add(restroomInfo);
                }
            }

            var results = new RestroomsPrint
            {
                Restrooms = uniqueRestrooms.Select(Converter.ToModel).ToPagedList(),
                RestroomsByRoutes = restroomsByRoutes,
                RestroomsByDivision = restroomsByDivision
            };
            return results;
        }

        public List<Dto.RestroomsByRoutes> GetAllRestroomsByRoutes()
        {
            var restrooms = UnitOfWork.GetRestroomsByDivision().OrderBy(r => r.Route);
            var restroomsByRoutes = new List<Dto.RestroomsByRoutes>();

            foreach (var items in restrooms.GroupBy(r => r.Route))
            {
                var restroomInfo = items.FirstOrDefault();
                if (restroomInfo != null)
                {
                    var r = new Dto.RestroomsByRoutes()
                    {
                        Route = restroomInfo.Route,
                        DestinationName = restroomInfo.DestinationName,
                        Restrooms = items.Select(Converter.ToModel).ToList()
                    };

                    restroomsByRoutes.Add(r);
                }
            }

            return restroomsByRoutes;
        }

        public async Task<Dto.Restroom> SaveRestroomAsync(Dto.Restroom restroom)
        {
            var updatedRestroom = await UnitOfWork.SaveRestroomAsync(Converter.ToEntity(restroom));
            return Converter.ToModel(updatedRestroom);
        }

        public async Task<bool> SoftDeleteRestroomAsync(int restroomId)
        {
            var restroom = await UnitOfWork.GetByIdAsync<Restroom, int?>(restroomId);

            if (restroom == null)
                return false;

            //When updating the record ensure that the changes do not require approval
            restroom.StatusListId = (int)RestroomEnums.RestroomApprovalStatus.Approved;
            restroom.Deleted = true;

            await UnitOfWork.SaveRestroomAsync(restroom);

            return true;
        }

        public async Task<IEnumerable<Tuple<string, string>>> GetRestroomRoutesAsync()
        {
            var cacheKey = $"{Classname}.{MethodBase.GetCurrentMethod().Name}";

            var routes = DomainCache.GetCache(cacheKey);

            if (routes == null)
            {
                routes = await new SchedulingUnitOfWork().Get<Entities.Scheduling.Route>()
                    .Select(r => new { r.RouteTypeId, r.RouteAlpha })
                    .Distinct()
                    .OrderBy(r => r.RouteAlpha)
                    .AsEnumerable()
                    .Select(r => new Tuple<string, string>(r.RouteAlpha, r.RouteAlpha))
                    .ToListAsync();

                DomainCache.AddCache(cacheKey, routes);
            }

            return (IEnumerable<Tuple<string, string>>)routes;
        }

        public async Task<IEnumerable<string>> GetRoutesByLocationAsync(float latitude, float longitude, int radiusFeet = 600)
        {
            return await new RestroomUnitOfWork().GetRoutesByLocationAsync(latitude, longitude, radiusFeet);
        }

        public List<SelectListItem> GetDrinkingWaterOptions()
        {
            var dwo = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Yes", Value = "Y", Selected = true},
                new SelectListItem() {Text = "No", Value = "N"}
            };

            return dwo;
        }

        public List<SelectListItem> GetRestroomTypes()
        {
            var rt = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Paid", Value = "PAID"},
                new SelectListItem() {Text = "Non-Paid", Value = "NON-PAID", Selected = true},
                new SelectListItem() {Text = "BART", Value = "BART"},
                new SelectListItem() {Text = "ACT", Value = "ACT"}
            };

            return rt;
        }

        public List<SelectListItem> GetToiletGenders()
        {
            var rt = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Men", Value = "1", Selected = false},
                new SelectListItem() {Text = "Women", Value = "2", Selected = false},
                new SelectListItem() {Text = "Gender Neutral", Value = "4", Selected = false}
            };

            return rt;
        }

        public List<SelectListItem> GetStates()
        {
            var sl = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Alabama", Value = "AL"},
                new SelectListItem() {Text = "Alaska", Value = "AK"},
                new SelectListItem() {Text = "Arizona", Value = "AZ"},
                new SelectListItem() {Text = "Arkansas", Value = "AR"},
                new SelectListItem() {Text = "California", Value = "CA", Selected = true},
                new SelectListItem() {Text = "Colorado", Value = "CO"},
                new SelectListItem() {Text = "Connecticut", Value = "CT"},
                new SelectListItem() {Text = "Delaware", Value = "DE"},
                new SelectListItem() {Text = "Florida", Value = "FL"},
                new SelectListItem() {Text = "Georgia", Value = "GA"},
                new SelectListItem() {Text = "Hawaii", Value = "HI"},
                new SelectListItem() {Text = "Idaho", Value = "ID"},
                new SelectListItem() {Text = "Illinois", Value = "IL"},
                new SelectListItem() {Text = "Indiana", Value = "IN"},
                new SelectListItem() {Text = "Iowa", Value = "IA"},
                new SelectListItem() {Text = "Kansas", Value = "KS"},
                new SelectListItem() {Text = "Kentucky", Value = "KY"},
                new SelectListItem() {Text = "Louisiana", Value = "LA"},
                new SelectListItem() {Text = "Maine", Value = "ME"},
                new SelectListItem() {Text = "Maryland", Value = "MD"},
                new SelectListItem() {Text = "Massachusetts", Value = "MA"},
                new SelectListItem() {Text = "Michigan", Value = "MI"},
                new SelectListItem() {Text = "Minnesota", Value = "MN"},
                new SelectListItem() {Text = "Mississippi", Value = "MS"},
                new SelectListItem() {Text = "Missouri", Value = "MO"},
                new SelectListItem() {Text = "Montana", Value = "MT"},
                new SelectListItem() {Text = "Nebraska", Value = "NE"},
                new SelectListItem() {Text = "Nevada", Value = "NV"},
                new SelectListItem() {Text = "New Hampshire", Value = "NH"},
                new SelectListItem() {Text = "New Jersey", Value = "NJ"},
                new SelectListItem() {Text = "New Mexico", Value = "NM"},
                new SelectListItem() {Text = "New York", Value = "NY"},
                new SelectListItem() {Text = "North Carolina", Value = "NC"},
                new SelectListItem() {Text = "North Dakota", Value = "ND"},
                new SelectListItem() {Text = "Ohio", Value = "OH"},
                new SelectListItem() {Text = "Oklahoma", Value = "OK"},
                new SelectListItem() {Text = "Oregon", Value = "OR"},
                new SelectListItem() {Text = "Pennsylvania", Value = "PA"},
                new SelectListItem() {Text = "Rhode Island", Value = "RI"},
                new SelectListItem() {Text = "South Carolina", Value = "SC"},
                new SelectListItem() {Text = "South Dakota", Value = "SD"},
                new SelectListItem() {Text = "Tennessee", Value = "TN"},
                new SelectListItem() {Text = "Texas", Value = "TX"},
                new SelectListItem() {Text = "Utah", Value = "UT"},
                new SelectListItem() {Text = "Vermont", Value = "VT"},
                new SelectListItem() {Text = "Virginia", Value = "VA"},
                new SelectListItem() {Text = "Washington", Value = "WA"},
                new SelectListItem() {Text = "West Virginia", Value = "WV"},
                new SelectListItem() {Text = "Wisconsin", Value = "WI"},
                new SelectListItem() {Text = "Wyoming", Value = "WY"}
            };

            return sl;
        }

        public List<SelectListItem> GetRestroomStatuses(bool isSearch = false)
        {
            var rt = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Pending", Value = "1"},
                new SelectListItem() {Text = "In Service", Value = "2", Selected = true},
                new SelectListItem() {Text = "Out of Service", Value = "3"}
            };

            if (isSearch)
                rt.Insert(0, new SelectListItem() { Text = "All", Value = "All" });

            return rt;
        }

        public List<SelectListItem> GetVisibilityStatuses(bool isSearch = false)
        {
            var rt = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Public", Value = "True"},
                new SelectListItem() {Text = "Private", Value = "False", Selected = true},
            };

            if (isSearch)
                rt.Insert(0, new SelectListItem() { Text = "All", Value = "All" });

            return rt;
        }

        public List<SelectListItem> GetToiletOptions(bool isSearch = false)
        {
            var to = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Yes", Value = "True", Selected = !isSearch},
                new SelectListItem() {Text = "No", Value = "False"}
            };

            if (isSearch)
                to.Insert(0, new SelectListItem() { Text = "All", Value = "All", Selected = true });

            return to;
        }

        public List<SelectListItem> GetApprovalStatuses(bool isSearch = false)
        {
            var rt = UnitOfWork.Get<RestroomStatusList>().Select(s => new SelectListItem()
            {
                Text = s.Name,
                Value = s.RestroomStatusListId.ToString(),
                Selected = s.IsDefault
            }).ToList();

            return rt;
        }

        public List<SelectListItem> GetPendingReviewStatuses()
        {
            return new List<SelectListItem>
            {
                new SelectListItem() {Text = "All", Value = "All", Selected = true },
                new SelectListItem() {Text = "Yes", Value = "True" },
                new SelectListItem() {Text = "No", Value = "False" },
            };
        }
    }
}
