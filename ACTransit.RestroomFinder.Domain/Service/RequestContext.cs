using System;

namespace ACTransit.RestroomFinder.Domain.Service
{
    public class RequestContext
    {
        public Uri RequestUri { get; set; }
        public Uri ResponseUri { get; set; }
        public string CurrentUserName { get; set; }

        public Type SerializationResolver { get; set; }

        public string LogContextName { get; set; }   
    }
}
