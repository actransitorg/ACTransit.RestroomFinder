using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.Domain.Dto;
using ACTransit.RestroomFinder.Domain.Enums;
using ACTransit.RestroomFinder.Domain.Service;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using X.PagedList;

namespace ACTransit.RestroomFinder.Web.Models
{
    public class RestroomViewModel
    {
        private static List<SelectListItem> _statuses;
        private static List<SelectListItem> _drinkingWaterOptions;
        private static List<SelectListItem> _restroomTypes;
        private static List<SelectListItem> _scopes;
        private static List<SelectListItem> _toiletOptions;
        private static List<SelectListItem> _feedbackNeed;
        private static List<SelectListItem> _contacts;
        private static List<SelectListItem> _searchStatuses;
        private static List<SelectListItem> _searchScopes;
        private static List<SelectListItem> _searchReviewStatuses;
        private static List<SelectListItem> _searchToiletOptions;

        public IPagedList<Restroom> ApprovedRestrooms { get; set; } = new PagedList<Restroom>(null, 1, 1);

        public IPagedList<Feedback> RestroomFeedback { get; set; } = new PagedList<Feedback>(null, 1, 1);

        public IPagedList<RestroomContact> RestroomContacts { get; set; } = new PagedList<RestroomContact>(null, 1, 1);

        public IEnumerable<Restroom> ReviewRestrooms { get; set; } = Enumerable.Empty<Restroom>();
        public IEnumerable<RestroomHistory> RestroomHistory { get; set; } = Enumerable.Empty<RestroomHistory>();

        public IEnumerable<RestroomsByDivision> RestroomsByDivision { get; set; } = Enumerable.Empty<RestroomsByDivision>();

        public IEnumerable<RestroomsByRoutes> RestroomsByRoute { get; set; } = Enumerable.Empty<RestroomsByRoutes>();

        public Restroom CurrentRestroom { get; set; } = new Restroom
        {
            StatusListId = (int)RestroomEnums.RestroomApprovalStatus.Approved,
            Country = "USA",
            //Active = true,
            RestroomType = "NON-PAID"
        };

        public List<SelectListItem> ToiletGenders { get; set; } = new List<SelectListItem>();

        public RestroomContact CurrentContact { get; set; }

        public Feedback CurrentFeedback { get; set; } = new Feedback
        {
            InspectionPassed = false,
            NeedsCleaning = true,
            NeedsRepair = true,
            NeedsSupply = true
        };

        public IEnumerable<RestroomContactReport> RestroomContactReport { get; set; } = Enumerable.Empty<RestroomContactReport>();

        public static List<SelectListItem> RestroomTypes => _restroomTypes ?? (_restroomTypes = new RestroomService().GetRestroomTypes());

        public static List<SelectListItem> DrinkingWaterOptions => _drinkingWaterOptions ?? (_drinkingWaterOptions = new RestroomService().GetDrinkingWaterOptions());

        public static List<SelectListItem> Scopes => _scopes ?? (_scopes = new RestroomService().GetVisibilityStatuses());

        public static List<SelectListItem> Statuses => _statuses ?? (_statuses = new RestroomService().GetRestroomStatuses());

        public static List<SelectListItem> ToiletOptions => _toiletOptions ?? (_toiletOptions = new RestroomService().GetToiletOptions());

        public static List<SelectListItem> SearchStatuses => _searchStatuses ?? (_searchStatuses = new RestroomService().GetRestroomStatuses(true));

        public static List<SelectListItem> SearchToiletOptions => _searchToiletOptions ?? (_searchToiletOptions = new RestroomService().GetToiletOptions(true));

        public static List<SelectListItem> VisibilityStatuses => _searchScopes ?? (_searchScopes = new RestroomService().GetVisibilityStatuses(true));

        public static List<SelectListItem> ReviewStatuses => _searchReviewStatuses ?? (_searchReviewStatuses = new RestroomService().GetPendingReviewStatuses());


        public static List<SelectListItem> FeedbackNeed => _feedbackNeed ?? (_feedbackNeed = new FeedbackService().GetFeedbackNeed());

        public static string GetDrinkingWaterOptionName(string waterOptionValue)
        {
            return DrinkingWaterOptions.Where(s => s.Value.Equals(waterOptionValue.ToString(), System.StringComparison.CurrentCultureIgnoreCase))
                                       .Select(s => s.Text)
                                       .FirstOrDefault();
        }

        public static string GetRestroomType(string restroomType)
        {
            return RestroomTypes.Where(s => s.Value.Equals(restroomType, System.StringComparison.CurrentCultureIgnoreCase))
                .Select(s => s.Text)
                .FirstOrDefault();
        }

        public static string GetStatusName(int statusId)
        {
            return Statuses.Where(s => s.Value.Equals(statusId.ToString(), System.StringComparison.CurrentCultureIgnoreCase))
                           .Select(s => s.Text)
                           .FirstOrDefault();
        }

        public static string GetVisibilityName(bool? visibilityValue)
        {
            return Scopes.Where(s => s.Value.Equals(visibilityValue.ToString(), System.StringComparison.CurrentCultureIgnoreCase))
                        .Select(s => s.Text)
                        .FirstOrDefault();
        }

        public static string GetIsToiletAvailableName(bool isToiletAvailableValue)
        {
            return ToiletOptions.Where(s => s.Value.Equals(isToiletAvailableValue.ToString(), System.StringComparison.CurrentCultureIgnoreCase))
                        .Select(s => s.Text)
                        .FirstOrDefault();
        }

        public static string GetChangeColorCode(string newValue, string oldValue)
        {
            string changeType;
            string parsedNewValue = newValue?.Trim() ?? string.Empty;
            string parsedOldValue = oldValue?.Trim() ?? string.Empty;

            if (parsedNewValue.Equals(parsedOldValue, System.StringComparison.InvariantCultureIgnoreCase))
                changeType = RestroomEnums.RestroomChangeType.None.Description();
            else
            {
                if (string.IsNullOrEmpty(parsedNewValue) && !string.IsNullOrEmpty(parsedOldValue))
                    changeType = RestroomEnums.RestroomChangeType.Deleted.Description();
                else if (!string.IsNullOrEmpty(parsedNewValue) && string.IsNullOrEmpty(parsedOldValue))
                    changeType = RestroomEnums.RestroomChangeType.Added.Description();
                else
                    changeType = RestroomEnums.RestroomChangeType.Updated.Description();
            }

            return changeType;
        }
    }
}