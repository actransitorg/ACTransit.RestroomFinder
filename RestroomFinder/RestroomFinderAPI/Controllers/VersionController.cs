using System;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web.Hosting;
using System.Web.Http;
using RestroomFinderAPI.Infrastructure;
using RestroomFinderAPI.Models;

namespace RestroomFinderAPI.Controllers
{
    public class VersionController : BaseController
    {
        const string DefaultVersion = "00.00.00";
        //{Name}-{Version}-{Date}.xx.xx.xx
        // ReSharper disable once InconsistentNaming
        private readonly string _iOSFolder;
        private readonly string _androidFolder;
        // ReSharper disable once InconsistentNaming
        private readonly string _iOSDownloadPath;
        private readonly string _androidDownloadPath;

        public VersionController()
        {
            _iOSFolder = ConfigurationManager.AppSettings["iOSFolder"];
            _androidFolder = ConfigurationManager.AppSettings["androidFolder"];
            _iOSDownloadPath = ConfigurationManager.AppSettings["iOSDownloadPath"];
            _androidDownloadPath = ConfigurationManager.AppSettings["androidDownloadPath"];

        }

        [Route("api/Version/{type}/{applicationName}")]
        public IHttpActionResult Get(string type, string applicationName)
        {
            Debug("Get", $"Type: {type}, ApplicationName: {applicationName}");
            var model = new VersionModel();
            string path,url,extension; 
            if (string.IsNullOrEmpty(type))
                return NotFound();
            if (type.ToLower() == "android")
            {
                model.ApplicationType = "Android";
                path = _androidFolder;
                extension = "apk";
                url = $"{_androidDownloadPath}{applicationName}/";
                path += applicationName;
                SetAndroidModel(ref model, url, path, extension);
            }
            else
            {
                model.ApplicationType = "iOS";
                path = _iOSFolder;
                extension = "ipa";
                url = $"{_iOSDownloadPath}{applicationName}/";
                path += applicationName;
                SetiOSModel(ref model,url, path, extension);
                model.Url = @"itms-services://?action=download-manifest&url=https://your.company.dns/path/to/Mobile.Apps Website/Restroom/manifest.plist";
                //model.Url = @"itms-services://?action=download-manifest&url=https://your.company.dns/path/to/restroom-finder-api/version/GetiOSManifest/restroom";                
            }



            return Ok(model);
        }
        [ActionName("GetiOSManifest")]
        [Route("api/Version/GetiOSManifest/{applicationName}")]
        public HttpResponseMessage GetiOSManifest(string applicationName)
        {
            Debug("GetiOSManifest", $"ApplicationName: {applicationName}");
            var model = new VersionModel();
            string path, url, extension, content;
            model.ApplicationType = "iOS";
            path = _iOSFolder;
            extension = "ipa";
            url = $"{_iOSDownloadPath}{applicationName}/";
            path += applicationName;
            SetiOSModel(ref model, url, path, extension);

            content = "";
            path = HostingEnvironment.MapPath("~/Assets/manifest.plist");
            ////var stream = new FileStream(path, FileMode.Open);
            //content = File.ReadAllText(path);
            //content=content.Replace("{url}", model.Url);
            //var stream = GenerateStreamFromString(content);
            //HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            //result.Content = new StreamContent(stream);
            //result.Content.Headers.ContentType =
            //    new MediaTypeHeaderValue("text/xml");
            //return result;

            if (File.Exists(path))
            {
                content = File.ReadAllText(path);
                content = content.Replace("{url}", model.Url);

                //using (Stream s = GenerateStreamFromString(content))
                //{
                    Stream s = GenerateStreamFromString(content);
                    var result = new HttpResponseMessage(HttpStatusCode.OK);
                    result.Content = new StreamContent(s);
                    //result.Content = new StringContent(content);
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/xml");
                result.Content.Headers.ContentLength = content.Length;
                    result.Headers.AcceptRanges.Add("bytes");

                
                    //result.Content.Headers.Add("Accept-Ranges","bytes");
                    //result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    //{
                    //    FileName = "manifest.plist"
                    //};
                //result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                return result;
                //}
            }
            else
            {
                return new HttpResponseMessage(HttpStatusCode.NoContent);
            }
        }

        private void SetiOSModel(ref VersionModel model,string url, string path, string extension)
        {
            try
            {
                string[] files = System.IO.Directory.GetFiles(path, $"*.{extension}");
                files = files.OrderByDescending(f => f).ToArray();
                if (files.Length > 0)
                {
                    foreach (var file in files)
                    {
                        var parts = file.Split('-');
                        if (parts.Length != 3)
                            continue;
                        var fileInfo = new System.IO.FileInfo(file);

                        model.Version = GetVersion(parts[2]);
                        model.Date = fileInfo.LastAccessTime;
                        model.Url = url + fileInfo.Name;                        
                        model.FileName = fileInfo.Name;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Error("SetiOSModel",ex.Message, ex);
                throw;
            }
        }
        private void SetAndroidModel(ref VersionModel model, string url, string path, string extension)
        {
            try
            {
                string[] files = System.IO.Directory.GetFiles(path, $"*.{extension}");
                files = files.OrderByDescending(f => f).ToArray();
                if (files.Length > 0)
                {
                    foreach (var file in files)
                    {
                        var parts = file.Split('-');
                        if (parts.Length != 4)
                            continue;
                        var fileInfo = new System.IO.FileInfo(file);

                        model.Version = GetVersion(parts[2]);
                        var sDate = parts[3].Split('.')[0];
                        model.Date = DateTime.ParseExact(sDate, "yyyyMMddHHmmss", new CultureInfo("en-US"));
                        model.Url = url + fileInfo.Name;
                        model.FileName = fileInfo.Name;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Error("SetAndroidModel",ex.Message,ex);
                throw;
            }
        }

        private string GetVersion(string str)
        {
            var result = DefaultVersion;
            if (String.IsNullOrEmpty(str) || !str.Contains("."))
                return result;
            var parts = str.Split('.');
            if (parts.Length >= 2)
            {
                StringBuilder stringBuilder=new StringBuilder();
                int counter = 0;
                foreach (var part in parts)
                {
                    if (part.IsNumeric())
                    {
                        counter++;
                        if (stringBuilder.Length>0)
                            stringBuilder.Append(".");
                        stringBuilder.Append(part.PadLeft(2, '0'));
                    }
                }
                for (int i = counter; i < 3; i++)
                {
                    if (stringBuilder.Length > 0)
                        stringBuilder.Append(".");
                    stringBuilder.Append("00");
                }
                result = stringBuilder.ToString();
            }
            return result;
        }

        public Stream GenerateStreamFromString(string s)
        {
            MemoryStream stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

    }
}

