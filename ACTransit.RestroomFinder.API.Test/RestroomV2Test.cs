using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API.Models;
using Newtonsoft.Json.Linq;

namespace ACTransit.RestroomFinder.API.Test
{
    [TestClass]
    public class RestroomV2Test
    {
        //private const string baseUrl = "https://devapi.actransit.org/restroom-finder/";
        private string RestroomUrl = Common.baseAPIV2 + "Restrooms";

        private const string SessionId = "b4c6ed04-9ede-43cf-a69d-20ee40c38a64";
        private const string Badge = "43160";
        private const string DeviceGuid = "f114aba9a8aeefce";

        [TestMethod]
        public void TestGetAll()
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                client.Headers.Add("sessionId", "6614F12E9DEED15C8BE2243C2ABABD989ECFA46690A4649D1D30429D713799E7405AFE4685FF355F23BA7E263F252E83CF47A58CDCA763B80DCE106C2E6FF6B05D85CBA5D406D1188324F959B61F48C484C65B459404B2474CA61EEF25361422A6CB8DEEC857E6C18D413149F8B6BB4ABB6AB50A10169B1C499E24819AF75F2740E9E00A57EA41E146132F01DD49ED10F2BBC1423B884318EEE9517CD2E8E7BC4162298E7F2F839209072F0E014D10BAFFF98EC7210DB0FB0264BFE37EB67BDFFEEC052B7F7C54E1FCD142994136B9FCDA5994B78AA806945CE9F6466C5221168B4117FAC43AD0AE5F709DDFAD1A9154D962DC9C929330674E9B225D15FF9F6522A4B446D629320B12234EE6DD2A844B688DBF14096CF76F0D02BBE42BFD326FBC6747049BE54801F24EBA57773314303787766FB71A67C78DBD8A155A88287503AFA95E919523008E15B0AB060C2F23");
                client.Headers.Add("badge", "43160");

                RestroomUrl += "/get?routeAlpha=&direction=&lat=&longt=&distance=";
                var result = client.DownloadData(RestroomUrl);

                Assert.IsNotNull(result);
                var str = System.Text.Encoding.ASCII.GetString(result);
                Assert.IsNotNull(str);
                var model=JsonConvert.DeserializeObject<Restroom[]>(str);

                Assert.IsNotNull(model);
                Console.WriteLine(str);
            }
        }

        [TestMethod]
        public void TestGetNewPendingActRestrooms()
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");

                client.Headers.Add("sessionId", SessionId);
                client.Headers.Add("badge", Badge);
                client.Headers.Add("deviceGuid", DeviceGuid);
                
                RestroomUrl += "/getNewPendingActRestrooms?routeAlpha=&direction=&lat=&longt=&distance=";
                var result = client.DownloadData(RestroomUrl);

                Assert.IsNotNull(result);
                var str = System.Text.Encoding.ASCII.GetString(result);
                Assert.IsNotNull(str);
                var model = JsonConvert.DeserializeObject<Restroom[]>(str);

                Assert.IsNotNull(model);
                Console.WriteLine(str);
            }
        }

        [TestMethod]
        public void TestGetActRestrooms()
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");

                client.Headers.Add("sessionId", SessionId);
                client.Headers.Add("badge", Badge);
                client.Headers.Add("deviceGuid", DeviceGuid);

                RestroomUrl += "/getActRestrooms?routeAlpha=&direction=&lat=&longt=&distance=";
                var result = client.DownloadData(RestroomUrl);

                Assert.IsNotNull(result);
                var str = System.Text.Encoding.ASCII.GetString(result);
                Assert.IsNotNull(str);
                var model = JsonConvert.DeserializeObject<Restroom[]>(str);

                Assert.IsNotNull(model);
                Console.WriteLine(str);
            }
        }


        [TestMethod]
        public void TestUpadteActRestrooms()
        {
            using (var client = GetWebClient)
            {
                //client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                //client.Headers.Add(HttpRequestHeader.ContentType, "application/json");

                //client.Headers.Add("sessionId", SessionId);
                //client.Headers.Add("badge", Badge);
                //client.Headers.Add("deviceGuid", DeviceGuid);

                var getRestroomUrl =RestroomUrl +  "/getActRestrooms?routeAlpha=&direction=&lat=&longt=&distance=";
                var result = client.DownloadData(getRestroomUrl);


                Assert.IsNotNull(result);
                var str = System.Text.Encoding.ASCII.GetString(result);
                Assert.IsNotNull(str);
                var model = JsonConvert.DeserializeObject<Restroom[]>(str,new DbGeographyConverter());
                var restroom = model.FirstOrDefault(m => m.RestroomId == 190);
                if (restroom!=null)
                    restroom.SaturdayHours = "some hours";

                var saveRestroomUrl = RestroomUrl + "/postActRestroom";

                var dataStr = JsonConvert.SerializeObject(restroom);
                var data = System.Text.Encoding.ASCII.GetBytes(dataStr);

                //var saveResult=client.UploadData(saveRestroomUrl, data);

                using (var httpclient = GetHttpClient())
                {
                    var streamData=new MemoryStream(data);
                    streamData.Position = 0;
                    var content=new StreamContent(streamData);
                    var saveResult = httpclient.PostAsync(saveRestroomUrl, content).Result;
                    Console.WriteLine(saveResult);
                }

                Assert.IsNotNull(model);
                Console.WriteLine(str);
            }

          
        }


        private WebClient GetWebClient
        {
            get
            {
                var client = new WebClient();
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");

                client.Headers.Add("sessionId", SessionId);
                client.Headers.Add("badge", Badge);
                client.Headers.Add("deviceGuid", DeviceGuid);
                return client;
            }
        }

        private HttpClient GetHttpClient()
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("ContentType", "application/json");
            client.DefaultRequestHeaders.Add("sessionId", SessionId);
            client.DefaultRequestHeaders.Add("badge", Badge);
            client.DefaultRequestHeaders.Add("deviceGuid", DeviceGuid);

            
            return client;
        }

    }
}


public class DbGeographyConverter : JsonConverter
{
    private const string LATITUDE_KEY = "latitude";
    private const string LONGITUDE_KEY = "longitude";
    public override bool CanConvert(Type objectType)
    {
        return (objectType.Name == "DbGeography" && objectType.FullName == "System.Data.Entity.Spatial.DbGeography");
        //return objectType.IsAssignableFrom(typeof(string));
    }

    public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
    {
        if (reader.TokenType == JsonToken.Null)
            return default(DbGeography);

        JObject location = JObject.Load(reader);

        if (!location.HasValues || (location.Property(LATITUDE_KEY) == null || location.Property(LONGITUDE_KEY) == null))
            return default(DbGeography);

        JToken token = location["Geometry"]["WellKnownText"];
        string value = token.ToString();
        JToken sridToken = location["Geometry"]["CoordinateSystemId"];
        int srid;
        if (sridToken == null || int.TryParse(sridToken.ToString(), out srid) == false || value.Contains("SRID"))
        {
            //Set default coordinate system here.
            //NOTE: Geography should always have an SRID, and it has to match the data in the database else all comparisons will return NULL!
            srid = 0;
        }
        DbGeography converted;
        if (srid > 0)
            converted = DbGeography.FromText(value, srid);
        else
            converted = DbGeography.FromText(value);
        return converted;
    }

    public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
    {
        // Base serialization is fine
        serializer.Serialize(writer, value);
    }
}