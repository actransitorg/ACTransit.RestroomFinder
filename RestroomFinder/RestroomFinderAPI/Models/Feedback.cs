using System;
using System.Runtime.Serialization;

namespace RestroomFinderAPI.Models
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

        [DataMember(Name = "feedbackText")]
        public string FeedbackText { get; set; }

        [DataMember(Name = "rate")]
        public decimal? Rate { get; set; }

        [DataMember(Name = "addDateTime")]
        public DateTime AddDateTime { get; set; }

        [DataMember(Name = "updDateTime")]
        public DateTime? UpdDateTime { get; set; }

        internal static Feedback FromDataAccess(ACTransit.DataAccess.RestroomFinder.Feedback feedback)
        {
            return new Feedback
            {
                FeedbackId = feedback.FeedbackId,
                AddDateTime = feedback.AddDateTime,
                UpdDateTime = feedback.UpdDateTime,
                FeedbackText = feedback.FeedbackText,
                NeedAttention = feedback.NeedAttention,
                Badge = feedback.Badge,
                Rate = feedback.Rate,
                RestroomId = feedback.RestroomId

            };
        }

        internal ACTransit.DataAccess.RestroomFinder.Feedback ToDataAccess()
        {
            return new ACTransit.DataAccess.RestroomFinder.Feedback
            {
                FeedbackId = this.FeedbackId,
                AddDateTime = this.AddDateTime,
                UpdDateTime = this.UpdDateTime,
                FeedbackText = this.FeedbackText,
                NeedAttention = this.NeedAttention,
                Badge = this.Badge,
                Rate = this.Rate,
                RestroomId = this.RestroomId
            };            
        }
    }
}