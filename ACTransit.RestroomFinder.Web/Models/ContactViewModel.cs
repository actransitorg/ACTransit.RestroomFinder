using ACTransit.RestroomFinder.Domain.Dto;
using X.PagedList;

namespace ACTransit.RestroomFinder.Web.Models
{
    public class ContactViewModel
    {
        public IPagedList<RestroomContact> Contacts { get; set; }

        public Contact CurrentContact { get; set; } = new Contact();
    }
}