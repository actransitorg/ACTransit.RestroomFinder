using System;
using System.Web;
using ACTransit.RestroomFinder.Domain.Service;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public class RequestHelper
    {
        public static string CurrentUserName
        {
            get
            {
                try
                {
                    return HttpContext.Current.User.Identity.Name;
                }
                catch
                {
                    return Environment.UserName;
                }
            }
        }

        public static string SetLogContextName(string controllerName, string actionName)
        {
            var ndc = (controllerName + "." + actionName + " (" + HttpContext.Current.Request.HttpMethod + "):" + CurrentUserName).Trim();
            HttpContext.Current.Items["LogContextName"] = ndc;
            var rc = HttpContext.Current.Items["RequestContext"] as RequestContext;
            if (rc != null)
                rc.LogContextName = ndc;
            return ndc;
        }

        public static void SetLogContextName(System.Web.Http.Controllers.HttpActionDescriptor actionDescriptor)
        {
            log4net.NDC.Clear();
            log4net.NDC.Push(SetLogContextName(actionDescriptor.ControllerDescriptor.ControllerName, actionDescriptor.ActionName));
        }

        public static void SetLogContextName(System.Web.Mvc.ActionDescriptor actionDescriptor)
        {
            log4net.NDC.Clear();
            log4net.NDC.Push(SetLogContextName(actionDescriptor.ControllerDescriptor.ControllerName, actionDescriptor.ActionName));
        }

    }
}