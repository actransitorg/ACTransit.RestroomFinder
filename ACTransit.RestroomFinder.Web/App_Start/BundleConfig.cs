
using System.Web.Optimization;

namespace ACTransit.RestroomFinder.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js", 
                        "~/Scripts/jquery.cookie.js",
                        "~/Scripts/jquery.table2excel.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/common").Include(
                        "~/Scripts/AjaxHelper.js",
                        "~/Scripts/modalBox-*",
                        "~/Scripts/globals.js"
                        ));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new ScriptBundle("~/bundles/magicsuggest").Include(
                    "~/Scripts/magicsuggest-min.js"));

            bundles.Add(new ScriptBundle("~/bundles/mapviewer").Include(
                "~/Scripts/gmap.viewer.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css"
                      ));

            bundles.Add(new StyleBundle("~/Content/sass").Include(
                      "~/Content/site.css",
                      "~/Content/grid.css",
                      "~/Content/Header.css",
                      "~/Content/Footer.css",
                      "~/Content/ModalBox.css",
                      "~/Content/Navbar.css",
                      "~/Content/Navbar_dark.css",
                      "~/Content/Navbar_darkgradient.css"
                      ));

            bundles.Add(new StyleBundle("~/Content/magicsuggestcss").Include(
                      "~/Content/magicsuggest.css"));


//#if DEBUG
//            // Set EnableOptimizations to false for debugging. For more information,
//            // visit http://go.microsoft.com/fwlink/?LinkId=301862
//            BundleTable.EnableOptimizations = false;

//#else
//            // Set EnableOptimizations to false for debugging. For more information,
//            // visit http://go.microsoft.com/fwlink/?LinkId=301862
//            BundleTable.EnableOptimizations = true;
//#endif

        }
    }
}
