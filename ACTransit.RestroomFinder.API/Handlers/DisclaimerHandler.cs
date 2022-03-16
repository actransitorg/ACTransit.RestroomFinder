using System;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Threading.Tasks;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Handlers
{
    /// <summary>
    /// Handles Login and validations.
    /// </summary>
    public class DisclaimerHandler : BaseHandler
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        /// <exception cref="FriendlyException"></exception>
        public async Task DisclaimerResponse(DisclaimerViewModel model)
        {
            const string methodName = "DisclaimerResponse";
            string debugStr="";
            Logger.WriteDebug($"{methodName} called.");

            try
            {
                if (model==null)
                    throw new FriendlyException(FriendlyExceptionType.InvalidModelState);

                if (!model.Agreed)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                if (string.IsNullOrWhiteSpace(model.DeviceSessionId))
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                if (string.IsNullOrWhiteSpace(model.DeviceGuid))
                    throw new FriendlyException(FriendlyExceptionType.DeviceIsNotSupported);

                if (string.IsNullOrWhiteSpace(model.Badge))
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);


                // --------------------------------------some sanity check!
                if (model.Badge?.Length > 10)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "Badge is too long.");

                //----------------------------------------
                var badge = model.Badge?.Trim().PadLeft(6, '0');
                debugStr = "Before getting Demo User for badge: " + badge;

                var user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge);
                if (user==null)
                    throw new FriendlyException(FriendlyExceptionType.AccessHasBeenRevoked, "", debugStr);
                if (!user.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, "", debugStr);

                //var demoUser = await IsDemoUserAsync(operatorInfo.FirstName, operatorInfo.LastName, badge);
                var demoUser = user.IsDemo.GetValueOrDefault(false);

                debugStr = "After getting Demo User: " + demoUser;
                var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(badge);
                debugStr = $"After getting Employee, DemoUser: {demoUser}, Found:{(employee != null)}";


                if (employee == null && !demoUser)
                {
                    var s = $"{methodName}. Employee not found." + $"debugStr: {debugStr}";
                    Logger.Write(s);
                    WriteLog(model, s);
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }
             

                if (demoUser)
                    CurrentUserName = "DemoUser";
                else
                    CurrentUserName = employee.Name;

                debugStr = $"Getting device for {model.DeviceGuid}";
                var device = await RestroomUnitOfWork.Get<Device>()
                    .FirstOrDefaultAsync(m => m.DeviceGuid == model.DeviceGuid);
                if (device == null || !device.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"debugStr: {debugStr}");

                debugStr = $"Getting userDevice for device:{model.DeviceGuid} and user: {user.UserId}";
                var userDevice = await RestroomUnitOfWork.Get<UserDevice>()
                    .FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
                if (userDevice==null || !userDevice.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"debugStr: {debugStr}");


              

                var confirmation = new Confirmation
                {
                    Badge = badge,
                    Agreed = model.Agreed,
                    IncidentDateTime = model.IncidentDateTime,
                    DeviceId = model.DeviceGuid,
                    SessionId = model.DeviceSessionId,
                    Active = true
                };

                RestroomUnitOfWork.PrepConfirmation(confirmation);
                await RestroomUnitOfWork.SaveChangesAsync();


            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                throw;
            }
            catch (DbEntityValidationException ex)
            {
                Logger.WriteError("DbEntityValidationException, debugStr:" + debugStr + ", Error:" + ex.Message);
                foreach (var eve in ex.EntityValidationErrors)
                {
                    Logger.WriteError($"Entity of type \"{eve.Entry.Entity.GetType().Name}\" in state \"{eve.Entry.State}\" has the following validation errors:");
                    foreach (var ve in eve.ValidationErrors)                    
                        Logger.WriteError($"- Property: \"{ve.PropertyName}\", Error: \"{ve.ErrorMessage}\"");
                }
                throw new FriendlyException(FriendlyExceptionType.Other,"Server could not process your request. please try again later.");
            }
            catch (Exception ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                throw new FriendlyException(FriendlyExceptionType.Other, "Server could not process your request. please try again later.");
            }
        }


        //private string CreateDeviceSessionId(OperatorInfoViewModel operatorInfo)
        //{
        //    var expires = DateTime.Now.AddMonths(6);
        //    var userData = new SecurityUserInfo
        //    {
        //        //DeviceId = operatorInfo.DeviceId,
        //        DeviceModel = operatorInfo.DeviceModel,
        //        //DeviceName = operatorInfo.DeviceName,
        //        //Badge = badge,
        //        CreationDateTime = DateTime.Now,
        //        Expires = expires
        //    };
        //    var authTicket = new FormsAuthenticationTicket(
        //        AthenticationVersion,
        //        operatorInfo.DeviceGuid,
        //        DateTime.Now,
        //        expires, // expiry
        //        true, //do not remember
        //        JsonConvert.SerializeObject(userData),
        //        "");
        //    return FormsAuthentication.Encrypt(authTicket);

        //}


        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="firstName"></param>
        ///// <param name="lastName"></param>
        ///// <param name="badge"></param>
        ///// <param name="cardNumber"></param>
        ///// <param name="deviceSessionId"></param>
        ///// <returns></returns>
        //public async Task<bool> IsValidSessionAsync(string firstName, string lastName, string badge, string cardNumber, string deviceSessionId)
        //{
        //    if (string.IsNullOrWhiteSpace(badge) ||  string.IsNullOrWhiteSpace(cardNumber) || string.IsNullOrWhiteSpace(deviceSessionId) )
        //        return false;
        //    try
        //    {
        //        var ticket = FormsAuthentication.Decrypt(deviceSessionId);
        //        if (ticket != null && !ticket.Expired)
        //        {
        //            var userData = ticket.UserData;
        //            if (!string.IsNullOrWhiteSpace(userData))
        //            {
        //                var securityUserInfo = JsonConvert.DeserializeObject<SecurityUserInfo>(userData);
        //                if (securityUserInfo != null)
        //                {

        //                    badge = badge.Trim().PadLeft(6, '0');
        //                    var demoUser = await IsDemoUserAsync(firstName, lastName, badge);
        //                    if (demoUser)
        //                        return true;

        //                    var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(badge);
        //                    Logger.WriteDebug("After getting Employee");
        //                    if (employee == null)
        //                        return false;


        //                    var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceGuid == ticket.Name);
        //                    User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge && (m.FirstName==firstName || (m.MiddleName!=null && m.MiddleName==firstName))&& m.LastName==lastName);


        //                    if (device == null || user == null)
        //                        return false;
        //                    if (!device.Active || device.DeviceSessionId != deviceSessionId)
        //                        return false;
        //                    if (!user.Active)
        //                        return false;

        //                    var userDevice = await RestroomUnitOfWork.Get<UserDevice>().FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
        //                    if (userDevice == null || !userDevice.Active)
        //                        return false;

        //                    return true;
        //                }
        //            }
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.WriteError(ex.Message);
        //        return false;
        //    }



        //    return false;
        //}


        /// <summary>
        /// 
        /// </summary>
        /// <param name="badge"></param>
        /// <param name="deviceGuid"></param>
        /// <param name="deviceSessionId"></param>
        /// <returns></returns>
        public async Task<Tuple<bool, string>> IsValidSessionAsync(string badge, string deviceGuid, string deviceSessionId)
        {
            if (string.IsNullOrWhiteSpace(badge) || string.IsNullOrWhiteSpace(deviceSessionId) || string.IsNullOrWhiteSpace(deviceGuid))
                return new Tuple<bool, string>(false,"");
            try
            {
                badge = badge.Trim().PadLeft(6, '0');

                var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceSessionId == deviceSessionId && m.DeviceGuid==deviceGuid);
                if (device == null || !device.Active)
                    return new Tuple<bool, string>(false, "");

                var user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge && m.Active);
                if (user == null || user.Badge != badge || !user.Active)
                    return new Tuple<bool, string>(false, "");

                var userDevice =await RestroomUnitOfWork.Get<UserDevice>().FirstOrDefaultAsync(m => m.DeviceId==device.DeviceId && m.UserId==user.UserId);
                if (userDevice == null || !userDevice.Active)
                    return new Tuple<bool, string>(false, "");

                //var firstName = user.FirstName;
                //var lastName = user.LastName;
                //var demoUser = await IsDemoUserAsync(operatorInfo.FirstName, operatorInfo.LastName, badge);
                var demoUser = user.IsDemo.GetValueOrDefault(false);

                //var demoUser = await IsDemoUserAsync(firstName, lastName, badge);
                if (demoUser)
                    return new Tuple<bool, string>(true, "");

                var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(user.Badge);
                if (employee == null)// || employee.SecurityCardFormatted != user.SecurityCardFormatted)
                    return new Tuple<bool, string>(false, "");

                return new Tuple<bool, string>(true, employee.JobTitle);


            }
            catch (Exception ex)
            {
                Logger.WriteError(ex.Message);
                return new Tuple<bool, string>(false, "");
            }
        }
        internal async Task<int> InvalidateOperatorAsync(string badge)
        {
            return await RestroomUnitOfWork.InvalidateOperatorAsync(badge);
        }

        //internal async Task<bool> IsDemoUserAsync(string firstName, string lastName, string badge)
        //{
        //    var valueToCompare = $"{badge?.Trim()}.{firstName?.Trim()}.{lastName?.Trim()}";
        //    return await RestroomUnitOfWork.Get<Setting>().AnyAsync(m => m.Name == "DemoUser" && m.Value== valueToCompare && m.Active);
        //}

    }
}