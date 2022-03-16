using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ACTransit.Framework.Exceptions;
using ACTransit.Framework.Notification;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class NotificationService
    {
        public string SmtpDefaultFrom { get; set; }
        public string SmtpHostName { get; set; }
        public int SmtpHostPort { get; set; }
        public bool? SmtpUseSSL { get; set; }
        public string SmtpLoginName { get; set; }
        public string SmtpPassword { get; set; }

        public async Task SendSmsNotificationAsync(string notificationPhone, string notificationTelcomProvider, string smsBody)
        {
            try
            {
                var to = new List<string>();


                if (!string.IsNullOrWhiteSpace(notificationPhone))
                {
                    var phoneProviders = new List<PhoneProvider>();
                    //var phones = new List<Tuple<string, string>>();
                    foreach (var phone in notificationPhone.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        if (phone.Contains("@"))
                        {
                            var phoneProvider = phone.Split('@');
                            if (!string.IsNullOrWhiteSpace(phoneProvider[0]) && !string.IsNullOrWhiteSpace(phoneProvider[1]))
                                phoneProviders.Add(new PhoneProvider(phoneProvider[0], phoneProvider[1], BodyFormat.Mms));
                        }
                        else if (!string.IsNullOrWhiteSpace(phone) && !string.IsNullOrWhiteSpace(notificationTelcomProvider))
                            phoneProviders.Add(new PhoneProvider(phone, notificationTelcomProvider, BodyFormat.Mms));
                    }

                    if (phoneProviders.Count > 0)
                    {
                        await SendSmsAsync(phoneProviders, smsBody);
                    }

                }

            }
            catch (Exception ex)
            {
                throw new FriendlyException("Some error happened while sending notifications. Please try again later.");
            }
        }


        private async Task SendSmsAsync(List<PhoneProvider> to, string body)
        {
            var emailService = new SmsEmailService(SmtpHostName, SmtpHostPort, SmtpLoginName, SmtpPassword, SmtpUseSSL, SmtpDefaultFrom);

            await emailService.SendAsync(new SmsPayload
            {
                To = to,
                FromEmailAddress = SmtpDefaultFrom,
                Body = body
                //,IsBodyHtml = true
            });
        }

  
    }
}
