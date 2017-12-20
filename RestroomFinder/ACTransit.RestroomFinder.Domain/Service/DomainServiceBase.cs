using System;
using System.Collections.Generic;
using System.Linq;

using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Logging;
using ACTransit.RestroomFinder.Domain.Repository;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public abstract class DomainServiceBase<T>: IDisposable where T: class, IModel, new()
    {
        private bool _disposed;

        protected RequestContext RequestContext { get; private set; }
        protected DomainRepositoryBase<T> Repository; // default repository
        protected readonly Logger Logger;

        protected DomainServiceBase(): this(new RequestContext()) { }

        protected DomainServiceBase(RequestContext requestContext)
        {
            Logger = new Logger();
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

        #region Logging

        protected void LogDebug(string methodName, string message)
        {
            Logger.WriteDebug(message);
        }

        protected void LogInfo(string methodName, string message)
        {
            Logger.Write(message);
        }

        protected void LogError(string methodName, string message)
        {
            Logger.WriteError(message);
        }

        protected void LogFatal(string methodName, string message)
        {
            Logger.WriteFatal(message);
        }

        #endregion

        #region IDisposable Implementation

        public void Dispose()
        {
            LogDebug("Dispose", "Called.");
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                //TODO: Anything to dispose?
            }

            _disposed = true;
        }

        #endregion
    }
}
