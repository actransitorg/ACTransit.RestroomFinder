using System.ComponentModel.DataAnnotations;

namespace ACTransit.DataAccess.RestroomFinder
{
    public class RestroomContactReport
    {
        [Key]
        public int RestroomId { get; set; }

        public string RestroomName { get; set; }

        public string LabelId { get; set; }

        public string Status { get; set; }

        public string OwnedServiceProvider { get; set; }

        public int? OwnedContactId { get; set; }

        public string CleanedServiceProvider { get; set; }

        public int? CleanedContactId { get; set; }

        public string RepairedServiceProvider { get; set; }

        public int? RepairedContactId { get; set; }

        public string SuppliedServiceProvider { get; set; }

        public int? SuppliedContactId { get; set; }

        public string SecurityGateServiceProvider { get; set; }

        public int? SecurityGateContactId { get; set; }

        public string SecurityLockServiceProvider { get; set; }

        public int? SecurityLockContactId { get; set; }
    }
}
