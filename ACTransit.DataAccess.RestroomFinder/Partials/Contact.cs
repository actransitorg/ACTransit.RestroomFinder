using System.Collections.Generic;
using ACTransit.Framework.Interfaces;

namespace ACTransit.DataAccess.RestroomFinder
{
    public partial class Contact: IAuditableEntity
    {


        public ICollection<Restroom> Restrooms{ get; set; }

        public ICollection<Restroom> RestroomsIClean { get; set; }
        public ICollection<Restroom> RestroomsIRepair{ get; set; }
        public ICollection<Restroom> RestroomsISupply{ get; set; }
        public ICollection<Restroom> RestroomsGateIProtect{ get; set; }
        public ICollection<Restroom> RestroomsLockIProtect { get; set; }


    }
}
