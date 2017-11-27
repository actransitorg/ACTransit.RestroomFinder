using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace RestroomFinderAPI.Infrastructure
{
    public class FriendlyException : Exception
    {
        public FriendlyException(FriendlyExceptionType exceptionType)
            : base(GetMessage(exceptionType))
        {
            ExceptionType = exceptionType;
        }

        public FriendlyException(string message) : base(message)
        {
            ExceptionType = FriendlyExceptionType.Other;
        }

        public FriendlyExceptionType ExceptionType { get; private set; }
        public HttpStatusCode Code
        {            
            get
            {
                var result = HttpStatusCode.InternalServerError;
                switch (ExceptionType)
                {
                    case FriendlyExceptionType.AccessDenied:
                        result = HttpStatusCode.Unauthorized;
                        break;
                    case FriendlyExceptionType.ObjectNotFound:
                        result = HttpStatusCode.NotFound;
                        break;
                    case FriendlyExceptionType.InvalidModelState:
                        result = HttpStatusCode.BadRequest;
                        break;
                }
                return result;
            }
        }

        private static string GetMessage(FriendlyExceptionType exceptionType)
        {
            string message;
            switch (exceptionType)
            {
                case FriendlyExceptionType.PsMismatch:
                    message = "PeopleSoft data has changed. please refresh your page and try again.";
                    break;
                case FriendlyExceptionType.AccessDenied:
                    message = "You don't have enough access privileges for this operation.";
                    break;
                case FriendlyExceptionType.ObjectNotFound:
                    message = "The object you are looking for could not be found.";
                    break;
                case FriendlyExceptionType.InUseCanNotDelete:
                    message = "In use, can't be deleted.";
                    break;
                case FriendlyExceptionType.InvalidModelState:
                    message = "Some of the values are not valid.";
                    break;
                case FriendlyExceptionType.NameAlreadyExist:
                    message = "The Name is taken, please choose another name.";
                    break;
                default:
                    message = "Some error occured.";
                    break;
            }
            return message;
        }

      
    }

    public enum FriendlyExceptionType
    {
        Other,

        /// <summary>
        /// PeopleSoft data mismatch
        /// </summary>
        PsMismatch,
        AccessDenied,
        ObjectNotFound,
        InUseCanNotDelete,
        InvalidModelState,
        NameAlreadyExist
    }
}