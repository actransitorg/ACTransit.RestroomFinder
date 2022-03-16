using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace ACTransit.Framework.Notification
{
    public class SmsTwilioService
    {
        public SmsSection Settings { get; }
        public SmsTwilioService(SmsSection settings)
        {
            Settings = settings;
        }
        public void Send(string phoneNumber, string smsBody)
        {
            if (Settings == null)
                throw new NullReferenceException("SMS Setting is null");

            var accountSid = Settings.AccountSId;
            var requestUri = Settings.RequestUrl.Replace("{accountSid}", accountSid);
            var client = CreateHttpClient();
            var formData = CreateFormData(phoneNumber, smsBody);
            var request = new HttpRequestMessage(HttpMethod.Post, requestUri);
            try
            {
                request.Content = new FormUrlEncodedContent(formData);
                //var response = await client.SendAsync(request);
                var response = client.SendAsync(request).Result;
                Console.WriteLine("sent...");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public async Task SendAsync(string phoneNumber, string smsBody)
        {
            if (Settings == null)
                throw new NullReferenceException("SMS Setting is null");

            var accountSid = Settings.AccountSId;
            var requestUri = Settings.RequestUrl.Replace("{accountSid}", accountSid);
            var client = CreateHttpClient();
            var formData = CreateFormData(phoneNumber, smsBody);
            var request = new HttpRequestMessage(HttpMethod.Post, requestUri);
            try
            {
                request.Content = new FormUrlEncodedContent(formData);
                //var response = await client.SendAsync(request);
                var response = await client.SendAsync(request);
                Console.WriteLine("sent...");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private HttpClient CreateHttpClient()
        {
            var accountSid = Settings.AccountSId;
            var authToken = Settings.AuthToken;
            var url = Settings.BaseUrl;

            var client = new HttpClient();
            
            client.BaseAddress = new Uri(url);
            

            var byteArray = Encoding.ASCII.GetBytes($"{accountSid}:{authToken}");
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));

            return client;

        }

        private List<KeyValuePair<string, string>> CreateFormData(string phoneNumber, string smsBody)
        {
            var formData = new List<KeyValuePair<string, string>>();
            formData.Add(new KeyValuePair<string, string>("From", Settings.Numbers[0].ToString()));
            formData.Add(new KeyValuePair<string, string>("To", phoneNumber));
            formData.Add(new KeyValuePair<string, string>("Body", smsBody));
            return formData;
        }
    }
}
