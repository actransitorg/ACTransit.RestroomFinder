using System;
using System.Linq;
using System.Linq.Expressions;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Domain.Repository
{
    public abstract class DomainRepositoryBase<T> where T: class, IModel, new()
    {
        protected RequestContext RequestContext { get; }

        protected RestroomUnitOfWork daContext { get; set; }

        protected DomainRepositoryBase() { }

        protected DomainRepositoryBase(RequestContext requestContext)
        {
            RequestContext = requestContext;
            Initialize();
        }

        private void Initialize()
        {
            if (daContext == null && RequestContext != null)
                daContext = new RestroomUnitOfWork(RequestContext.CurrentUserName);
        }

        public virtual T GetById<TId>(TId id)
        {
            return daContext.GetById<T, TId>(id);
        }

        public virtual T Get(int id, params Expression<Func<T, object>>[] paths)
        {
            return daContext.Get(paths).FirstOrDefault(wo => wo.Id == id);
        }

        public virtual IQueryable<T> GetAll(params Expression<Func<T, object>>[] paths)
        {
            return daContext.Get(paths);
        }

        public virtual T Save(T item)
        {
            return Save(item, null);
        }

        public virtual T Save(T item, SaveEnum? saveEnum, params Expression<Func<T, object>>[] unChangedProperties)
        {
            if (item == null)
                throw new ArgumentNullException();
            daContext.EnabledProxyCreation();
            var T = daContext.GetById<T, int>(item.Id);
            if (!saveEnum.HasValue)
                saveEnum = T == null ? SaveEnum.New : SaveEnum.Existing;
            T = saveEnum.Value == SaveEnum.New
                ? daContext.Create(item)
                : daContext.Update(item, unChangedProperties);
            daContext.SaveChanges();
            return T;
        }

        public virtual void Delete()
        {
            throw new NotImplementedException();
        }

        public virtual void Delete(int id)
        {
            if (id <= 0)
                throw new ArgumentException("Invalid id");
            daContext.Delete<T, int>(id);
        }
    }
}
