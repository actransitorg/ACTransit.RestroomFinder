using System.Threading.Tasks;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Services
{
    internal class LogService: BaseService
    {
        internal async Task<Log> WriteLogAsync(BaseViewModel model, string description)
        {

            var log = new Log
            {
                DeviceId = model.DeviceGuid,
                DeviceOS = model.DeviceOS,
                DeviceModel = model.DeviceModel,
                Description = description,
            };
            //using (var db = new RestroomContext())
            //{
            //    db.SaveLog(log);
            //}

            return await RestroomUnitOfWork.SaveLogAsync(log);
        }
    }
}