using System.Collections.Generic;
using System.Linq;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Domain.Repository;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public abstract class DomainServiceBase<T> where T: class, IModel, new()
    {
        protected RequestContext RequestContext { get; private set; }
        protected DomainRepositoryBase<T> Repository; // default repository

        protected DomainServiceBase() { }

        protected DomainServiceBase(RequestContext requestContext)
        {
            SetContext(requestContext);
        }

        public void SetContext(RequestContext requestContext)
        {
            RequestContext = requestContext;
            Initialize();
        }

        protected abstract void Initialize();

        public virtual IEnumerable<T> GetAll()
        {
            var items = Repository.GetAll();
            var Ts = items as IList<T> ?? items.ToList();
            if (RequestContext?.ResponseUri == null) return Ts;
            return Ts;
        }

        public virtual T Get(int id)
        {
            var t = Repository.GetById(id);
            return t;
        }

        public virtual T Add(T item)
        {
            var t = Repository.Save(item, SaveEnum.New);
            return t;
        }

        public virtual T Update(int id, T item)
        {
            var t = Repository.Save(item, SaveEnum.Existing);
            return t;
        }

        public virtual void DeleteAll()
        {
            Repository.Delete();
        }

        public virtual void Delete(int id)
        {
            Repository.Delete(id);
        }
    }
}
