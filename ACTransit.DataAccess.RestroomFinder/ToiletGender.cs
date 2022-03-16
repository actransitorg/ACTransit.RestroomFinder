using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACTransit.DataAccess.RestroomFinder
{
    [Table("ToiletGender")]
    public partial class ToiletGender
    {
        public int ToiletGenderId { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
    }
}
