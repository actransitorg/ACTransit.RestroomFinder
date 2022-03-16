using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Extensions;
using ACTransit.Framework.Notification;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Handlers
{
    /// <summary>
    /// Handles Login and validations.
    /// </summary>
    public class AuthenticationHandler : BaseHandler
    {
        const int ValidInMinutes2FactAuth = 5;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="authModel"></param>
        /// <returns></returns>
        /// <exception cref="FriendlyException"></exception>
        public async Task<bool> SendSecurityCode(AuthenticationViewModel authModel)
        {
            
            string debugStr="";
            Logger.WriteDebug("SendSecurityCode called.");
            try
            {
                authModel = SanitizeModel(authModel);
            }
            catch (Exception e)
            {
                return false;
            }

            var firstName = authModel.FirstName;
            var lastName = authModel.LastName;
            var middleName = "";
            var securityCardFormatted = "";

            try
            {
                //User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == authModel.Badge && m.FirstName == firstName && m.LastName == lastName);
                // I am not going to match the FirstName and LastName against RestroomFinder User Table because if a person changes his/her firsName/lastname, eventhough EDW has the new name, checking against our 
                // application database will cause save error because the user (below) returns null, so we try to create a new user with the the same badge which already exists with different name/lastname exists in the database and badge is unique!
                // We only need to validate FistName and LastName against EmployeeDW (we are doing below)
                User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == authModel.Badge);
                if (user != null && !user.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"user is not active.",debugStr);
                var demoUser = user?.IsDemo.GetValueOrDefault(false)?? false;
                //var demoUser = await IsDemoUserAsync(authModel.FirstName, authModel.LastName, authModel.Badge);
                //debugStr = "After getting Demo User: " + demoUser;
                //if (demoUser)
                //    return true;

                if (!demoUser)
                {
                    var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(authModel.Badge);
                    debugStr = $"After getting Employee, Found:{(employee != null)}";

                    if (employee == null)
                        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" User not found.", debugStr);
                    if (!string.Equals(employee.FirstName, firstName, StringComparison.OrdinalIgnoreCase) || !string.Equals(employee.LastName, lastName, StringComparison.OrdinalIgnoreCase))
                        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" User names are not match.", debugStr);
                    middleName = employee.MiddleName;
                    securityCardFormatted = employee.SecurityCardFormatted;
                }

                debugStr = "Before PrepareUserDevice.";
                var device=await PrepareUserDevice(authModel, user, middleName, securityCardFormatted);

                debugStr = $"Before SendSecurityCodeBySms. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}, Phone: {authModel.PhoneNumber}";
                // For development, I am temporarily comment this.
                await SendSecurityCodeBySms(authModel.PhoneNumber, $"Your ACTransit RestroomFinder security code is: {device.Confirm2FACode}\r\n Enter at SecurityCode field w/in 5 minutes.");

                return true;
            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                if (ex.ExceptionType != FriendlyExceptionType.AccessDeniedNotActive)
                    throw;
                authModel.SessionApproved = false;
                return false;
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
                authModel.SessionApproved = false;
                return false;
            }
            catch (Exception ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                authModel.SessionApproved = false;
                return false;
            }


        }

        public async Task<AuthenticationViewModel> ValidateSecurityCode(AuthenticationViewModel authModel)
        {

            string debugStr = "";
            Logger.WriteDebug("ValidateSecurityCode called.");

            var jobTitle = "";
            try
            {
                authModel = SanitizeModel(authModel);


                User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == authModel.Badge);
                if (user == null || !user.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"user is not active.", debugStr);

                var demoUser = user.IsDemo.GetValueOrDefault(false);
                //var demoUser = await IsDemoUserAsync(authModel.FirstName, authModel.LastName, authModel.Badge);
                //debugStr = "After getting Demo User: " + demoUser;
                //if (demoUser)
                //{
                //    authModel.SessionApproved = true;
                //    authModel.DeviceSessionId = Guid.NewGuid().ToString();
                //    return authModel;
                //}

                
                if (demoUser)
                {
                    var tempDevice = await PrepareUserDevice(authModel, user, "", "");
                    authModel.SessionApproved = true;
                    authModel.DeviceSessionId = tempDevice.DeviceSessionId;
                    return authModel;
                }

                var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(authModel.Badge);
                debugStr = $"After getting Employee, Found:{(employee != null)}";

                if (employee == null)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" User not found.", debugStr);

                jobTitle = employee.JobTitle;


                var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceGuid == authModel.DeviceGuid);

                debugStr = $"after getting device and user. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}";

                if (device == null || !device.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" device is not Active.", debugStr);



                debugStr = $"after getting device and user. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}, UserId:{user.UserId}, DeviceId:{device.DeviceId}";

                UserDevice userDevice;
                    userDevice = await RestroomUnitOfWork.Get<UserDevice>()
                        .FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
                if (userDevice==null || !userDevice.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"userDevice is not active.", debugStr);

                debugStr =
                    $"before checking 2Factor Auth. Client 2FACode:{authModel.Confirm2FACode},  DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}, UserId:{user.UserId}, DeviceId:{device.DeviceId}" +
                    $", 2FACode Expires:{device.Confirm2FAExpires?.ToString("yyyy-MM-dd HH:mm:ss")}";
                if (device.Confirm2FAExpires>=DateTime.Now &&  device.Confirm2FACode == authModel.Confirm2FACode)
                {
                    device.Confirmed2FACode = true;
                    device.DeviceSessionId = Guid.NewGuid().ToString();
                }
                else
                    throw new FriendlyException(FriendlyExceptionType.InvalidOrExpired2FAuth, $"Security Code is invalid or expired.", debugStr);

                device = RestroomUnitOfWork.PrepDevice(device);
                await RestroomUnitOfWork.SaveChangesAsync();

                authModel.CanAddRestroom = Config.JobTitlesAccessToAddRestroom.Any(m=>m==jobTitle) ;
                authModel.CanEditRestroom= Config.JobTitlesAccessToEditRestroom.Any(m => m == jobTitle);

                authModel.DeviceSessionId = device.DeviceSessionId;
                authModel.SessionApproved = true;

                
            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                if (ex.ExceptionType != FriendlyExceptionType.AccessDeniedNotActive)
                    throw;
                authModel.SessionApproved = false;
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
                authModel.SessionApproved = false;
            }
            catch (Exception ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                authModel.SessionApproved = false;
            }

            return authModel;



        }

        public async Task<AuthenticationViewModel> Authenticate(AuthenticationViewModel authModel)
        {
            string debugStr = "";
            Logger.WriteDebug("Authenticate called.");

            try
            {
                authModel = SanitizeModel(authModel);

                if (string.IsNullOrWhiteSpace(authModel.DeviceGuid))
                    throw new FriendlyException(FriendlyExceptionType.DeviceIsNotSupported);

                if (string.IsNullOrWhiteSpace(authModel.DeviceSessionId))
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedSessionMismatch);


                var badge = authModel.Badge;
                debugStr = "Before getting User for badge: " + badge;
                User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge);
                if (user == null || !user.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"user is not active.", debugStr);
                var demoUser = user.IsDemo.GetValueOrDefault(false);
                debugStr = "After getting User, isDemoUser: " + demoUser;

                if (demoUser)
                {
                    authModel.CanAddRestroom = false;
                    authModel.CanEditRestroom= false;
                    authModel.SessionApproved = true;
                    return authModel;
                }
                var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(badge);
                debugStr = $"After getting Employee, Found:{(employee != null)}";

                if (employee == null )
                {
                    var s = $"Authenticate. Employee not found." + $"debugStr: {debugStr}";
                    Logger.Write(s);
                    WriteLog(authModel, s);
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }
                else if (
                             !string.Equals(employee.LastName, authModel.LastName, StringComparison.OrdinalIgnoreCase) ||
                             (!string.Equals(employee.FirstName, authModel.FirstName, StringComparison.OrdinalIgnoreCase) &&
                              !string.Equals(employee.MiddleName, authModel.FirstName, StringComparison.OrdinalIgnoreCase))
                )
                {
                    //var s =  $"GetOperatorInfo. Employee badge: {badge} found but names or card # {cardNumber} were not match.";
                    var s = $"GetOperatorInfo. Employee badge: {badge} found but names were not match.";
                    s += $"Entered: FirstName: {employee?.FirstName ?? ""}, LastName: {employee?.LastName ?? ""}";
                    Logger.Write(s);
                    WriteLog(authModel, s);
                    //await InvalidateOperatorAsync(badge);
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }


                CurrentUserName = employee.Name;


                var device = await RestroomUnitOfWork.Get<Device>()
                    .FirstOrDefaultAsync(m => m.DeviceGuid == authModel.DeviceGuid);
                if (device == null || !device.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive);

                //User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge);
                //debugStr = $"after getting device and user. DeviceGuid:{authModel.DeviceGuid}, Badge: {badge}";

                //if (user==null || !user.Active)
                //    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, debugStr);

                UserDevice userDevice = null;
                userDevice = await RestroomUnitOfWork.Get<UserDevice>()
                        .FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
                if (userDevice==null || !userDevice.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);

                if (device.DeviceSessionId != authModel.DeviceSessionId)
                {
                    Logger.WriteError($"Badge:{badge}, Sessions are not match!");
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied);
                }


                authModel.CanAddRestroom = Config.JobTitlesAccessToAddRestroom.Any(m => m == employee.JobTitle);
                authModel.CanEditRestroom = Config.JobTitlesAccessToEditRestroom.Any(m => m == employee.JobTitle);

                authModel.DeviceSessionId = device.DeviceSessionId;
                authModel.SessionApproved = true;

            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                if (ex.ExceptionType != FriendlyExceptionType.AccessDeniedNotActive)
                    throw;
                authModel.CanAddRestroom = false;
                authModel.CanEditRestroom = false;
                authModel.SessionApproved = false;
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
                authModel.CanAddRestroom = false;
                authModel.CanEditRestroom = false;
                authModel.SessionApproved = false;
            }
            catch (Exception ex)
            {
                Logger.WriteError("debugStr:" + debugStr + ", Error:" + ex.Message);
                authModel.CanAddRestroom = false;
                authModel.CanEditRestroom = false;
                authModel.SessionApproved = false;
            }
            return authModel;

        }

        ///// 
        ///// </summary>
        ///// <param name="badge"></param>
        ///// <param name="deviceGuid"></param>
        ///// <param name="deviceSessionId"></param>
        ///// <returns></returns>
        //public async Task<bool> IsValidSessionAsync(string badge, string deviceGuid, string deviceSessionId)
        //{
        //    if (string.IsNullOrWhiteSpace(badge) || string.IsNullOrWhiteSpace(deviceSessionId) || string.IsNullOrWhiteSpace(deviceGuid))
        //        return false;
        //    try
        //    {
        //        badge = badge.Trim().PadLeft(6, '0');

        //        var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceSessionId == deviceSessionId && m.DeviceGuid==deviceGuid);
        //        if (device == null || !device.Active || !device.Confirmed2FACode.GetValueOrDefault(false))
        //            return false;

        //        var user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == badge && m.Active);
        //        if (user == null || user.Badge != badge || !user.Active)
        //            return false;

        //        var userDevice =await RestroomUnitOfWork.Get<UserDevice>().FirstOrDefaultAsync(m => m.DeviceId==device.DeviceId && m.UserId==user.UserId);
        //        if (userDevice == null || !userDevice.Active)
        //            return false;

        //        var firstName = user.FirstName;
        //        var lastName = user.LastName;
        //        var demoUser = await IsDemoUserAsync(firstName, lastName, badge);
        //        if (demoUser)
        //            return true;

        //        var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(user.Badge);
        //        if (employee == null || employee.SecurityCardFormatted != user.SecurityCardFormatted)
        //            return false;

        //        return true;


        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.WriteError(ex.Message);
        //        return false;
        //    }
        //}
        internal async Task<int> InvalidateOperatorAsync(string badge)
        {
            return await RestroomUnitOfWork.InvalidateOperatorAsync(badge);
        }

        //internal async Task<bool> IsDemoUserAsync(string firstName, string lastName, string badge)
        //{
        //    var valueToCompare = $"{badge?.Trim()}.{firstName?.Trim()}.{lastName?.Trim()}";
        //    return await RestroomUnitOfWork.Get<Setting>().AnyAsync(m => m.Name == "DemoUser" && m.Value== valueToCompare && m.Active);
        //}



        private AuthenticationViewModel SanitizeModel(AuthenticationViewModel authModel)
        {
            Logger.WriteDebug("SanitizeModel called.");

            try
            {
                if (string.IsNullOrWhiteSpace(authModel.DeviceGuid))
                    throw new FriendlyException(FriendlyExceptionType.DeviceIsNotSupported);
                // --------------------------------------some sanity check!
                if ((authModel.FirstName?.Length ?? 0) > 255)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "FirstName is too long.");
                if ((authModel.LastName?.Length ?? 0) > 255)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "LastName is too long.");
                if ((authModel.Badge?.Length ?? 0) > 10)
                    throw new FriendlyException(FriendlyExceptionType.AccessDenied, "Badge is too long.");
                if ((authModel.PhoneNumber?.Trim().Length ?? 100) > 16) //+1(xxx)xxx-xxxx or +1(xxx) xxx-xxxx or +1(xxx)-xxx-xxxx or +1-xxx-xxx-xxxx
                    throw new FriendlyException(FriendlyExceptionType.InvalidPhoneNumber, $"Invalid phone number. {authModel.PhoneNumber} is more than 16 character!");

                var phoneNumber = authModel.PhoneNumber?.Trim().Replace("(", "").Replace(")","").Replace("+", "").Replace(" ", "").Replace("-", "") ?? "";
                if (phoneNumber.Length > 11 ||
                    (phoneNumber.Length == 11 && !phoneNumber.StartsWith("1"))) // if length is bigger than 10, it means it has country code and we only allows US which is 1.
                    throw new FriendlyException(FriendlyExceptionType.InvalidPhoneNumber, $"Invalid phone number. {phoneNumber}");
                if (phoneNumber.Length == 11)
                    phoneNumber = phoneNumber.Substring(1);
                //----------------------------------------

                authModel.FirstName = authModel.FirstName?.Trim() ?? "";
                authModel.LastName = authModel.LastName?.Trim() ?? "";

                var badge = authModel.Badge?.Trim().PadLeft(6, '0');

                authModel.Badge=badge;
                authModel.PhoneNumber = phoneNumber;

                

            }
            catch (FriendlyException ex)
            {
                Logger.WriteError("SanitizeModel, Error:" + ex.Message);
                //if (ex.ExceptionType != FriendlyExceptionType.AccessDeniedNotActive)
                throw;
            }
            catch (DbEntityValidationException ex)
            {
                Logger.WriteError("SanitizeModel, DbEntityValidationException, Error:" + ex.Message);
                foreach (var eve in ex.EntityValidationErrors)
                {
                    Logger.WriteError($"Entity of type \"{eve.Entry.Entity.GetType().Name}\" in state \"{eve.Entry.State}\" has the following validation errors:");
                    foreach (var ve in eve.ValidationErrors)
                        Logger.WriteError($"- Property: \"{ve.PropertyName}\", Error: \"{ve.ErrorMessage}\"");
                }

                throw;
            }
            catch (Exception ex)
            {
                Logger.WriteError("SanitizeModel, Error:" + ex.Message);
                throw;
            }

            return authModel;
        }

        private async Task<Device> PrepareUserDevice(AuthenticationViewModel authModel, User user, string middleName, string securityCardFormatted)
        {
            string debugStr = "";

            var firstName = authModel.FirstName;
            var lastName = authModel.LastName;

            var demoUser = user?.IsDemo.GetValueOrDefault(false) ?? false;

            //User user = await RestroomUnitOfWork.Get<User>().FirstOrDefaultAsync(m => m.Badge == authModel.Badge && m.FirstName == firstName && m.LastName == lastName);
            //if (user != null && !user.Active)
            //    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $"user is not active. debugStr: {debugStr}");
            //var demoUser = user?.IsDemo ?? false;
            ////var demoUser = await IsDemoUserAsync(authModel.FirstName, authModel.LastName, authModel.Badge);
            ////debugStr = "After getting Demo User: " + demoUser;
            ////if (demoUser)
            ////    return true;

            //if (!demoUser)
            //{
            //    var employee = await EmployeeRepository.GetEmployeeByBadgeAsync(authModel.Badge);
            //    debugStr = $"After getting Employee, Found:{(employee != null)}";

            //    if (employee == null)
            //        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" User not found. debugStr: {debugStr}");
            //    if (!string.Equals(employee.FirstName, firstName, StringComparison.OrdinalIgnoreCase) || !string.Equals(employee.LastName, lastName, StringComparison.OrdinalIgnoreCase))
            //        throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" User names are not match. debugStr: {debugStr}");
            //    middleName = employee.MiddleName;
            //    securityCardFormatted = employee.SecurityCardFormatted;
            //}


            try
            {
                var device = await RestroomUnitOfWork.Get<Device>().FirstOrDefaultAsync(m => m.DeviceGuid == authModel.DeviceGuid);

                debugStr = $"after getting device and user. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}";

                if (device != null && !device.Active)
                    throw new FriendlyException(FriendlyExceptionType.AccessDeniedNotActive, $" device is not Active.", debugStr);
                if (!demoUser && device != null && device.Confirm2FAExpires != null && device.Confirm2FAExpires > DateTime.Now)
                    throw new FriendlyException(FriendlyExceptionType.UnExpiredValid2FAuth, $" device has an unexpired security code. new code can't be generated unless the previous code expires.", debugStr);


                UserDevice userDevice = null;
                if (user != null && device != null)
                    userDevice = await RestroomUnitOfWork.Get<UserDevice>()
                        .FirstOrDefaultAsync(m => m.DeviceId == device.DeviceId && m.UserId == user.UserId);
                if (device == null)
                {
                    device = new Device
                    {
                        Active = true,
                        DeviceGuid = authModel.DeviceGuid,
                        DeviceModel = authModel.DeviceModel,
                        DeviceOS = authModel.DeviceOS,
                        LastUsed = DateTime.Now
                    };
                }

                device.DeviceSessionId = Guid.NewGuid().ToString();
                //device.PhoneNumber = authModel.PhoneNumber;
                device.Confirm2FACode = GenerateRandomCode(6);
                device.Confirm2FAExpires = DateTime.Now.AddMinutes(ValidInMinutes2FactAuth);
                device.Confirmed2FACode = false;
                device.LastUsed = DateTime.Now;

                if (user == null)
                {
                    user = new User
                    {
                        Active = true,
                        Badge = authModel.Badge,
                    };
                }

                user.SecurityCardFormatted = securityCardFormatted;
                user.FirstName = firstName;
                user.LastName = lastName;
                user.MiddleName = middleName;



                user = RestroomUnitOfWork.PrepUser(user);
                device = RestroomUnitOfWork.PrepDevice(device);
                debugStr = $"Before SaveChanges on user and device. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}";

                await RestroomUnitOfWork.SaveChangesAsync();

                if (userDevice == null)
                {
                    userDevice = new UserDevice();
                    userDevice.Active = true;
                }

                userDevice.LastLogon = DateTime.Now;
                userDevice.UserId = user.UserId;
                userDevice.DeviceId = device.DeviceId;

                debugStr = $"Before SaveChanges on userDevice. DeviceGuid:{authModel.DeviceGuid}, Badge: {authModel.Badge}";
                await RestroomUnitOfWork.SaveUserDeviceAsync(userDevice);

                return device;
            }
            catch (FriendlyException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new Exception("Inside PrepareUserDevice, " + debugStr, ex);
            }


        }

        private async Task SendSecurityCodeBySms(string phoneNumber, string smsBody)
        {

            var section = ConfigurationManager.GetSection("SMS") as SmsSection;
            if (section == null || !string.Equals(section.Provider, "Twilio", StringComparison.OrdinalIgnoreCase))
                await SendSecurityCodeBySms_ViaEmail(phoneNumber, smsBody);
            else
                await SendSecurityCodeBySms_ViaTwilio(phoneNumber, smsBody);
        }

        private async Task SendSecurityCodeBySms_ViaTwilio(string phoneNumber, string smsBody)
        {
            var section = ConfigurationManager.GetSection("SMS") as SmsSection;
            if (section == null)
                throw new NullReferenceException("SMS Section is null");
            var accountSid = section.AccountSId;
            var authToken = section.AuthToken;
            var url = section.BaseUrl;
            var requestUri = section.RequestUrl.Replace("{accountSid}", accountSid);

            var client = new HttpClient();
            client.BaseAddress = new Uri(url);
            var request = new HttpRequestMessage(HttpMethod.Post, requestUri);

            var byteArray = Encoding.ASCII.GetBytes($"{accountSid}:{authToken}");
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));

            
            var formData = new List<KeyValuePair<string, string>>();
            formData.Add(new KeyValuePair<string, string>("From", section.Numbers[0].ToString()));
            formData.Add(new KeyValuePair<string, string>("To", phoneNumber));
            formData.Add(new KeyValuePair<string, string>("Body", smsBody));

            try
            {
                request.Content = new FormUrlEncodedContent(formData);
                //var response = await client.SendAsync(request);
                var response = await client.SendAsync(request);
                Console.WriteLine("sent...");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }


        }
        private async Task SendSecurityCodeBySms_ViaEmail(string phoneNumber, string smsBody)
        {

            var section = ConfigurationManager.GetSection("SMS") as SmsSection;
            if (section == null || !string.Equals(section.Provider, "Twilio", StringComparison.OrdinalIgnoreCase))
            {

            }
            string[] smsProviders = { TelcomProvider.Att.ToString(), TelcomProvider.TMobile.ToString(), TelcomProvider.Sprint.ToString(), TelcomProvider.Verizon.ToString() };
            var tasks = new List<Task>();
            for (var i = 0; i < smsProviders.Length; i++)
            {
                var t = NotificationService.SendSmsNotificationAsync(phoneNumber, smsProviders[i], smsBody);
                tasks.Add(t);
            }
            await Task.WhenAll(tasks.ToArray());
        }

        private string GenerateRandomCode(int length)
        {
            var random = new Random();
            var allowedStrings = new[] { "0","1","2","3","4","5","6","7","9"};
            var result = "";
            for (var i = 0; i < length; i++)
            {
                var rnd = random.Next(0, length-1);
                result += allowedStrings[rnd];
            }

            return result;
        }

    }
}