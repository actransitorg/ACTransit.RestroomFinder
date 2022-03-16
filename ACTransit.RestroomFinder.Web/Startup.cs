using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ACTransit.RestroomFinder.Web.Startup))]
namespace ACTransit.RestroomFinder.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
           // ConfigureAuth(app);
        }
    }
}
