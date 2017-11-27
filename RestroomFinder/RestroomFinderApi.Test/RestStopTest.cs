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

namespace RestroomFinderApi.Test
{
    [TestClass]
    public class RestStopTest
    {
        [TestMethod]
        public void GetAllRestStopsReturnsData()
        {
            var url = string.Format("{0}/RestStops?routeAlpha=&direction=&lat=37.8134679&longt=-122.30791699999999", Settings.BaseUrl);
            try
            {
                using (var client = new WebClient())
                {
                    var results = client.DownloadString(url);

                    var restStops = GetRestStops(results);

                    Assert.IsNotNull(restStops);
                    Assert.AreNotEqual(restStops.Count(), 0);

                    Console.WriteLine(results);
                    Assert.AreNotEqual(string.IsNullOrEmpty(results), true);
                }

            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        [TestMethod]
        public void GetRestStopReturnsData()
        {
            var url = string.Format("{0}/RestStops/1", Settings.BaseUrl);
            try
            {
                using (var client = new WebClient())
                {
                    var result = client.DownloadString(url);

                    var restStop = GetRestStop(result);

                    Assert.IsNotNull(restStop);
                    Console.WriteLine(result);
                    Assert.AreNotEqual(string.IsNullOrEmpty(result), true);
                }

            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        private IEnumerable<RestStop> GetRestStops(string json)
        {
            var serializer = new DataContractJsonSerializer(typeof(IEnumerable<RestStop>));
            using (var stream = new MemoryStream(Encoding.Unicode.GetBytes(json)))
            {
                return (IEnumerable<RestStop>)serializer.ReadObject(stream);
            }
        }

        private RestStop GetRestStop(string json)
        {
            var serializer = new DataContractJsonSerializer(typeof(RestStop));
            using (var stream = new MemoryStream(Encoding.Unicode.GetBytes(json)))
            {
                return (RestStop)serializer.ReadObject(stream);
            }
        }

        [DataContract(Name = "restStop")]
        private class RestStop
        {
            [DataMember(Name = "restStopID")]
            public short RestStopID { get; set; }

            [DataMember(Name = "restType")]
            public string RestType { get; set; }

            [DataMember(Name = "restName")]
            public string RestName { get; set; }

            [DataMember(Name = "address")]
            public string Address { get; set; }

            [DataMember(Name = "city")]
            public string City { get; set; }

            [DataMember(Name = "state")]
            public string State { get; set; }

            [DataMember(Name = "zip")]
            public int? Zip { get; set; }

            [DataMember(Name = "country")]
            public string Country { get; set; }

            [DataMember(Name = "drinkingWater")]
            public string DrinkingWater { get; set; }

            [DataMember(Name = "actRoute")]
            public string ACTRoute { get; set; }

            [DataMember(Name = "hours")]
            public string Hours { get; set; }

            [DataMember(Name = "note")]
            public string Note { get; set; }

            [DataMember(Name = "longDec")]
            public decimal? LongDec { get; set; }

            [DataMember(Name = "latDec")]
            public decimal? LatDec { get; set; }

            [DataMember(Name = "averageRating")]
            public decimal? AverageRating { get; set; }

            [DataMember(Name = "geo")]
            public DbGeography Geo { get; set; }
        }
    }
}
