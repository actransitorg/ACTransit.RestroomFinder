using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ACTransit.RestroomFinder.API.Test
{
    [TestClass]
    public class VersionTest
    {
        const int loopNumber = 50;
        [TestMethod]
        public void GetTestSync()
        {
           var url = string.Format("{0}/Version/GetTestSync", Settings.BaseUrl);
            try
            {
                Stopwatch watch=new Stopwatch();
                Task[] tasks=new Task[loopNumber];
                watch.Start();
                for (var i = 0; i < loopNumber; i++)
                {
                    tasks[i]=Task.Run(async() =>
                    {
                        using (var client = CreateWebClient())
                        {
                            var result = await client.DownloadStringTaskAsync(url + "?str=hello");
                            //Console.Write(result?.Substring(0, 1));
                        }
                    });
                }

                Task.WaitAll(tasks);
                watch.Stop();
                Console.WriteLine("Time:" + watch.ElapsedMilliseconds.ToString("###,###,###"));

            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        [TestMethod]
        public void GetTestASync()
        {
            var url = string.Format("{0}/Version/GetTestAsync", Settings.BaseUrl);
            try
            {
                Stopwatch watch = new Stopwatch();
                Task[] tasks = new Task[loopNumber];
                watch.Start();
                //Parallel.For(0,loopNumber,async index=>
                //{
                //    using (var client = CreateWebClient())
                //    {
                //        var result = await client.DownloadStringTaskAsync(url + "?str=hello");
                //        Console.Write(result?.Substring(0,1));
                //    }
                //});
                using (var client = CreateHttpClient())
                {
                    for (var i = 0; i < loopNumber; i++)
                    {                    
                        tasks[i] = client.GetByteArrayAsync(url + "?str=hello");
                        //tasks[i] = Task.Run(async () =>
                        //{
                        //    using (var client = CreateWebClient())
                        //    {
                        //        var result = await client.DownloadStringTaskAsync(url + "?str=hello");
                        //        //Console.Write(result?.Substring(0,1));
                        //    }
                        //});
                    }
                    Task.WaitAll(tasks);
                }
                    

                
                watch.Stop();
                Console.WriteLine("Time:" + watch.ElapsedMilliseconds.ToString("###,###,###"));

            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        [TestMethod]
        public void GetTestASync1()
        {
            var url = string.Format("{0}/Version/GetTestAsync1", Settings.BaseUrl);
            try
            {
                
                Stopwatch watch = new Stopwatch();
                Task[] tasks = new Task[loopNumber];
                watch.Start();
                for (var i = 0; i < loopNumber; i++)
                {
                    tasks[i] = Task.Run(async () =>
                    {
                        using (var client = CreateWebClient())
                        {
                            var result = await client.DownloadStringTaskAsync(url + "?str=hello");
                            //Console.Write(result?.Substring(0, 1));
                        }
                    });
                }

                Task.WaitAll(tasks);
                watch.Stop();
                Console.WriteLine("Time:" + watch.ElapsedMilliseconds.ToString("###,###,###"));

            }
            catch (Exception ex)
            {
                Assert.IsNull(ex, "Error hitting endpoint: " + ex.Message);
            }
        }

        private WebClient CreateWebClient()
        {
            var client = new WebClient();
            client.Headers[HttpRequestHeader.ContentType] = "text/json";
            return client;
        }

        private HttpClient CreateHttpClient()
        {
            HttpClient client =
                new HttpClient() { MaxResponseContentBufferSize = 1000000 };
            //client.DefaultRequestHeaders.Add("Content-Type", "text/json");
            return client;
            //var client = new WebClient();
            //client.Headers[HttpRequestHeader.ContentType] = "text/json";
            //return client;
        }
    }
}
