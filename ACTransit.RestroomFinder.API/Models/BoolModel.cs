using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ACTransit.RestroomFinder.API.Models
{
    public class BoolModel
    {
        public BoolModel() { }

        public BoolModel(bool value)
        {
            this.Value = value;

        }
        public bool Value { get; set; }
    }
}