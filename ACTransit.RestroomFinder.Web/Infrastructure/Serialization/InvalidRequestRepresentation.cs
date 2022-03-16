using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.ModelBinding;

namespace ACTransit.RestroomFinder.Web.Infrastructure.Serialization
{
    public class InvalidRequestRepresentation
    {
        private readonly Log<InvalidRequestRepresentation> log = new Log<InvalidRequestRepresentation>();

        public InvalidRequestRepresentation(ModelStateDictionary modelState, object request)
        {
            log.Debug("InvalidRequestRepresentation Creating.");
            try
            {
                Request = request;
                Messages = new Dictionary<string, IEnumerable<string>>();
                foreach (var pair in modelState)
                {
                    Messages.Add(pair.Key, pair.Value.Errors.Select(x => x.ErrorMessage));
                }
            }
            catch (Exception e)
            {
                log.Error(e);
            }
            finally
            {
                log.Debug("InvalidRequestRepresentation Created.");
            }
        }
        public object Request { get; set; }
        public Dictionary<string, IEnumerable<string>> Messages { get; set; }
        public override string ToString()
        {
            return Messages.Keys.SelectMany(key => Messages[key]).Aggregate("", (current, item) => current + item);
        }
    }
}