using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using ACTransit.Framework.DataAccess;
using ACTransit.Framework.DataAccess.Extensions;

namespace ACTransit.DataAccess.RestroomFinder
{
    public class RestroomUnitOfWork : UnitOfWorkBase<RestroomContext>
    {
        public RestroomUnitOfWork() : this(new RestroomContext(), null) { }
        public RestroomUnitOfWork(RestroomContext context) : this(context, null) { }
        public RestroomUnitOfWork(string currentUserName) : this(new RestroomContext(), currentUserName) { }

        public RestroomUnitOfWork(RestroomContext context, string currentUserName) : base(context)
        {
            CurrentUserName = currentUserName;
            context.Configuration.ProxyCreationEnabled = false;
        }

        public void EnabledProxyCreation()
        {
            Context.Configuration.ProxyCreationEnabled = false;
        }


        public object GetEntityKeyValue<T>(T entity) where T : class, new()
        {
            var keyvalues = Context.CreateEntityKey(entity);
            if (keyvalues == null || keyvalues.Length == 0)
                throw new MissingPrimaryKeyException();
            //if (keyvalues.Length>1) 
            //    throw new Exception("more than one Key found.");
            return keyvalues.Length > 1 ? keyvalues : keyvalues[0].Value;
        }


        /// <summary>
        /// Update the entered entity. This funtion won't update the properties past to unChangedProperties parameter.
        /// </summary>
        /// <typeparam name="T">Type of the object to update</typeparam>
        /// <param name="entity">The object to save into database.</param>
        /// <param name="unChangedProperties">list of properties that should not to be changed by this operation.</param>
        /// <returns>returns the updated entity.</returns>
        public T Update<T>(T entity, params Expression<Func<T, object>>[] unChangedProperties) where T : class, new()
        {
            var attachedEntity = Context.AttachToOrGet(entity);
            Context.Entry(attachedEntity).CurrentValues.SetValues(entity);

            if (attachedEntity.Equals(entity))
                Context.Entry(attachedEntity).State = EntityState.Modified;
            if (unChangedProperties != null)
            {
                foreach (var prop in unChangedProperties)
                    Context.Entry(attachedEntity).Property(prop).IsModified = false;
            }

            ApplyPreSaveChanges(attachedEntity, false);
            entity = attachedEntity;
            return entity;
        }
    }
}
