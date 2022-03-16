using System.Collections.Generic;
using System.Web.Mvc;

namespace ACTransit.RestroomFinder.Web.Infrastructure
{
    public static class Converter
    {
        public static SelectListItem ToSelectListItem(KeyValuePair<string, string> item, bool isSelected = false)
        {
            return new SelectListItem {Text = item.Key, Value = item.Value, Selected = isSelected };
        }
    }
}