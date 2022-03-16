using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACTransit.Framework.Interfaces
{
    public interface ITemporalEntity
    {
        [NotMapped]
        DateTime ValidFrom { get; set; }
        [NotMapped]
        DateTime ValidTo { get; set; }
    }
}
