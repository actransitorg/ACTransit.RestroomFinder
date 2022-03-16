using System.Collections.Generic;
using ACTransit.DataAccess.RestroomFinder.Core.Contexts;
using ACTransit.DataAccess.RestroomFinder.Core.Entities;
using ACTransit.DataAccess.RestroomFinder.Core.Repositories;
using Microsoft.EntityFrameworkCore;

namespace ACTransit.RestroomFinder.Core.Domain.Services
{
    public class RestroomService
    {
        protected readonly DbContextOptions<RestroomFinderContext> DbOptions;

        public RestroomService(DbContextOptions<RestroomFinderContext> dbOptions)
        {
            DbOptions = dbOptions;
        }

        public IReadOnlyCollection<Restroom> GetRestrooms()
        {
            return new RestroomRepository(DbOptions).GetRestrooms();
        }

       
    }
}
