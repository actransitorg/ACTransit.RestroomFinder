using System;
using ACTransit.Framework.Logging;

namespace ACTransit.RestroomFinder.Web.Services
{
    public abstract class ServiceBase<TService>: IDisposable where TService: new()
    {

        #region Fields

        private bool _disposed;
        protected readonly Logger Logger;

        #endregion

        #region Properties

        protected TService Service { get; }

        #endregion

        protected ServiceBase(string currentUser, Func<string,TService> createTService)
        {
            Logger = new Logger(GetType().Name);
            Service = createTService(currentUser);// new TService();
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
                if (Service != null)
                {
                    var thisService = Service as IDisposable;
                    thisService?.Dispose();
                }
            }

            _disposed = true;
        }

        #endregion
    }
}