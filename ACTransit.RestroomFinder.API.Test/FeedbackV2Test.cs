using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using ACTransit.DataAccess.RestroomFinder;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ACTransit.RestroomFinder.API;

namespace ACTransit.RestroomFinder.API.Test
{
    [TestClass]
    public class FeedbackV2Test
    {
        private const string FeedbackUrl = Common.baseAPIV2 + "Feedback";

        [TestMethod]
        public void PostFeedbackSavesData()
        {
            var url = FeedbackUrl + "/post";
            var random = new Random(DateTime.Now.Millisecond);
            var feedback = new Feedback
            {
                FeedbackText = $"Unit Test Comment [Randomish #: {random.Next(100, 10000)}]",
                NeedAttention = true,
                Rating = random.Next(0, 4) + 1,
                RestroomId = 5,
                Badge="043160",
            };

            try
            {
                using (var client = new WebClient())
                {
                    client.Headers.Add(HttpRequestHeader.Accept, "application/json");
                    client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                    client.Headers.Add("sessionId", "1A27853968602564F55A35C43E9AE292521E30B0E2ACEC2446AC7E4B53C76B8F372C8D3B588CC4C5926FFA0A11EA0A72E7418CFF029F40BD4531DAC1AD54C6D2FCE943C08820F4AF6D7E7253583D73FB321961002E85AA8EE4FABC855DD1C2EE05715110FB9BAFC8CB94CD7CC04655531E2FB861C9734084FBF63D0428BAAB19F791870F416B074BD52662F5597382CA14ADE1E0D7B1B6BAE0A95181B933A87A899B0D73A16FEA7BC86E4E49FE0EA66AF5D67F0D1C31B8098A7844D5DC0036EA2EC2470F7A16475FBB34CE7A89B0225C1E4A685644A8048DCECFBC6EE8D044281941AD01E50C5897CF9C9884371C07A7A6128C76EC08B345FB9B5B59769EB317290BFDE1B7F5CE2753479D147562EAD8DCD03574ECB17247186B121D5B47F3B306CDCEA3B734BE89A7301C7FF9DD5DD09D9051BC81E0029FDD37E3509DFCEA39471B567CB98D9944F0618FD0170EAD1A5ACBC79799F0E63D24E451E3EEF91555221CDD39E4A50E056B3B2C6646032D18D60F3E26AC41B7641D8A416F616944A0724582D8B4F6403E87347755919356E53A5B138BC3556D125D567DE6878CC3AD0EAE45C031B1D47DF788113CC6663C83C643DC6ECC524959AD8EDF22D54C0EBA");

                    //client.Headers[HttpRequestHeader.ContentType] = "text/json";
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

        //[DataContract(Name = "feedback")]
        //private class Feedback
        //{
        //    [DataMember(Name = "feedbackID")]
        //    public int FeedbackId { get; set; }

        //    [DataMember(Name = "restStopID")]
        //    public short RestroomId { get; set; }

        //    [DataMember(Name = "needAttention")]
        //    public bool NeedAttention { get; set; }

        //    [DataMember(Name = "feedbackText")]
        //    public string FeedbackText { get; set; }

        //    [DataMember(Name = "rate")]
        //    public float? Rating { get; set; }

        //    //HACK: Due to the way JSON is serialized, it cannot be (easily) deserialized with DateTimes in the provided format.  Quick hack is to mark these as strings which is not a big deal with these simple tests.
        //    [DataMember(Name = "addDateTime")]
        //    public string AddDateTime { get; set; }

        //    [DataMember(Name = "updDateTime")]
        //    public string UpdDateTime { get; set; }
        //}
    }
}
