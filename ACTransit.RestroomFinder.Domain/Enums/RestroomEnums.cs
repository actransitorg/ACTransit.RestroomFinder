using System;
using System.ComponentModel;

namespace ACTransit.RestroomFinder.Domain.Enums
{
    public static class RestroomEnums
    {
        public enum RestroomReportType
        {
            Restrooms,
            Feedback
        }

        public enum RestroomApprovalStatus
        {
            Pending = 1,
            Approved = 2,
            InActive=3
        }

        public enum RestroomChangeType
        {
            [Description("#FFFFFF")]
            None,
            [Description("#D3F8BC")]
            Added,
            [Description("#F1BBA7")]
            Deleted,
            [Description("#F9F9A4")]
            Updated
        }

        [Flags]
        public enum ToiletGender
        {
            Men = 1,
            Women = 2,
            GenderNeutral = 4
        }
    }
}
