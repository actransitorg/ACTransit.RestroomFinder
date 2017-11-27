namespace ACTransit.RestroomFinder.Web.Controllers.Base
{
    public class ServiceBaseController<T> : BaseController where T : class, new()
    {
        protected T Service;

        protected ServiceBaseController()
        {
            Service = new T();
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
            if (Service != null)
            {
                //todo is needed
                //Service.Dispose();
                Service = null;
            }
        }
    }
}