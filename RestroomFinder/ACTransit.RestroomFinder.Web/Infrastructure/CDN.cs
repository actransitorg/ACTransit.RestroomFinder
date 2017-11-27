using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class CDN
    {
        static string _ACTransitCDNPath = "";
        static CDN()
        {
            _ACTransitCDNPath = ConfigurationManager.AppSettings["ACTransitCDNPath"];
            if (!_ACTransitCDNPath.EndsWith("/"))
                _ACTransitCDNPath += "/";
        }

        public static string ImgPath(string img)
        {
            return GetImagesPath() + img;
        }

        private static string GetImagesPath()
        {
            return _ACTransitCDNPath + "Images/";
        }

    }
}