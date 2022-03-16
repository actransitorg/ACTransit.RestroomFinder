using System;
using System.Web;
using log4net;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class LogHelper
    {
        public static string TypeName(this Type T)
        {
            var tname = T.Name;
            if (T.GetGenericArguments().Length > 0)
                tname = T.Name.Replace("`1", "") + "<" + T.GetGenericArguments()[0].Name + ">";
            return tname;
        }
    }

    public class Log<T> where T: class
    {
        private readonly ILog log;
        private string typeName;
        private readonly string ndc;

        public Log(string ndc = null)
        {
            typeName = typeof(T).TypeName();
            log = LogManager.GetLogger(typeName);
            if (!string.IsNullOrEmpty(ndc))
                this.ndc = ndc;
            else
                this.ndc = HttpContext.Current.Items["LogContextName"]?.ToString();
            if (string.IsNullOrEmpty(this.ndc) && NDC.Depth == 1)
            {
                this.ndc = NDC.Pop();
                init();
            }
        }

        private void init()
        {
            if (ndc != null && NDC.Depth == 0)
                NDC.Push(ndc);
        }

        public void Info(object message, Exception exception)
        {
            init();
            log.Info(message, exception);
            while ((exception = exception.InnerException) != null)
                log.Info(exception);
        }

        public void Info(object message)
        {
            init();
            log.Info(message);
            var exception = message as Exception;
            if (exception == null) return;
            while ((exception = exception.InnerException) != null)
                log.Info(exception);
        }

        public void InfoFormat(IFormatProvider provider, string format, params object[] args)
        {
            init();
            log.InfoFormat(provider, format, args);
        }


        public void Debug(object message, Exception exception)
        {
            init();
            log.Debug(message, exception);
            while ((exception = exception.InnerException) != null)
                log.Debug(exception);

        }

        public void Debug(object message)
        {
            init();
            log.Debug(message);
            var exception = message as Exception;
            if (exception == null) return;
            while ((exception = exception.InnerException) != null)
                log.Debug(exception);
        }

        public void DebugFormat(IFormatProvider provider, string format, params object[] args)
        {
            init();
            log.DebugFormat(provider, format, args);
        }


        public void Error(object message, Exception exception)
        {
            init();
            log.Error(message, exception);
            while ((exception = exception.InnerException) != null)
                log.Error(exception);
        }

        public void Error(object message)
        {
            init();
            log.Error(message);
            var exception = message as Exception;
            if (exception == null) return;
            while ((exception = exception.InnerException) != null)
                log.Error(exception);
        }

        public void ErrorFormat(IFormatProvider provider, string format, params object[] args)
        {
            init();
            log.ErrorFormat(provider, format, args);
        }


        public void Fatal(object message, Exception exception)
        {
            init();
            log.Fatal(message, exception);
            while ((exception = exception.InnerException) != null)
                log.Fatal(exception);
        }

        public void Fatal(object message)
        {
            init();
            log.Fatal(message);
            var exception = message as Exception;
            if (exception == null) return;
            while ((exception = exception.InnerException) != null)
                log.Fatal(exception);
        }

        public void FatalFormat(IFormatProvider provider, string format, params object[] args)
        {
            init();
            log.FatalFormat(provider, format, args);
        }
    }
}