using System;
using System.Data.Entity;
using System.Data.Entity.Core;
using System.Data.Entity.Validation;
using System.Threading.Tasks;
using System.Web.Security;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Extensions;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Handlers
{
    /// <summary>
    /// Handles Login and validations.
    /// </summary>
    public class OperatorHandler : BaseHandler
    {
        const int AthenticationVersion = 1;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="operatorInfo"></param>
        /// <returns></returns>
        /// <exception cref="FriendlyException"></exception>
        public async Task<OperatorInfoViewModel> GetOperatorInfoAsync(OperatorInfoViewModel operatorInfo)
        {
            string debugStr="";
            Logger.WriteDebug("GetOperatorInfoAsync called.");

            try
            {
                if (!operatorInfo.Agreed)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                if (string.IsNullOrWhiteSpace(operatorInfo.DeviceGuid))
                    throw new FriendlyException(FriendlyExceptionType.DeviceIsNotSupported);

                if (!operatorInfo.Validating && string.IsNullOrWhiteSpace(operatorInfo.Badge))
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                //if (!operatorInfo.Validating && string.IsNullOrWhiteSpace(operatorInfo.CardNumber))
                //    throw new FriendlyException(FriendlyExceptionType.AccessDenied);


                if (operatorInfo.Validating && string.IsNullOrWhiteSpace(operatorInfo.DeviceSessionId))
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedSessionMismatch);

                // --------------------------------------some sanity check!
                if ((operatorInfo.FirstName?.Length ?? 0) > 255)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "FirstName is too long.");
                if ((operatorInfo.LastName?.Length ?? 0) > 255)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "LastName is too long.");
                if ((operatorInfo.Badge?.Length ?? 0) > 10)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "Badge is too long.");
                //if ((operatorInfo.CardNumber?.Length ?? 0) > 25)
                //    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "Card number is too long.");

                //----------------------------------------



                var badge = operatorInfo.Badge?.Trim().PadLeft(6, '0');
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
                    var s = $"GetOperatorInfo. Employee not found." + $"debugStr: {debugStr}";
                    Logger.Write(s);
                    WriteLog(operatorInfo, s);
                    //await InvalidateOperatorAsync(badge);
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }
                else if (employee != null && (
                             !string.Equals(employee.LastName, operatorInfo.LastName, StringComparison.OrdinalIgnoreCase) ||
                             //!string.Equals(employeeCardNumber, cardNumber, StringComparison.OrdinalIgnoreCase) ||

                             //!employee.SecurityCardEnabled.GetValueOrDefault(false) ||  // After the issue raise with one of the employees "Joseph Seibel", Michael decided to disabled this check
                             (!string.Equals(employee.FirstName, operatorInfo.FirstName, StringComparison.OrdinalIgnoreCase) &&
                              !string.Equals(employee.MiddleName, operatorInfo.FirstName, StringComparison.OrdinalIgnoreCase)))
                )
                {
                    //var s =  $"GetOperatorInfo. Employee badge: {badge} found but names or card # {cardNumber} were not match.";
                    var s = $"GetOperatorInfo. Employee badge: {badge} found but names were not match.";
                    s += $"Entered: FirstName: {employee?.FirstName??""}, LastName: {employee?.LastName??""}";
                    Logger.Write(s);
                    WriteLog(operatorInfo, s);
                    //await InvalidateOperatorAsync(badge);
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }


                if (demoUser)
                    CurrentUserName = "DemoUser";
                else
                    CurrentUserName = employee.Name;


                var device = await RestroomUnitOfWork.Get<Device>()
                    .FirstOrDefaultAsync(m => m.DeviceGuid == operatorInfo.DeviceGuid);
                //User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge);

                //if (!string.Equals(user?.LastName, operatorInfo.LastName) ||
                //    (!string.Equals(user?.FirstName, operatorInfo.FirstName) &&
                //     !string.Equals(user?.MiddleName, operatorInfo.FirstName)))
                //    user = null;

                //debugStr = $"after getting device and user. DeviceGuid:{operatorInfo.DeviceGuid}, Badge: {badge}";

                if (!demoUser)
                {
                    if (operatorInfo.Validating && device == null)
                        throw new FriendlyException(FriendlyExceptionType.AccessDenied,"", debugStr);

                    if (device != null && !device.Active)
                        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive,
                            $"debugStr: {debugStr}");
                }

                //if (user != null && !user.Active)
                //    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive,"", debugStr);


                if (operatorInfo.Validating && (device == null || !device.Active ||
                                                device.DeviceSessionId != operatorInfo.DeviceSessionId))
                {
                    if (device == null)
                        throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                    if (!device.Active)
                        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive);
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedSessionMismatch);
                }

                if (operatorInfo.Validating && (user == null || !user.Active))
                    throw new FriendlyException(user == null
                        ? FriendlyExceptionType.AccessHasBeenRevoked
                        : FriendlyExceptionType.AccessDeniedNotActive);

                UserDevice userDevice = null;
                if (device != null)
                    userDevice = await RestroomUnitOfWork.Get<UserDevice>()
                        .FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
                if (device == null)
                {
                    device = new Device
                    {
                        Active = true, //demoUser,
                        DeviceGuid = operatorInfo.DeviceGuid,
                        DeviceModel = operatorInfo.DeviceModel,
                        DeviceOS = operatorInfo.DeviceOS,
                        LastUsed = DateTime.Now
                    };
                    device.DeviceSessionId = Guid.NewGuid().ToString(); //CreateDeviceSessionId(operatorInfo);
                }
                else
                {
                    //try
                    //{
                        if (operatorInfo.Validating && device.DeviceSessionId != operatorInfo.DeviceSessionId)
                        {
                            Logger.WriteError($"Badge:{badge}, Validating but sessions are not match!");
                            throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                        }
                            
                        if (device.DeviceSessionId != operatorInfo.DeviceSessionId)
                            device.DeviceSessionId = Guid.NewGuid().ToString();

                        //var ticket = FormsAuthentication.Decrypt(device.DeviceSessionId);
                        //if (ticket == null || ticket.Name != operatorInfo.DeviceGuid)
                        //    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                            //if (ticket.Expired)
                            //    device.DeviceSessionId = CreateDeviceSessionId(operatorInfo);
                    //}
                    //catch (Exception ex)
                    //{
                    //    Logger.WriteError(ex.Message);
                    //    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                    //}

                }

                if (user == null)
                {
                    user = new User
                    {
                        Active = true,
                        Badge = badge,
                    };
                }

                user.SecurityCardFormatted = employee?.SecurityCardFormatted;
                user.FirstName = demoUser?"Demo":(employee?.FirstName ?? "");
                user.LastName = demoUser?"User":(employee?.LastName ?? "");
                user.MiddleName = employee?.MiddleName ?? "";


                var confirmation = new Confirmation
                {
                    Badge = badge,
                    Agreed = operatorInfo.Agreed,
                    IncidentDateTime = operatorInfo.IncidentDateTime,
                    DeviceId = operatorInfo.DeviceGuid,
                    Active = true
                };


                device.LastUsed = DateTime.Now;

                user = RestroomUnitOfWork.PrepUser(user);
                device = RestroomUnitOfWork.PrepDevice(device);
                confirmation = RestroomUnitOfWork.PrepConfirmation(confirmation);
                await RestroomUnitOfWork.SaveChangesAsync();

                if (userDevice == null)
                {
                    userDevice = new UserDevice();
                    userDevice.Active =
                        true; //demoUser || device.DeviceId==default(long) || (!string.IsNullOrWhiteSpace(operatorInfo.DeviceSessionId) && operatorInfo.DeviceSessionId == device.DeviceSessionId);
                }

                userDevice.LastLogon = DateTime.Now;
                userDevice.UserId = user.UserId;
                userDevice.DeviceId = device.DeviceId;

                userDevice = await RestroomUnitOfWork.SaveUserDeviceAsync(userDevice);




                operatorInfo.DeviceSessionId = device.DeviceSessionId;
                operatorInfo.SessionApproved = user.Active && userDevice.Active && device.Active;

            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                if (ex.ExceptionType != FriendlyExceptionType.AccessDeniedNotActive)
                    throw;
                operatorInfo.SessionApproved = false;
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
                operatorInfo.SessionApproved = false;
            }
            catch (Exception ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);                
                operatorInfo.SessionApproved = false;
            }
            return operatorInfo;

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
        public async Task<Tuple<bool, string, string>> IsValidSessionAsync(string badge, string deviceGuid, string deviceSessionId)
        {
            if (string.IsNullOrWhiteSpace(badge) || string.IsNullOrWhiteSpace(deviceSessionId) || string.IsNullOrWhiteSpace(deviceGuid))
                return new Tuple<bool, string,string>(false,"", "");
            try
            {
                badge = badge.Trim().PadLeft(6, '0');

                var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceSessionId == deviceSessionId && m.DeviceGuid==deviceGuid);
                if (device == null || !device.Active)
                    return new Tuple<bool, string, string>(false, "", "");

                var user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge && m.Active);
                if (user == null || user.Badge != badge || !user.Active)
                    return new Tuple<bool, string, string>(false, "", "");

                var userDevice =await RestroomUnitOfWork.Get<UserDevice>().FirstOrDefaultAsync(m => m.DeviceId==device.DeviceId && m.UserId==user.UserId);
                if (userDevice == null || !userDevice.Active)
                    return new Tuple<bool, string, string>(false, "", "");

                //var firstName = user.FirstName;
                //var lastName = user.LastName;
                //var demoUser = await IsDemoUserAsync(operatorInfo.FirstName, operatorInfo.LastName, badge);
                var demoUser = user.IsDemo.GetValueOrDefault(false);

                //var demoUser = await IsDemoUserAsync(firstName, lastName, badge);
                if (demoUser)
                    return new Tuple<bool, string, string>(true, "", "demo-user");

                var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(user.Badge);
                if (employee == null)// || employee.SecurityCardFormatted != user.SecurityCardFormatted)
                    return new Tuple<bool, string, string>(false, "", "");

                return new Tuple<bool, string, string>(true, employee.JobTitle, employee.NTLogin);


            }
            catch (Exception ex)
            {
                Logger.WriteError(ex.Message);
                return new Tuple<bool, string, string>(false, "","");
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