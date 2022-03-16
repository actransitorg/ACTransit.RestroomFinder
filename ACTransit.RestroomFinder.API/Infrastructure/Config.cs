using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.API.Infrastructure
{
    public static class Config
    {
        private static string[] _jobTitlesAccessToAddRestroom;
        private static string[] _jobTitlesAccessToEditRestroom;
        /// <summary>
        /// 
        /// </summary>
        public static string[] IpThrottlingWhiteList
        {
            get
            {
                var ips = ConfigurationManager.AppSettings["IPThrottlingWhiteList"];
                return ips?.Split(new[] {','}, StringSplitOptions.RemoveEmptyEntries);
           }
        }

        public static string[] JobTitlesAccessToAddRestroom
        {
            get
            {
                if (_jobTitlesAccessToAddRestroom == null || _jobTitlesAccessToAddRestroom.Length==0)
                {
                    var jobTitlesStr = ConfigurationManager.AppSettings["JobTitlesAccessToAddRestroom"] ?? "";
                    _jobTitlesAccessToAddRestroom= jobTitlesStr?.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                }
                return _jobTitlesAccessToAddRestroom;
            }
        }

        public static string[] JobTitlesAccessToEditRestroom
        {
            get
            {
                if (_jobTitlesAccessToEditRestroom == null || _jobTitlesAccessToEditRestroom.Length == 0)
                {
                    var jobTitlesStr = ConfigurationManager.AppSettings["JobTitlesAccessToEditRestroom"] ?? "";
                    _jobTitlesAccessToEditRestroom = jobTitlesStr?.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                }
                return _jobTitlesAccessToEditRestroom;
            }
        }

        public static string KMLDownloadUrl
        {
            get
            {
                var url = ConfigurationManager.AppSettings["KMLDownloadUrl"];
                if (!string.IsNullOrEmpty(url))
                    return url;
                return null;
            }
        }

        public static int OnIntervalTime
        {
            get
            {
                var verStr=ConfigurationManager.AppSettings["OnIntervalTime"];
                if (int.TryParse(verStr, out var ver))
                    return ver;
                return 3600;
            }
        }

        public static string KmlToken
        {
            get
            {
                var token = ConfigurationManager.AppSettings["KMLToken"];
                if (!string.IsNullOrEmpty(token))
                    return token;
                return string.Empty;
            }
        }


        public static int MemoryCacheTime
        {
            get
            {
                var verStr = ConfigurationManager.AppSettings["MemoryCacheTime"];
                if (int.TryParse(verStr, out var ver))
                    return ver;
                return 3600;
            }
        }
    }
}