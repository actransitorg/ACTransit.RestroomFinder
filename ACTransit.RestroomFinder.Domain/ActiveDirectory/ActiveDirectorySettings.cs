using ACTransit.Framework.Configurations;

namespace ACTransit.RestroomFinder.Domain.ActiveDirectory
{
    public static class ActiveDirectorySettings
    {
        public static string Url { get; private set; }

        public static string Username { get; private set; }

        public static string Password { get; private set; }

        static ActiveDirectorySettings()
        {
            Url = ConfigurationUtility.GetStringValue("AD_URL") ?? string.Empty;
            Username = ConfigurationUtility.GetStringValue("AD_User") ?? string.Empty;
            Password = ConfigurationUtility.GetStringValue("AD_Pwd") ?? string.Empty;
        }
    }
}