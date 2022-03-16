using System;
using System.Collections.Generic;
using System.Linq;
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
    public class ContactService: DomainServiceBase
    {
        private const string Classname = "ContactService";

        public ContactService() : base(string.Empty)
        {
        }

        public ContactService(string username) : base(username)
        {
        }

        public async Task<IPagedList<Dto.RestroomContact>> GetContactsAsync(ContactSearchContext search = null)
        {
            var filter = new List<Expression<Func<RestroomContact, bool>>>();

            //Parse filters
            if (search != null)
            {
                if (search.ContactId.HasValue) filter.Add(r => r.ContactId == search.ContactId.Value);
                if (!string.IsNullOrEmpty(search.Name)) filter.Add(c => c.ContactName.Contains(search.Name.Trim()));
                if (!string.IsNullOrEmpty(search.ServiceProvider)) filter.Add(c => c.ServiceProvider.Contains(search.ServiceProvider.Trim()));
                if (string.IsNullOrWhiteSpace(search.SortField)) search.SortField = "ContactName";
            }
            else
                search = new ContactSearchContext { SortField = "ContactName" };

            //filter.Add(c => !c.Deleted);

            //Build expression tree
            var whereClause = filter.Aggregate((Expression<Func<RestroomContact, bool>>)null,
                (current, f) => current == null ? f : current.And(f));

            var query = UnitOfWork.Get<RestroomContact>();

            if (whereClause != null)
                query = query.Where(whereClause);

            var contacts = await query
                .DynamicOrderBy(search.SortField, (OrderByDirection)Enum.Parse(typeof(OrderByDirection), search.SortDirection.ToString())).ToListAsync();

            var pagedContacts = search.PageSize == 1
                ? await contacts.ToPagedListAsync(search.PageNumber, contacts.Count)
                : await contacts.ToPagedListAsync(search.PageNumber, search.PageSize);

            return pagedContacts.Select(Converter.ToModel);
        }

        public ICollection<KeyValuePair<string,string>> GetContactSearchStatuses(bool isSearch = false)
        {
            var contactStatuses = new List<KeyValuePair<string, string>>
            {
                new KeyValuePair<string, string>("Yes", "True"),
                new KeyValuePair<string, string>("No", "False")
            };

            if (isSearch)
                contactStatuses.Insert(0, new KeyValuePair<string, string>("Any","Any"));

            return contactStatuses;
        }

        public async Task<Dto.Contact> GetContactAsync(int? contactId)
        {
            var contact = await UnitOfWork.GetByIdAsync<Contact, int?>(contactId);
            return Converter.ToModel(contact);
        }

        public async Task<bool> SoftDeleteContactAsync(int contactId)
        {
            var contact = await UnitOfWork.GetByIdAsync<Contact, int?>(contactId);

            if (contact == null)
                return false;

            //When updating the record ensure that the changes do not require approval
            contact.Deleted = true;

            await UnitOfWork.SaveContactAsync(contact);

            return true;
        }

        public async Task<Dto.Contact> SaveContactAsync(Dto.Contact contact)
        {
            var updatedContact = await UnitOfWork.SaveContactAsync(Converter.ToEntity(contact));
            return Converter.ToModel(updatedContact);
        }
    }
}