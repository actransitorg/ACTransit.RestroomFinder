using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace ACTransit.RestroomFinder.API.Infrastructure
{
    public class FriendlyException : Exception
    {
        public string DebugString { get; set; }
        public FriendlyException(FriendlyExceptionType exceptionType)
            : base(GetMessage(exceptionType))
        {
            ExceptionType = exceptionType;
        }
        public FriendlyException(FriendlyExceptionType exceptionType, string message)
            : base(GetMessage(exceptionType) + ", " + message)
        {
            ExceptionType = exceptionType;
            
        }
        public FriendlyException(FriendlyExceptionType exceptionType, string message, string debugString)
            : base(GetMessage(exceptionType) + ", " + message)
        {
            ExceptionType = exceptionType;
            DebugString = debugString;
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
                    case FriendlyExceptionType.UnExpiredValid2FAuth:
                        result = HttpStatusCode.Forbidden;
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
                case FriendlyExceptionType.AccessDeniedNotActive:
                    message = "The user or device is not active.";
                    break;
                case FriendlyExceptionType.InvalidOrExpired2FAuth:
                    message = "The Security Code is invalid or expired.";
                    break;
                case FriendlyExceptionType.UnExpiredValid2FAuth:
                    message = "The Security Code has not expired yet.";
                    break;
                case FriendlyExceptionType.InvalidPhoneNumber:
                    message = "The phone number is not valid.";
                    break;
                case FriendlyExceptionType.DeviceIsNotSupported:
                    message = "The device is not supported, not found or is not active.";
                    break;
                case FriendlyExceptionType.AccessDeniedSessionMismatch:
                    message = "The session is invalid.";
                    break;
                case FriendlyExceptionType.AccessHasBeenRevoked:
                    message = "The access has been revoked.";
                    break;
                case FriendlyExceptionType.FeedbackTextRequired:
                    message = "Please give us your reasons for the rating.";
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
        AccessDeniedNotActive,
        InvalidOrExpired2FAuth,
        UnExpiredValid2FAuth,
        InvalidPhoneNumber,
        AccessDeniedSessionMismatch,
        AccessHasBeenRevoked,
        DeviceIsNotSupported,
        ObjectNotFound,
        InUseCanNotDelete,
        InvalidModelState,
        NameAlreadyExist,
        FeedbackTextRequired
        
    }
}