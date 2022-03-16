using System;
using System.Net;
using System.Runtime.Serialization;

namespace ACTransit.RestroomFinder.API.Models
{
    [DataContract(Name = "feedback")]
    public class Feedback
    {
        [DataMember(Name="feedbackId")]
        public long FeedbackId { get; set; }

        [DataMember(Name = "restroomId")]
        public int RestroomId { get; set; }

        [DataMember(Name = "badge")]
        public string Badge { get; set; }

        [DataMember(Name = "needAttention")]
        public bool NeedAttention { get; set; }

        [DataMember(Name = "needRepair")]
        public bool NeedRepair { get; set; }

        [DataMember(Name = "needSupply")]
        public bool NeedSupply { get; set; }

        [DataMember(Name = "needCleaning")]
        public bool NeedCleaning { get; set; }

        [DataMember(Name = "closed")]
        public bool Closed { get; set; }

        [DataMember(Name = "feedbackText")]
        public string FeedbackText { get; set; }

        [DataMember(Name = "rating")]
        public decimal? Rating { get; set; }

        [DataMember(Name = "issue")]
        public string Issue { get; set; }

        [DataMember(Name = "issueStatus")]
        public string IssueStatus { get; set; }

        [DataMember(Name = "workRequestDescription")]
        public string WorkRequestDescription { get; set; }

        [DataMember(Name = "workRequestId")]
        public string WorkRequestId { get; set; }

        [DataMember(Name = "inspectionPassed")]
        public bool? InspectionPassed { get; set; }

        [DataMember(Name = "addDateTime")]
        public DateTime AddDateTime { get; set; }

        [DataMember(Name = "updDateTime")]
        public DateTime? UpdDateTime { get; set; }

        public Restroom Restroom { get; set; }

        internal static Feedback FromDataAccess(ACTransit.DataAccess.RestroomFinder.Feedback feedback)
        {
            return new Feedback
            {
                FeedbackId = feedback.FeedbackId,
                AddDateTime = feedback.AddDateTime,
                UpdDateTime = feedback.UpdDateTime,
                FeedbackText = feedback.FeedbackText,
                NeedAttention = feedback.NeedAttention,
                NeedCleaning = feedback.NeedCleaning??false,
                NeedRepair = feedback.NeedRepair ?? false,
                NeedSupply = feedback.NeedSupply ?? false,
                Closed= feedback.Closed ?? false,
                Badge = feedback.Badge,
                Rating = feedback.Rating,
                RestroomId = feedback.RestroomId,
                InspectionPassed = feedback.InspectionPassed

            };
        }

        internal ACTransit.DataAccess.RestroomFinder.Feedback ToDataAccess()
        {
            return new ACTransit.DataAccess.RestroomFinder.Feedback
            {
                FeedbackId = FeedbackId,
                AddDateTime = AddDateTime,
                UpdDateTime = UpdDateTime,
                FeedbackText = FeedbackText,
                NeedAttention = NeedAttention,
                NeedCleaning = NeedCleaning,
                NeedRepair = NeedRepair,
                NeedSupply = NeedSupply,
                Closed =  Closed,
                Badge = Badge,
                Rating = Rating,
                RestroomId = RestroomId,
                InspectionPassed = InspectionPassed
            };            
        }
    }
}