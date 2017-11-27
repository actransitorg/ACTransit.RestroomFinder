using System;
using System.Web.Mvc;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;
using System.Linq;
using Newtonsoft.Json;

using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Web.Models
{
    [Table("Restroom")]
    public class RestroomViewModel : IModel
    {
        #region Entity Fields

        [Key]
        public int RestroomId { get; set; }

        [Required(ErrorMessage = "Please select a restroom type")]
        public string RestroomType { get; set; }

        [StringLength(52)]
        [Required(ErrorMessage = "Please enter a restroom name")]
        public string RestroomName { get; set; }

        [StringLength(49)]
        [Required(ErrorMessage = "Please enter a valid address")]
        public string Address { get; set; }

        [StringLength(14)]
        public string City { get; set; }

        [StringLength(2)]
        public string State { get; set; }

        public int? Zip { get; set; }

        [StringLength(3)]
        public string Country { get; set; }

        [StringLength(3)]
        public string DrinkingWater { get; set; }

        public string ACTRoute { get; set; }

        [StringLength(130)]
        public string Hours { get; set; }

        [StringLength(42)]
        public string Note { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.0#####}",  ApplyFormatInEditMode = true)]
        [Required(ErrorMessage = "Please make sure that you select a correct location from the map window in order to get the longitude")]
        public decimal? LongDec { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.0#####}", ApplyFormatInEditMode = true)]
        [Required(ErrorMessage = "Please make sure that you select a correct location from the map window in order to get the latitude")]
        public decimal? LatDec { get; set; }

        public DbGeography Geo { get; set; }

        public DateTime? AddDateTime { get; set; }

        public DateTime? UpdDateTime { get; set; }

        public string AddUserId { get; set; }

        public string UpdUserId { get; set;}

        public bool Active { get; set; } = true;

        [NotMapped]
        public int Id
        {
            get { return RestroomId; }
            set { RestroomId = value; }
        }

        [NotMapped]
        public string[] SelectedRoutes { get; set; }

        #endregion

        #region Data Subset Selectors

        private List<SelectListItem> _drinkingWaterOptions;
        private List<SelectListItem> _restroomTypes;
        private List<SelectListItem> _states;
        private List<SelectListItem> _statuses;

        private static List<SelectListItem> _searchStatuses;

        [NotMapped]
        public List<SelectListItem> DrinkingWaterOptions
        {
            get { return _drinkingWaterOptions ?? (_drinkingWaterOptions = new RestroomService().GetDrinkingWaterOptions()); }
            set { _drinkingWaterOptions = value; }
        }

        [NotMapped]
        public List<SelectListItem> RestrooomTypes
        {
            get { return _restroomTypes ?? (_restroomTypes = new RestroomService().GetRestroomTypes()); }
            set { _restroomTypes = value; }
        }

        [NotMapped]
        public List<SelectListItem> States
        {
            get { return _states ?? (_states = new RestroomService().GetStates()); }
            set { _states = value; }
        }

        [NotMapped]
        public List<SelectListItem> Statuses
        {
            get { return _statuses ?? (_statuses = new RestroomService().GetRestroomStatuses()); }
            set { _statuses = value; }
        }

        [NotMapped]
        public string StatusName
        {
            get { return Statuses.Where(s => s.Value == Active.ToString()).Select(s => s.Text).FirstOrDefault(); }

        }

        [NotMapped]
        public static List<SelectListItem> SearchStatuses
        {
            get { return _searchStatuses ?? (_searchStatuses = new RestroomService().GetRestroomStatuses(true)); }
            set { _searchStatuses = value; }
        }

        [NotMapped]
        public string JsonSortedRoutes
        {
            get
            {
                return (ACTRoute != null
                    ? JsonConvert.SerializeObject(ACTRoute.Split(',').OrderByNatural(r => r))
                    : ACTRoute);
            }
        }

        [NotMapped]
        public string SortedRoutes
        {
            get
            {
                return (ACTRoute != null
                    ? string.Join(",", ACTRoute.Split(',').OrderByNatural(r => r))
                    : ACTRoute);
            }
        }

        #endregion
    }
}