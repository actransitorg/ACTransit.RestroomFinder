using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACTransit.Framework.DataAccess.Extensions
{
    public static class ExceptionExtensions
    {
        public static string GetStringRepresentation(this DbEntityValidationException ex)
        {
            var errTxt = "";
            if (ex.EntityValidationErrors != null && ex.EntityValidationErrors.Any())
            {
                foreach (var e in ex.EntityValidationErrors)
                {
                    var s = "";
                    foreach (var ve in e.ValidationErrors)
                    {
                        s += $"PropertyName: {ve.PropertyName}, ErrorMessage: {ve.ErrorMessage} \r\n";
                    }
                    errTxt += $"Entity: {e.Entry.Entity.ToString()}, error: {s} \r\n";
                }
            }

            return errTxt;
        }
    }
}
