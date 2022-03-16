using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Configuration;
using ACTransit.Framework.Configurations;
using ACTransit.Framework.Extensions;

namespace ACTransit.Framework.Web.Infrastructure
{
    public static class MailSettings
    {
        public static bool EmailEnabled { get; }

        /// <summary>
        /// List of emails addresses to send exception alerts to.
        /// </summary>
        public static IEnumerable<string> ExceptionAlertToEmails { get; }

        /// <summary>
        /// List of cc email addresses to send exception alerts to.
        /// </summary>
        public static IEnumerable<string> ExceptionAlertCcEmails { get; }

        /// <summary>
        /// List of Bcc email addresses to send exception alerts to.
        /// </summary>
        public static IEnumerable<string> ExceptionAlertBccEmails { get; }

        /// <summary>
        /// List of emails addresses to override customer emails to.
        /// </summary>
        public static IEnumerable<string> EmailOverrideTo { get; }

        public static IEnumerable<string> EmailIgnoreKeys { get; }

        /// <summary>
        /// Subject template for application's email subject (designed to use with string.Format())
        /// </summary>
        public static string EmailSubject { get; }

        public static SmtpSection SmtpSection()
        {
            return (SmtpSection)ConfigurationManager.GetSection("system.net/mailSettings/smtp");
        }

        static MailSettings()
        {
            var emailEnabled = ConfigurationUtility.GetStringValue("EmailEnabled");
            var toEmails = ConfigurationUtility.GetStringValue("AppExceptionAlert_To");
            var ccEmails = ConfigurationUtility.GetStringValue("AppExceptionAlert_Cc");
            var bccEmails = ConfigurationUtility.GetStringValue("AppExceptionAlert_Bcc");
            var overrideTo = ConfigurationUtility.GetStringValue("EmailOverrideTo");
            var emailSubject = ConfigurationUtility.GetStringValue("EmailSubject");
            var emailIgnoreKeys = ConfigurationUtility.GetStringValue("EmailIgnoreKeys");


            EmailEnabled = emailEnabled != null && emailEnabled.ToBool().GetValueOrDefault();
            ExceptionAlertToEmails = toEmails == null ? Enumerable.Empty<string>() : toEmails.ToEnumerable<string>(";");
            ExceptionAlertCcEmails = ccEmails == null ? Enumerable.Empty<string>() : ccEmails.ToEnumerable<string>(";");
            ExceptionAlertBccEmails = ccEmails == null ? Enumerable.Empty<string>() : bccEmails.ToEnumerable<string>(";");
            EmailOverrideTo = overrideTo == null ? Enumerable.Empty<string>() : overrideTo.ToEnumerable<string>(";");
            EmailIgnoreKeys = emailIgnoreKeys == null ? Enumerable.Empty<string>() : emailIgnoreKeys.ToEnumerable<string>();
            EmailSubject = emailSubject ?? "Email from ACTransit";
        }
    }
}