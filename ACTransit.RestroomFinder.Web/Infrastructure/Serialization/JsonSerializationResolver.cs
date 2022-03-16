using System;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace ACTransit.RestroomFinder.Web.Infrastructure.Serialization
{
    public class JsonSerializationResolver
    {
        private readonly Log<JsonSerializationResolver> log = new Log<JsonSerializationResolver>();
        protected static DefaultContractResolver JsonResolver = new IgnorableSerializerContractResolver();

        public JsonSerializationResolver()
        {
            log.Debug("JsonSerializationResolver Created.");
        }

        public Type DeserializeType { get; protected set; }

        public virtual JsonSerializerSettings Settings()
        {
            log.Debug("JsonSerializationResolver.Settings Entering.");
            JsonSerializerSettings result = null;
            try
            {
                result = new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
                    //PreserveReferencesHandling = PreserveReferencesHandling.All,
                    ContractResolver = JsonResolver
                };
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("JsonSerializationResolver.Settings Done.");
            }
            return result;
        }
    }
}