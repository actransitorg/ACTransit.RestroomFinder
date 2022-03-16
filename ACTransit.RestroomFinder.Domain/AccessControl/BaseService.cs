using System;

namespace ACTransit.RestroomFinder.Domain.AccessControl
{
    public abstract class BaseService : IDisposable
    {
        protected bool _disposed;

        public void Dispose()
        {
            GC.SuppressFinalize(this);
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                
            }

            _disposed = true;
        }
    }
}