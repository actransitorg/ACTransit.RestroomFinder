using System.Web.Mvc;
using System.Configuration;

using ACTransit.RestroomFinder.Domain.Enums;

namespace ACTransit.RestroomFinder.Web.Controllers
{
    public class RestroomReportController : Controller
    {
        private string _restroomListReportLocation = string.Empty;
        private string _restroomFeedbackReportLocation = string.Empty;

        public RestroomReportController()
        {
            _restroomListReportLocation = (ConfigurationManager.AppSettings["Report.RestroomList.Location"] ?? string.Empty);
            _restroomFeedbackReportLocation = (ConfigurationManager.AppSettings["Report.RestroomFeedback.Location"] ?? string.Empty);
        }

        // GET: RestroomReport
        public ActionResult Index(ReportTypes reportType)
        {
            switch (reportType)
            {
                case ReportTypes.Restrooms:
                    ViewBag.Title = "Restroom List Report";
                    ViewBag.ReportLocation = _restroomListReportLocation;
                    break;
                case ReportTypes.Feedback:
                    ViewBag.Title = "Restroom Feedback Report";
                    ViewBag.ReportLocation = _restroomFeedbackReportLocation;
                    break;
            }
            return View();
        }
    }
}