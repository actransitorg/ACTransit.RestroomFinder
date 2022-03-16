using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Mvc;
using ACTransit.Framework.Components;
using ACTransit.Framework.Extensions;
using ACTransit.RestroomFinder.API.Handlers;
using ACTransit.RestroomFinder.API.Infrastructure;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [System.Web.Http.RoutePrefix("api/Version")]
    [System.Web.Http.AllowAnonymous]
    public class VersionController : BaseController<RestroomHandler>
    {
        const int Delay =1000;
        const string DefaultVersion = "00.00.00";
        //{Name}-{Version}-{Date}.xx.xx.xx
        // ReSharper disable once InconsistentNaming
        private readonly string _iOSFolder;
        private readonly string _androidFolder;
        // ReSharper disable once InconsistentNaming
        private readonly string _iOSDownloadPath;
        private readonly string _androidDownloadPath;

        /// <summary>
        /// 
        /// </summary>
        public VersionController()
        {
            _iOSFolder = ConfigurationManager.AppSettings["iOSFolder"];
            _androidFolder = ConfigurationManager.AppSettings["androidFolder"];
            _iOSDownloadPath = ConfigurationManager.AppSettings["iOSDownloadPath"];
            _androidDownloadPath = ConfigurationManager.AppSettings["androidDownloadPath"];

        }

        [System.Web.Http.Route("{type}/{applicationName}")]
        public async Task<IHttpActionResult> Get(string type, string applicationName)
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
                model=await SetiOsModel(model,url, path, extension);
                //model.Url = @"itms-services://?action=download-manifest&url=https://your.company.domain/path/to/Mobile.Apps Website/Restroom/manifest.plist";
                //model.Url = @"itms-services://?action=download-manifest&url=https://testapi.actransit.org/Restroom-finder/api/version/GetiOSManifest/restroom";                
            }

            return Ok(model);
        }

        [System.Web.Http.Route("{type}/{applicationName}/{clientSdkVersion}")]
        public async Task<IHttpActionResult> Get(string type, string applicationName, string clientSdkVersion)
        {
            Debug("Get", $"Type: {type}, ApplicationName: {applicationName}, clientSdkVersion:{clientSdkVersion}");

            var model = new VersionModel();
            string path, url, extension;
            if (string.IsNullOrEmpty(type))
                return NotFound();
            if (type.ToLower() == "android")
            {
                model.ApplicationType = "Android";
                path = _androidFolder;
                extension = "apk";
                url = $"{_androidDownloadPath}{applicationName}/";
                path += applicationName;
                SetAndroidModel(ref model, url, path, extension, clientSdkVersion.ToInt() ?? 0);
            }
            else
            {
                model.ApplicationType = "iOS";
                path = _iOSFolder;
                extension = "ipa";
                url = $"{_iOSDownloadPath}{applicationName}/";
                path += applicationName;
                model = await SetiOsModel(model, url, path, extension);
                //model.Url = @"itms-services://?action=download-manifest&url=https://your.company.domain/path/to/Mobile.Apps Website/Restroom/manifest.plist";
                //model.Url = @"itms-services://?action=download-manifest&url=https://testapi.actransit.org/Restroom-finder/api/version/GetiOSManifest/restroom";                
            }

            return Ok(model);
        }

        [System.Web.Http.ActionName("GetiOSManifest")]
        [System.Web.Http.Route("GetiOSManifest/{applicationName}")]
        public async Task<HttpResponseMessage> GetiOSManifest(string applicationName)
        {
            Debug("GetiOSManifest", $"ApplicationName: {applicationName}");
            var model = new VersionModel();
            string path, url, extension, content;
            model.ApplicationType = "iOS";
            path = _iOSFolder;
            extension = "ipa";
            url = $"{_iOSDownloadPath}{applicationName}/";
            path += applicationName;
            model=await SetiOsModel(model, url, path, extension);

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

            if (!string.IsNullOrWhiteSpace(path) && File.Exists(path))
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

        private Task<VersionModel> SetiOsModel(VersionModel model,string url, string path, string extension)
        {
            return Task.Run(() => { 
                try
                {
                    string[] files = Directory.GetFiles(path, $"*.{extension}");
                    files = files.OrderByDescending(f => f).ToArray();
                    if (files.Length > 0)
                    {
                        foreach (var file in files)
                        {
                            var parts = file.Split('-');
                            if (parts.Length != 3)
                                continue;
                            var fileInfo = new FileInfo(file);

                            model.Version = GetVersion(parts[2]);
                            model.Date = fileInfo.LastAccessTime;
                            model.Url = $"itms-services://?action=download-manifest&url={url}manifest.plist";
                            model.FileName = fileInfo.Name;
                            break;
                        }
                    }

                    return model;
                    
                }
                catch (Exception ex)
                {
                    Error("SetiOSModel",ex.Message, ex);
                    throw;
                }
            });
        }
        private void SetAndroidModel(ref VersionModel model, string url, string path, string extension, int clientApiLevel=0)
        {
            try
            {
                
                string[] files = Directory.GetFiles(path, $"*.{extension}");
                var androidFiles = new List<AndroidFile>();
                foreach (var f in files)
                    androidFiles.Add(new AndroidFile(f));

                androidFiles= androidFiles.OrderByDescending(m=>m.Version).ToList();
                //androidFiles.Sort(new Comparison<AndroidFile>((m1, m2) => String.Compare(m1.Version, m2.Version, StringComparison.Ordinal)));
                AndroidFile bestFileCandidate = null;
                foreach (var file in androidFiles)
                {
                    if (bestFileCandidate == null && (file.ApiLevel == 0 || file.ApiLevel <= clientApiLevel))
                        bestFileCandidate = file;
                    else if (bestFileCandidate != null)
                    {
                        if (bestFileCandidate.Version == file.Version)
                        {
                            if (bestFileCandidate.ApiLevel < file.ApiLevel && file.ApiLevel <= clientApiLevel)
                                bestFileCandidate = file;
                        }
                        else  // it means the version is now smaller than the BestFileCandidate, so no more loop.
                            break;

                    }
                }

                if (bestFileCandidate != null)
                {
                    model.Version = GetVersion(bestFileCandidate.Version);
                    var sDate = bestFileCandidate.Date;
                    model.Date = DateTime.ParseExact(sDate, "yyyyMMddHHmmss", new CultureInfo("en-US"));
                    model.Url = url + bestFileCandidate.FileName;
                    model.FileName = bestFileCandidate.FileName;

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
                    if (Extensions.IsNumeric(part))
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

        [System.Web.Http.Route]
        public Stream GenerateStreamFromString(string s)
        {
            MemoryStream stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }



        //[Route("GetTestAsync")]
        //public Task<string> GetTestAsync(string str)
        //{
        //    return Task.Run(async () =>
        //    {
        //        await Task.Delay(Delay);
        //        //System.Threading.Thread.Sleep(500);
        //        var result = str;
        //        for (int i = 0; i < 1000; i++)
        //        {
        //            if (str.Length < 2000)
        //                str += i;
        //            else
        //                str = str.Substring(0, 1000);
        //        }
        //        return str;
        //    });
         
        //}

        //[Route("GetTestAsync1")]
        //public async Task<string> GetTestAsync1(string str)
        //{

        //    return await Task.Factory.StartNew(async () =>
        //    {
        //        await Task.Delay(Delay);
        //        //System.Threading.Thread.Sleep(500);
        //        var result = str;
        //        for (int i = 0; i < 1000; i++)
        //        {
        //            if (str.Length < 2000)
        //                str += i;
        //            else
        //                str = str.Substring(0, 1000);
        //        }
        //        return str;
        //    }).Unwrap();
        //}
        //[Route("GetTestSync")]
        //public string GetTestSync(string str)
        //{
        //    var result = str;
        //    System.Threading.Thread.Sleep(Delay);
        //    for (int i = 0; i < 1000; i++)
        //    {
        //        if (str.Length < 2000)
        //            str += i;
        //        else
        //            str = str.Substring(0, 1000);
        //    }
        //    return str;
        //}

    }

    public class AndroidAPILevel
    {
        public AndroidAPILevel(string ver, int apiLevel)
        {
            Version = ver;
            ApiLevel = apiLevel;
        }
        public string Version { get; set; }
        public int ApiLevel { get; set; }
    }

    public class AndroidFile
    {
        public AndroidFile(string fileFullPath)
        {
            var fileInfo = new FileInfo(fileFullPath);
            FileName = fileInfo.Name;
            
            var name= FileName.Substring(0, FileName.Length- fileInfo.Extension.Length);
            var parts = name.Split('-');
            if (parts.Length > 0) 
                AppName = parts[0];
            if (parts.Length > 1)
                Type = parts[1];
            if (parts.Length > 2)
                Version = parts[2];
            if (parts.Length > 3)
                Date = parts[3];
            if (parts.Length > 4)
            {
                ApiLevel = parts[4].ToInt()??0;
            }
        }
        public string FileFullPath{ get; set; }
        public string FileName { get; set; }
        //Restroom-Release-2.11-20200513145219.apk
        public string AppName { get; set; }
        public string Type{ get; set; }
        public string Version { get; set; }
        public string Date { get; set; }
        /// <summary>
        /// if 0, it means it is valid for all api levels.
        /// </summary>
        public int ApiLevel { get; set; }  
    }
}

