using System;
using System.Web;
using ACTransit.DataAccess.RestroomFinder;
using ACTransit.RestroomFinder.Web.Infrastructure.Serialization;
using Newtonsoft.Json;

namespace ACTransit.RestroomFinder.Web.Infrastructure.Resolver
{
    public class RestroomResolver : JsonSerializationResolver
    {
        private readonly Log<RestroomResolver> log = new Log<RestroomResolver>();
        public RestroomResolver()
        {
            log.Debug("RestroomResolver Created.");
            DeserializeType = typeof(Restroom);
        }

        public override JsonSerializerSettings Settings()
        {
            log.Debug("JsonSerializerSettings.Settings Entering.");
            JsonSerializerSettings result = null;
            try
            {
                var resolver = (IgnorableSerializerContractResolver)JsonResolver;
                // TODO: Add virtual collections here
                //resolver.Ignore(typeof(Billing));
                //resolver.Ignore(typeof(District));
                result = base.Settings();
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("JsonSerializer.Settings Done.");
            }
            return result;           
        }
    }
}