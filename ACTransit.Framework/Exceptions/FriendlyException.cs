using System;

namespace ACTransit.Framework.Exceptions
{
    public class FriendlyException : Exception
    {
        public string Tag { get; set; }
        public string RedirectUrl { get; set; }

        public FriendlyException(string message) : base(message){}
        public int ErrorCode { get; set; }

    }


}