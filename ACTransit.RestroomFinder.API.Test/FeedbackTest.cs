using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ACTransit.RestroomFinder.API.Test
{
    [TestClass]
    public class FeedbackTest
    {
        [TestMethod]
        public void PostFeedbackSavesData()
        {
            var random = new Random(DateTime.Now.Millisecond);
            var feedback = new Feedback
            {
                FeedbackText = $"Unit Test Comment [Randomish #: {random.Next(100, 10000)}]",
                NeedAttention = true,
                Rate = random.Next(0, 4) + 1,
                RestStopID = 5
            };

            var url = string.Format("{0}/feedback", Settings.BaseUrl);
            try
            {
                using (var client = new WebClient())
                {
                    client.Headers[HttpRequestHeader.ContentType] = "text/json";
                    var result = client.UploadString(url, "POST", GetJsonString(feedback));

                    Console.WriteLine(result);
                    Assert.AreNotEqual(string.IsNullOrEmpty(result), true);
                }
            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        [TestMethod]
        public void GetFeedbackForStopHasData()
        {
 
            var url = string.Format("{0}/feedback?restStopID=5", Settings.BaseUrl);
            try
            {
                using (var client = new WebClient())
                {
                    var result = client.DownloadString(url);

                    var feedbackList = GetFeedbackListFromJson(result);
                    Assert.IsNotNull(feedbackList);
                    Assert.AreNotEqual(feedbackList.Count(), 0);

                    Console.WriteLine(result);
                    Assert.AreNotEqual(string.IsNullOrEmpty(result), true);
                }
            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }           
        }

        private string GetJsonString(Feedback feedback)
        {
            using (var stream = new MemoryStream())
            {
                var serializer = new DataContractJsonSerializer(typeof(Feedback));
                serializer.WriteObject(stream, feedback);

                stream.Position = 0;
                using (var reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }
            }
        }

        private IEnumerable<Feedback> GetFeedbackListFromJson(string json)
        {
            using (var stream = new MemoryStream(Encoding.Unicode.GetBytes(json)))
            {
                var serializer = new DataContractJsonSerializer(typeof(IEnumerable<Feedback>));
                return (IEnumerable<Feedback>)serializer.ReadObject(stream);
            }
        }

        [DataContract(Name = "feedback")]
        private class Feedback
        {
            [DataMember(Name = "feedbackID")]
            public int FeedbackId { get; set; }

            [DataMember(Name = "restStopID")]
            public short RestStopID { get; set; }

            [DataMember(Name = "needAttention")]
            public bool NeedAttention { get; set; }

            [DataMember(Name = "feedbackText")]
            public string FeedbackText { get; set; }

            [DataMember(Name = "rate")]
            public float? Rate { get; set; }

            //HACK: Due to the way JSON is serialized, it cannot be (easily) deserialized with DateTimes in the provided format.  Quick hack is to mark these as strings which is not a big deal with these simple tests.
            [DataMember(Name = "addDateTime")]
            public string AddDateTime { get; set; }

            [DataMember(Name = "updDateTime")]
            public string UpdDateTime { get; set; }
        }
    }
}
