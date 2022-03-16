using System;
using System.Dynamic;
using System.Security.Claims;
using System.Security.Principal;
using ACTransit.DataAccess.Employee.Repositories;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.Framework.Logging;
using ACTransit.Framework.Web.Infrastructure;
using ACTransit.RestroomFinder.Domain.Service;
using ACTransit.RestroomFinder.API.Models;
using ACTransit.RestroomFinder.API.Services;

namespace ACTransit.RestroomFinder.API.Handlers
{
    public class BaseHandler: IDisposable
    {
        protected string CurrentUserName;
        private EmployeeRepository _employeeRepository;
        private RestroomUnitOfWork _restroomUnitOfWork;
        private NotificationService _notificationService;

        protected EmployeeRepository EmployeeRepository => _employeeRepository ?? (_employeeRepository = new EmployeeRepository());        

        protected RestroomUnitOfWork RestroomUnitOfWork => _restroomUnitOfWork ?? (_restroomUnitOfWork = new RestroomUnitOfWork(CurrentUserName));

        //public IPrincipal User { get; private set; }
        public void SetUser(string user)
        {
            CurrentUserName = user;
        }

        private Logger _logger;
        protected Logger Logger => _logger ?? (_logger = new Logger(GetType()));

        public bool LoggedIn => ClaimsPrincipal.Current != null;
        protected void WriteLog(BaseViewModel model, string description)
        {
            var log = new Log
            {
                DeviceId = model.DeviceGuid,
                DeviceOS = model.DeviceOS,
                DeviceModel = model.DeviceModel,
                Description = description,
            };
            RestroomUnitOfWork.Create(log);
        }

        protected NotificationService NotificationService
        {
            get
            {
                if (_notificationService == null)
                {
                    _notificationService = new NotificationService();
                    var host = MailSettings.SmtpSection().Network.Host;
                    if (!string.IsNullOrWhiteSpace(host))
                        _notificationService.SmtpHostName = host;

                    var port = MailSettings.SmtpSection().Network.Port;
                    if (port != 0)
                        _notificationService.SmtpHostPort = port;

                    var useSsl = MailSettings.SmtpSection().Network.EnableSsl;
                    if (useSsl)
                        _notificationService.SmtpUseSSL = true;

                    var login = MailSettings.SmtpSection().Network.UserName;
                    if (!string.IsNullOrWhiteSpace(login))
                        _notificationService.SmtpLoginName = login;

                    var password = MailSettings.SmtpSection().Network.Password;
                    if (!string.IsNullOrWhiteSpace(password))
                        _notificationService.SmtpPassword = password;

                    var fromEmail = MailSettings.SmtpSection().From;
                    if (!string.IsNullOrWhiteSpace(fromEmail))
                        _notificationService.SmtpDefaultFrom = fromEmail;

                }

                return _notificationService;
            }
        }


        public void Dispose()
        {
            _employeeRepository?.Dispose();
            _restroomUnitOfWork?.Dispose();
        }
        
    }

}