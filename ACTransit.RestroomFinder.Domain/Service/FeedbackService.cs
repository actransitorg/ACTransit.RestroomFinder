using System;
using System.Web.Mvc;
using System.Linq;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

using X.PagedList;

using ACTransit.DataAccess.RestroomFinder;

using ACTransit.Framework.DataAccess;
using ACTransit.Framework.DataAccess.Extensions;
using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.Domain.Infrastructure;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class FeedbackService : DomainServiceBase
    {
        public FeedbackService() : base(string.Empty)
        {
        }

        public FeedbackService(string username): base(username)
        {
        }

        public List<SelectListItem> GetFeedbackNeed()
        {
            var need = new List<SelectListItem>
            {
                new SelectListItem() {Text = "Yes", Value = "true", Selected = true},
                new SelectListItem() {Text = "No", Value = "false"}
            };

            return need;
        }

        public async Task<IPagedList<Dto.Feedback>> GetRestroomFeedbackAsync(FeedbackSearchContext search = null)
        {
            var filter = new List<Expression<Func<Feedback, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (search.RestroomId.HasValue) filter.Add(r => r.RestroomId == search.RestroomId.Value);
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "AddDateTime";
            }
            else
                search = new FeedbackSearchContext { SortField = "AddDateTime" };

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<Feedback, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<Feedback>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var feedback = await query
                .DynamicOrderBy(search.SortField,
                    (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString()))
                .ToPagedListAsync(search.PageNumber, search.PageSize);

            return feedback.Select(Converter.ToModel);
        }

        public async Task<Dto.Feedback> GetFeedbackAsync(int feedbackId)
        {
            var feedback = await UnitOfWork.GetByIdAsync<Feedback, int>(feedbackId);
            return Converter.ToModel(feedback);
        }

        public async Task<Dto.Feedback> SaveFeedbackAsync(Dto.Feedback feedback)
        {
            var updatedFeedback = await UnitOfWork.SaveFeedbackAsync(Converter.ToEntity(feedback));
            return Converter.ToModel(updatedFeedback);
        }
    }
}
