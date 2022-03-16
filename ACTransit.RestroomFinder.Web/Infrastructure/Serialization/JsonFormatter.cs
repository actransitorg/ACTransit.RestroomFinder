using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using ACTransit.RestroomFinder.Domain.Service;
using Newtonsoft.Json;

namespace ACTransit.RestroomFinder.Web.Infrastructure.Serialization
{
    public class JsonFormatter : BufferedMediaTypeFormatter
    {
        private readonly Log<JsonFormatter> log = new Log<JsonFormatter>();

        public JsonFormatter()
        {
            SupportedMediaTypes.Add(new MediaTypeHeaderValue("application/json"));
            //SupportedMediaTypes.Add(new MediaTypeHeaderValue("application/json-patch+json"));
            SupportedEncodings.Add(new UnicodeEncoding(false, true, true));
            log.Debug("JsonFormatter Created.");
        }

        public override bool CanReadType(Type type)
        {
            log.Debug("JsonFormatter.CanReadType");
            return true;
        }

        public override bool CanWriteType(Type type)
        {
            log.Debug("JsonFormatter.CanWriteType");
            return true;
        }

        public override void WriteToStream(Type type, object value, Stream writeStream, HttpContent content)
        {
            var tName = type.TypeName();
            log.Debug($"JsonFormatter.WriteToStream Entering, type: {tName}");
            try
            {
                using (var streamWriter = new StreamWriter(writeStream))
                {
                    using (var jw = new JsonTextWriter(streamWriter))
                    {
                        JsonSerializerSettings settings = null;
                        var requestContext = HttpContext.Current.Items["RequestContext"] as RequestContext;
                        if (requestContext?.SerializationResolver != null)
                        {
                            var resolver = (JsonSerializationResolver)Activator.CreateInstance(requestContext.SerializationResolver);
                            settings = resolver.Settings();
                        }
                        var serializer = JsonSerializer.Create(settings);
                        serializer.Serialize(jw, value);
                    }
                }
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("JsonFormatter.WriteToStream Done.");
            }
        }

        public override object ReadFromStream(Type type, Stream readStream, HttpContent content, IFormatterLogger formatterLogger)
        {
            var tName = type.TypeName();
            log.Debug($"JsonFormatter.ReadFromStream Entering, type: {tName}");
            JsonSerializer serializer = null;
            try
            {
                using (var streamReader = new StreamReader(readStream))
                {
                    using (var jw = new JsonTextReader(streamReader))
                    {
                        var requestContext = HttpContext.Current.Items["RequestContext"] as RequestContext;
                        serializer = new JsonSerializer();
                        if (requestContext?.SerializationResolver == null)
                            throw new Exception("SerializationResolver not defined");
                        return serializer.Deserialize(jw, type);
                    }
                }
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("JsonFormatter.WriteToStream Done.");
            }
            return serializer;
        }
    }
}