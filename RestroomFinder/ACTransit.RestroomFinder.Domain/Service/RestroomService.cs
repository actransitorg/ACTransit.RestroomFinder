using System;
using System.Linq;
using System.Collections.Generic;
using System.Web.Mvc;

using ACTransit.Framework.Caching;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Repository;
using ACTransit.DataAccess.Scheduling.Repositories;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class RestroomService: DomainServiceBase<Restroom>, IDomainService
    {
        private const string Classname = "RestroomService";

        private RestroomRepository _restroomRepository;

        public RestroomService(RequestContext requestContext) : base(requestContext) { }

        public RestroomService() { }

        protected override void Initialize()
        {
            _restroomRepository = new RestroomRepository(RequestContext);
            Repository = _restroomRepository; // set default repository;
        }

        public List<SelectListItem> GetDrinkingWaterOptions()
        {
            var dwo = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Yes", Value = "Y"},
                new SelectListItem() {Text = "No", Value = "N"}
            };


            return dwo;
        }

        public List<SelectListItem> GetRestroomTypes()
        {
            var rt = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Bart", Value = "BART"},
                new SelectListItem() {Text = "Non-Paid", Value = "NON-PAID"},
                new SelectListItem() {Text = "Paid or Business", Value = "PAID or BUSINESS"}
            };


            return rt;
        }

        public List<SelectListItem> GetStates()
        {
            List<SelectListItem> sl = new List<SelectListItem>
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
                new SelectListItem() {Text = "Massachussetts", Value = "MA"},
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
                new SelectListItem() {Text = "Rodhe Island", Value = "RI"},
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
                new SelectListItem() {Text = "Active", Value = "True", Selected = true},
                new SelectListItem() {Text = "Inactive", Value = "False"},
            };

            if (isSearch)
                rt.Insert(0, new SelectListItem() { Text = "All", Value = "All"});

            return rt;
        }

        public IEnumerable<Tuple<string,string>> GetRestroomRoutes()
        {
            var cacheKey = $"{Classname}.{System.Reflection.MethodBase.GetCurrentMethod().Name}";

            var routes = DomainCache.GetCache(cacheKey);

            if (routes == null)
            {
                routes = new SchedulingUnitOfWork().Get<Entities.Scheduling.Route>()
                    .Select(r => new {r.RouteTypeId, r.RouteAlpha})
                    .Distinct()
                    .OrderBy(r => r.RouteAlpha)
                    .AsEnumerable()
                    .Select(r => new Tuple<string, string>(r.RouteAlpha, r.RouteAlpha));

                DomainCache.AddCache(cacheKey, routes);
            }
            
            return (IEnumerable<Tuple<string, string>>)routes;
        }
    }
}
