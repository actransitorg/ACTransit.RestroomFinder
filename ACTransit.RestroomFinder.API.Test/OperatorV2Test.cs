using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using ACTransit.RestroomFinder.API;
using ACTransit.RestroomFinder.API.Models;

namespace ACTransit.RestroomFinder.API.Test
{
    [TestClass]
    public class OperatorV2Test
    {
        //private const string baseUrl = "https://devapi.actransit.org/restroom-finder/";
        private const string OperatorUrl = Common.baseAPIV2 + "Operator";

        [TestMethod]
        public void TestOperatorLogin()
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");                
                var model = new OperatorInfoViewModel
                {
                    //Badge = "207454",
                    Badge = "043160",
                    DeviceGuid = "1234",
                    Agreed = true,
                    IncidentDateTime = DateTime.Now,
                    Validating = false,
                    DeviceModel = "iPhone",
                    DeviceOS = "11.4",                                    

                };

                var jsonStr = JsonConvert.SerializeObject(model);
                var bytes=Encoding.ASCII.GetBytes(jsonStr);
                var result = client.UploadData(OperatorUrl,"POST",bytes);

                Assert.IsNotNull(result);
                var str = System.Text.Encoding.ASCII.GetString(result);
                Assert.IsNotNull(str);
                model=JsonConvert.DeserializeObject< OperatorInfoViewModel>(str);

                Assert.IsNotNull(model);
                Console.WriteLine(str);
            }
        }
        public void TestOperatorValidating()
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                var model = new OperatorInfoViewModel
                {
                    Badge = "43160",
                    DeviceGuid = "1234",
                    Agreed = true,
                    IncidentDateTime = DateTime.Now,
                    Validating = true,
                };

                var jsonStr = JsonConvert.SerializeObject(model);
                var bytes = Encoding.ASCII.GetBytes(jsonStr);
                var result = client.UploadData(OperatorUrl, "POST", bytes);
                Assert.IsNotNull(result);
                Console.WriteLine(result);
            }
        }

    }
}
