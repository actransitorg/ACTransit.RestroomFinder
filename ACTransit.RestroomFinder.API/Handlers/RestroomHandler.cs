using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using ACTransit.Framework.DataAccess.Extensions;
using ACTransit.RestroomFinder.API.Models;
using Newtonsoft.Json;
using Entity= ACTransit.DataAccess.RestroomFinder;

namespace ACTransit.RestroomFinder.API.Handlers
{
    public class RestroomHandler : BaseHandler
    {

        internal async Task<Restroom> GetRestroomAsync(int restroomId)
        {
            Entity.Contact contact = null;
            var restroomD = await RestroomUnitOfWork.GetRestroomAsync(restroomId);
            if (restroomD != null && restroomD.ContactId.HasValue)
                contact = RestroomUnitOfWork.GetById<Entity.Contact,int>(restroomD.ContactId.Value);
            
            return restroomD == null ? null : Restroom.FromDataAccess(restroomD,contact);
        }

        internal List<Restroom> GetRestroomList()
        {
            var result = RestroomUnitOfWork.GetRestroomList();
            return result.Select(Restroom.FromDataAccess)/*.Where(r => r.Active)*/.ToList();
        }

        internal async Task<Restroom> SaveRestroomAsync(Restroom model)
        {
            Entity.Restroom restroom = null;
            if (model.RestroomId > 0)
            {
                var r = await RestroomUnitOfWork.GetRestroomAsync(model.RestroomId);
                restroom = model.ToDataAccessFrom(r);
                Logger.WriteDebug("SaveRestroomAsync->After GetRestroomAsync and ToDataAccessFrom:" + JsonConvert.SerializeObject(restroom));
            }
            else
            {
                restroom = model.ToDataAccess();
                restroom.UpdUserId = CurrentUserName;
            }

            var hasContact = false;
            var contactChanged = false;


            hasContact = !string.IsNullOrWhiteSpace(model.ContactName) ||
                         !string.IsNullOrWhiteSpace(model.ContactTitle) ||
                         !string.IsNullOrWhiteSpace(model.ContactEmail) ||
                         !string.IsNullOrWhiteSpace(model.ContactPhone);
            Entity.Contact contact = null;

            if (!hasContact && restroom.ContactId.HasValue && restroom.ContactId > 0)
            {
                restroom.ContactId = null;
                restroom.Contact = null;
            }
                
            else if (restroom.ContactId.HasValue && restroom.ContactId > 0)
            {
                contact = await RestroomUnitOfWork.GetByIdAsync<Entity.Contact,int>(restroom.ContactId.Value);
                if (contact.ContactName != model.ContactName ||
                    contact.Title != model.ContactTitle ||
                    contact.Email != model.ContactEmail ||
                    contact.Phone != model.ContactPhone || 
                    contact.ServiceProvider != model.ServiceProvider
                )
                    contactChanged = true;
            }
            
            if (contactChanged || (hasContact && (!restroom.ContactId.HasValue || restroom.ContactId == 0)))
            {
                contact = new Entity.Contact
                {
                    Title = model.ContactTitle,
                    Email = model.ContactEmail,
                    Phone = model.ContactPhone,
                    ContactName = model.ContactName,
                    ServiceProvider = model.ServiceProvider
                };
                contact=RestroomUnitOfWork.Create(contact);
                restroom.Contact = contact;
            }

         
            //restroom.Active = true;
            restroom.StatusListId = 1;  // always pending...
            try
            {
                var savedModel = await RestroomUnitOfWork.SaveRestroomAsync(restroom);
                return savedModel == null ? null : Restroom.FromDataAccess(savedModel);
            }
            catch (DbEntityValidationException ex)
            {
                var errTxt = ex.GetStringRepresentation();
                Logger.WriteError("RestroomHandler.SaveRestroomAsync.DbEntityValidationException -> EntityValidationErrors : \r\n" + errTxt);
                throw;
            }
        }
        internal async Task<Restroom[]> GetRestroomsNearbyAsync(string routeAlpha, string direction, float? lat, float? longt, int? distance = null, bool publicRestrooms=true, bool pending=false)
        {
            var restrooms = await RestroomUnitOfWork.GetRestroomsNearbyAsync(routeAlpha, direction, lat, longt, distance, publicRestrooms, pending);
            var contactIds = restrooms.Where(m => m.ContactId.HasValue).Select(m => m.ContactId);
            var contacts = RestroomUnitOfWork.Get<Entity.Contact>().Where(c=>contactIds.Contains(c.ContactId));
            var result = new List<Restroom>();
            foreach(var r in restrooms)
            {
                result.Add(Restroom.FromDataAccess(r, contacts.FirstOrDefault(c => c.ContactId == r.ContactId)));
            }
            //return result.Select(Restroom.FromDataAccess).ToArray();            
            return result.ToArray();
        }
    }
}