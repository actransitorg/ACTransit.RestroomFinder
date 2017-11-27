using ACTransit.DataAccess.RestroomFinder;
using RestroomFinderAPI.Models;

namespace RestroomFinderAPI.Services
{
    public class LogService
    {
        internal void WriteLog(BaseViewModel model, string description)
        {
            using (var db = new RestroomContext())
            {
                var log = new Log
                {
                    DeviceId = model.DeviceId,
                    DeviceOS = model.DeviceOS,
                    DeviceModel = model.DeviceModel,
                    Description = description,
                };
                db.SaveLog(log);
            }
        }
    }
}