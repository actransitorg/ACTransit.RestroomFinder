using System;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace ACTransit.Framework.DataAccess.Extensions
{
    public static class OrderedQueryable
    {
        public static async Task<PagedResult<T>> GetPagedAsync<T>(this IOrderedQueryable<T> query, int page = 1, int pageSize = 1) where T : class
        {
            var result = new PagedResult<T>
            {
                CurrentPage = page,
                PageSize = pageSize,
                RowCount = query.Count()
            };

            var pageCount = (double) result.RowCount / pageSize;
            result.PageCount = (int) Math.Ceiling(pageCount);

            var skip = (page - 1) * pageSize;
            result.Results = await query.Skip(skip).Take(pageSize).ToListAsync();

            return result;
        }

        public static PagedResult<T> GetPaged<T>(this IOrderedQueryable<T> query, int page = 1, int pageSize = 1) where T : class

        {
            var result = new PagedResult<T>
            {
                CurrentPage = page,
                PageSize = pageSize,
                RowCount = query.Count()
            };

            var pageCount = (double) result.RowCount / pageSize;
            result.PageCount = (int) Math.Ceiling(pageCount);

            var skip = (page - 1) * pageSize;
            result.Results = query.Skip(skip).Take(pageSize).ToList();

            return result;
        }
    }
}
