using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security;
using System.Text;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.UI;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;
using ACTransit.RestroomFinder.Domain.ActiveDirectory;

namespace ACTransit.RestroomFinder.API.Controllers
{
    [System.Web.Http.AllowAnonymous]
    public class KMLController : BaseController<RestroomHandler>
    {
        [System.Web.Http.HttpGet]
        [System.Web.Http.Route("kml/restrooms")]
        [OutputCache(NoStore = true, Duration = 0, Location = OutputCacheLocation.None, VaryByParam = "*")]
        public HttpResponseMessage GetRestroomList()
        {
            var cacheKey = "KMLFileCacheKey";
            ValidateToken();

            var kml = Common.Cache.GetCache(cacheKey) as string;
            if (string.IsNullOrEmpty(kml))
            {
                try
                {
                    var placemarks = string.Empty;
                    kml = $@"<?xml version=""1.0"" encoding=""UTF-8""?>"
                          + @"<kml xmlns=""http://www.opengis.net/kml/2.2"" xmlns:gx=""http://www.google.com/kml/ext/2.2"" xmlns:kml=""http://www.opengis.net/kml/2.2"" xmlns:atom=""http://www.w3.org/2005/Atom"">"
                          + @"<Document><name>AC Transit Restroom List</name><Style id=""s_ylw-pushpin"">"
                          + @"<IconStyle><Icon><href>http://maps.google.com/mapfiles/kml/shapes/toilets.png</href>"
                          + @"</Icon></IconStyle></Style>"
                          + @"{placemarks}</Document></kml>";

                    var restrooms = Handler.GetRestroomList();
                    Log.Info("TOTAL NO OF RESTROOMS... " + restrooms.Count());

                    foreach (var res in restrooms)
                    {
                        var name = SecurityElement.Escape(res.RestroomName);
                        var address = SecurityElement.Escape(res.Address);
                        char[] charsToTrim = { ',', '.', ' ' };
                        var hours = ((res.WeekdayHours != null ? "Weekdays: " + SecurityElement.Escape(res.WeekdayHours.Trim()) + ", " : "") +
                                    (res.SaturdayHours != null ? "Saturdays: " + SecurityElement.Escape(res.SaturdayHours.Trim()) + ", " : "") +
                                    (res.SundayHours != null ? "Sundays: " + SecurityElement.Escape(res.SundayHours?.Trim()) : "")).TrimEnd(charsToTrim);
                        
                        var water = res.DrinkingWater == "N" ? "No" : "Yes";
                        var toilet = res.IsToiletAvailable? "No" : "Yes";
                        var gender = !res.ToiletGenderId.HasValue ? "None" : $"{(GenderToiletEnum)res.ToiletGenderId}";
                        var notes = SecurityElement.Escape(res.Note);

                        var description = $"<dt>Address</dt><dd>{address}</dd>" +
                                $"<dt>Hours Open</dt><dd>{hours}</dd>" +
                                $"<dt>Drinking Water</dt><dd>{water}</dd>" + 
                                $"<dt>Toilet</dt><dd>{toilet}</dd>" +
                                $"<dt>Gender</dt><dd>{gender}</dd>" +
                                $"<dt>Notes</dt><dd>{notes}</dd>";

                        var placemark = "<Placemark>"
                                        + $"<name>{name}</name>"
                                        + "<styleUrl>#s_ylw-pushpin</styleUrl>"
                                        + $"<description>{description}</description>"
                                        + $"<Point><gx:drawOrder>1</gx:drawOrder><coordinates>{res.Geo.Longitude},{res.Geo.Latitude},0</coordinates></Point>"
                                        + "</Placemark>";
                        placemarks += placemark;
                    }

                    //Replace content in placeholder
                    kml = kml.Replace("{placemarks}", placemarks);
                    Common.Cache.AddCache(cacheKey, kml, DateTime.Now.AddSeconds(Config.MemoryCacheTime).Minute);
                }
                catch (Exception ex)
                {
                    Log.Error($"Failed. GenerateKMLFile \n {ex.Message}\n {ex.StackTrace} {ex.InnerException}");
                }
                //generate kml file
                //Common.Cache.AddCache(cacheKey, kml, DateTime.Now.AddSeconds(Config.MemoryCacheTime).Minute);
            }

            var response = new HttpResponseMessage
            {
                Content = new StringContent(kml, Encoding.UTF8, "application/vnd.google-earth.kml+xml")
            };

            //response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("inline")
            //{
            //    FileName = "ACTRestroomList.kml"
            //};
            return response;
        }

        [System.Web.Http.HttpGet]
        [System.Web.Http.Route("kml/download")]
        [OutputCache(NoStore = true, Duration = 0, Location = OutputCacheLocation.None, VaryByParam = "*")]
        public HttpResponseMessage NetworkLinkOnInterval()
        {
            ValidateToken();
            var kmlUrl = Config.KMLDownloadUrl;
            Log.Info("KML URL: " + kmlUrl);

            var kml = $@"<?xml version=""1.0"" encoding=""utf-8""?>"
                      + @"<kml xmlns=""http://www.opengis.net/kml/2.2"">"
                      + @"<NetworkLink>"
                      + @"<Link>"
                      + @"<href>" + kmlUrl + "</href>"
                      + @"<refreshMode>onInterval</refreshMode>"
                      + @"<refreshInterval>"+Config.OnIntervalTime+"</refreshInterval>"
                      + @"</Link>"
                      + @"</NetworkLink>"
                      + @"</kml>";
            var response = new HttpResponseMessage
            {
                Content = new StringContent(kml, Encoding.UTF8, "application/vnd.google-earth.kml+xml")
            };
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("inline")
            {
                FileName = "ACTRestrooms.kml"
            };
            return response;
        }

        public void ValidateToken()
        {
            var queryKeyValues = ControllerContext.Request.GetQueryNameValuePairs();
            var v = queryKeyValues.LastOrDefault(q => string.Equals(q.Key, "api_key", StringComparison.OrdinalIgnoreCase)).Value ?? "";
            if (v != Config.KmlToken)
            {
                //var msg = new HttpResponseMessage(HttpStatusCode.Unauthorized) { ReasonPhrase = "A valid API token is required to use this API." };
                //throw new HttpResponseException(msg);

                throw new HttpResponseException(new HttpResponseMessage
                {
                    Content = new StringContent("A valid API token is required to use this API."),
                    StatusCode = HttpStatusCode.Unauthorized
                });
            }
        }
    }
}