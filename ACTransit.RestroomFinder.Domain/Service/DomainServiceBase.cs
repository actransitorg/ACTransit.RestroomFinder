using System;

using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Logging;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public abstract class DomainServiceBase: IDisposable
    {
        protected RestroomUnitOfWork UnitOfWork;

        private bool _disposed;

        private Logger Logger;

        protected DomainServiceBase(string username)
        {
            UnitOfWork = new RestroomUnitOfWork(username);
            Logger = new Logger();
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
