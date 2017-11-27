using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RestroomFinderAPI.Infrastructure
{
    public static class Extensions
    {
        public static bool IsNumeric(this String str)
        {
            int n;
            return int.TryParse(str, out n);
        }
    }
}